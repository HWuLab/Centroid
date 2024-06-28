function S = mywave(d,sigth,j1p,detrendMethod,plotF)
if nargin <= 3,     detrendMethod = 'detrend1'; end
detrendMethod = str2num(detrendMethod(end));   


dt = 1 ;   %amount of time between each Y value, i.e. the sampling time

scaleRange = [9,13];

if isvector(d)
    time = [1:length(d)]';
    data = d(:);
else    
    time = d(:,1);  
    data = double(d(:,2));
end

dj = 0.05;    % this will do 4 sub-octaves per octave, 
j1 = j1p/dj;    % 7/dj   this says do 7 powers-of-two with dj sub-octaves each   
j1 = round(j1);
dj = j1p/j1;

% detrend
switch detrendMethod
    case 1
        data = detrend(data);
    case 2
        data = data - polyval(polyfit([1:length(data)]', data, 2),[1:length(data)]'); 
    case 3
        data = data - polyval(polyfit([1:length(data)]', data, 3),[1:length(data)]'); 
end
ac = autocorr(data,1);
lag1 = ac(2);

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigth = sort(sigth,'descend');
n_sig = length(sigth);

variance = std(data)^2;
data = (data - mean(data))/sqrt(variance) ;
n = length(data);

xlim = [time(1),time(end)];  % plotting range

pad = 1;      % pad the time series with zeroes (recommended)
s0 = 2*dt;    % 2*dt   this says start at a scale of 6 months  
mother = 'Morlet';  %'Morlet'  'Paul'

% Wavelet transform:
[wave,period,scale,coi] = wavelet(data,dt,pad,dj,s0,j1,mother);
power = (abs(wave)).^2 ;        % compute wavelet power spectrum

% calculate plot (b)
for ii = 1:n_sig
    pb(ii) = calsigb(dt,scale,lag1,sigth(ii),mother,n,power);
end

% calculate plot (c)
for ii = 1:n_sig
    pc(ii) = calsigc(variance,dt,scale,lag1,sigth(ii),mother,power,n);
end

% calculate plot (d)
for ii = 1:n_sig
    pd(ii) = calsigd(variance,dt,scale,lag1,sigth(ii),scaleRange,mother,power,dj,n);
end

%%
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot (b)
subplot('position',[0.1 0.4 0.62 0.53])
lty = ["-","--","-.",":"];
levels = [0.0625,0.125,0.25,0.5,1,2,4,8,16] ;
Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
% #################################
Yticks = [4,8,11,15,20,25];
% contour(time,log2(period),log2(power),log2(levels));  %*** or use 'contourf' 'LineStyle','none'
imagesc(time,log2(period),log2(power));  %*** uncomment for 'image' plot

% colorbar
cm = slanCM('YlGnBu',100);
colormap(cm(1:end-10,:));

clim=get(gca,'clim'); %center color limits around log2(1)=0
% colormap('turbo')
clim=[-1 1]*max(clim(2),3);
set(gca,'clim',clim)

% colorbar
% HCB=colorbar;
% set(HCB,'ytick',-7:7);
% barylbls=rats(2.^(get(HCB,'ytick')'));
% barylbls([1 end],:)=' ';
% barylbls(:,all(barylbls==' ',1))=[];
% set(HCB,'yticklabel',barylbls,'FontSize',12);

xlabel('Time (year)')
ylabel('Period (years)')
% title(['Wavelet Power Spectrum, sig = ',sprintf('%.2f,',sigth)])
% title(['Wavelet Power Spectrum'])
set(gca,'XLim',xlim(:))
set(gca,'YLim',log2([min(period),max(period)]), ...
	'YDir','reverse', ...
	'YTick',log2(Yticks(:)), ...
	'YTickLabel',Yticks)
% 95% significance contour, levels at -99 (fake) and 1 (95% signif)
hold on
for ii = 1:n_sig
    contour(time,log2(period),pb(ii).sig95,[-99,1],'k','linestyle',lty(ii),'linewidth',1);
end
% cone-of-influence, anything "below" is dubious
%  plot(time,log2(coi),'k')
time2=[time([1 1])-dt*.5;time;time([end end])+dt*.5];
hcoi=fill(time2,log2([period([end 1]) coi period([1 end])]),'w');
set(hcoi,'alphadatamapping','direct','facealpha',.4,'edgecolor',repmat(0.99,1,3))
set(gca,'FontSize',12)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot (c)
if plotF(2) > 0
    subplot('position',[0.75 0.4 0.2 0.53])
    plot(pc(1).global_ws,log2(period),'linewidth',1.1)
    S.pc(1).global_ws = pc(1).global_ws;
    S.period = period;
    hold on
    for ii = 1:n_sig
        plot(pc(ii).global_signif,log2(period),'k','linestyle',lty(ii),'linewidth',0.8);
        S.pc(ii).global_signif = pc(ii).global_signif;
    end
    xlabel('Power')
%     title('Global Wavelet Spectrum')
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel','')
    set(gca,'XLim',[0,1.25*max(pc(1).global_ws)])
    set(gca,'xtick',[0,3,6].*10^5);
    legend_str = cellstr(num2str(sigth', '%.2f'));
    legend_str = [{''};legend_str];
    set(gca,'FontSize',12)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotF(3) > 0
    subplot('position',[0.1 0.1 0.87 0.20])
    plot(period,pc(1).global_ws)
    hold on
    for ii = 1:n_sig
        plot(period,pc(ii).global_signif,'r','linestyle',lty(ii));
    end
    xlabel('Period')
    ylabel('Power')
    title('Global Wavelet Spectrum')
    set(gca,'XLim',[0,1.25*max(pc(1).global_ws)])
    set(gca,'XLim',[min(period),max(period)],...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel','')

    legend_str = cellstr(num2str(sigth', '%.2f'));
    legend_str = [{''};legend_str];
%     legend(legend_str,'location','northwest')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plotF(4) > 0
    figure
    plot(time,pd(1).scale_avg)
    set(gca,'XLim',xlim(:))
    xlabel('Time (year)')
    ylabel('Avg variance (unit^2)')
    title([num2str(scaleRange(1)),'-',num2str(scaleRange(2)),' yr Scale-average Time Series'])
    hold on
    for ii = 1:n_sig
        plot(xlim,pd(ii).scaleavg_signif+[0,0],'--');
    end
    hold off
end
end

%%
function pb = calsigb(dt,scale,lag1,sigth,mother,n,power)    
    [signif,fft_theor] = wave_signif(1.0,dt,scale,0,lag1,sigth,-1,mother); 
    sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
    sig95 = power ./ sig95;
    pb.signif = signif;
    pb.fft_theor = fft_theor;
    pb.sig95 = sig95;
end

% Global wavelet spectrum & significance levels:
function pc = calsigc(variance,dt,scale,lag1,sigth,mother,power,n)
    global_ws = variance*(sum(power')/n);   % time-average over all times
    dof = n - scale;  % the -scale corrects for padding at edges
    global_signif = wave_signif(variance,dt,scale,1,lag1,sigth,dof,mother);
    pc.global_ws = global_ws;
    pc.global_signif = global_signif;
end

function pd = calsigd(variance,dt,scale,lag1,sigth,scaleRange,mother,power,dj,n)
    avg = find((scale >= scaleRange(1)) & (scale < scaleRange(2)));
    Cdelta = 0.776;   % this is for the MORLET wavelet
    scale_avg = (scale')*(ones(1,n));  % expand scale --> (J+1)x(N) array
    scale_avg = power ./ scale_avg;   % [Eqn(24)]
    scale_avg = variance*dj*dt/Cdelta*sum(scale_avg(avg,:));   % [Eqn(24)]
    scaleavg_signif = wave_signif(variance,dt,scale,2,lag1,sigth,scaleRange,mother);
    pd.scale_avg = scale_avg;
    pd.scaleavg_signif = scaleavg_signif;
end

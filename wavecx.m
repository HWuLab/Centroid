function wavecx(d,sunspot,yrRange)
% cross-wavelet transform and wavelet coherence analyses between
% displacement series and sunspot number
t1 = sunspot(sunspot(:,1)>=yrRange(1) & sunspot(:,1)<=yrRange(end),2);
t1 = detrend(t1);

%% longitudinal
t2 = d(2).dist(d(2).dist(:,1)>=yrRange(1) & d(2).dist(:,1)<=yrRange(end),2);
t2 = detrend(t2);
figure
wtcXG(t1,t2,'ArrowDensity',[25,25]);

title('Wavelet coherence (longitudinal)')  
set(gca,'xtick',1:20:2000,'xticklabel',yrRange(1):20:2030); 
set(gcf,'Position',[645 651 560 420]);
figure
xwtXG(t1,t2);
title('Cross-wavelet (longitudinal)');
set(gca,'xtick',1:20:2000,'xticklabel',yrRange(1):20:2030);
set(gcf,'Position',[645 155 560 420]);

%% latitudinal
t2 = d(3).dist(d(3).dist(:,1)>=yrRange(1) & d(3).dist(:,1)<=yrRange(end),2);
t2 = detrend(t2);
figure
wtcXG(t1,t2,'ArrowDensity',[25,25]);

title('Wavelet coherence (latitudinal)') ; 
set(gca,'xtick',1:20:2000,'xticklabel',yrRange(1):20:2030); 
set(gcf,'Position',[1205 651 560 420]);
figure
xwtXG(t1,t2)
title('Cross-wavelet (latitudinal)');
set(gca,'xtick',1:20:2000,'xticklabel',yrRange(1):20:2030);
set(gcf,'Position',[1205 155 560 420]);
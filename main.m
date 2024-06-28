% Run in R2021a, windows 10
% need install toolbox:
%         Torrence & Compo Wavelet Analysis Software (https://paos.colorado.edu/research/wavelets/)
%         Cross wavelet and wavelet coherence (https://www.glaciology.net/publication/2004-12-24-application-of-the-cross-wavelet-transform-and-wavelet-coherence-to-geophysical-time-series/)
%         200 colormap V1.1.0 (https://www.mathworks.com/matlabcentral/fileexchange/120088-200-colormap?s_tid=srchtitle)

% load sunspot number data
sunspot = readmatrix('J:\09Cat\0901Data\Sunspots\SN_m_tot_V2.0.csv');
sunspot = monthStat(sunspot(:,[1,2,4]),[-9,8],@sum);
sunspot = sunspot(sunspot(:,1)>=1950 &sunspot(:,1)<=2021,:);

% load CRU PDSI dataset
load ipdsi.mat

% calculat displacement and wavelet analysis
dist = [];
for kk = 1:2
    switch kk
        case 1
            areaRange = [60,150,0,60];   % Aisa's lon lat range
        case 2
            areaRange = [-140,-50,15,60]; % North America's lon lat range
    end
    % ipdsi.scpdsiBari is the dataset of CRU PDSI, including PDSI, corresponding area, lon, lat, vector of year
    % ipdsiClip extract PDSI data in Asia or North America
    S = ipdsiClip(ipdsi.scpdsiBari, areaRange);  %ipdsi.scpdsiBari  cookpdsi(7)
    pdsi_th = -1;   % PDSI threshold of drought
    area_th = 20;    % continuous area threshold, unit x10^4 km2
    % cInfoMat calculate annual drought centroids, output lon lat
    [cinfo,flagMat] = cInfoMat(S,pdsi_th,area_th);
    
    % close all
    % cdist calculate displacement from annual centroid   
    [d,c,S] = cdist(cinfo,[1950,2021], [-200,200,-200,200] );  
    % close all
    % cross-wavelet transform and wavelet coherence analyses 
    wavecx(d,sunspot,[1950,2021])  %min(2021,sunspot(end,1))
      
    % save data 
    if kk == 1
        globalSpectraPeak = S;  % data for plot global spectra of displacement
        centroid_Asia = c;
    elseif kk == 2
        globalSpectraPeak = S;  
        centroid_NA = c;
    end
    dist(kk).dx = d(2).dist;
    dist(kk).dy = d(3).dist;
    dist(kk).d = d(1).dist;
end

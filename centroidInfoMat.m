function [centroid_info,pdsiFlagMat] = centroidInfoMat(pdsiMat, xx, yy, area_grid, pdsi_th, area_th)
% % Calculate lon lat of centriods for a year
% input：pdsiMat is PDSI value matrix
%      xx, yy are corresponding lon, lat
%      th drought threshold
%      area_gird is corresponding area of grids
%      area_th is the continuous area threshold, unit km2


area_th = area_th*10000;
minLon = min(xx(:));
maxLat = max(yy(:));
interval = abs(yy(2)-yy(1));

% PDSI value less than drought threshold set to 1
pdsiFlagMat = pdsiMat;
pdsiFlagMat(pdsiFlagMat > pdsi_th) = 0;
pdsiFlagMat(pdsiFlagMat <= pdsi_th) = 1;

% search of continuous drought area
xc = [];  % lon for continuous drought area
yc = [];  % lat for continuous drought area
areac = [];  % area of continuous drought area
intensityc = []; % area-weighted PDSI of continuous drought area
centroid_info = [];

k = 2;  % each cluster using same flag, start with flag=2
while ~isempty(find(pdsiFlagMat==1))  % if there is a grid less than drought threshold
    [row0,col0] = find(pdsiFlagMat==1);
    pdsiFlagMat = round8conti(pdsiFlagMat,row0(1),col0(1),k);   % change the flag, flag=2,3,4,...
    [x,y,area,intensity] = centroidWMat(pdsiFlagMat,pdsiMat,area_grid,k,minLon,maxLat,interval);  
    
    % flag add 1, in this loop, add the flag to all the non-NAN (land)、non-zero (drought grid) grids
    k = k+1;   
   
    % save infomation of the continuous drought area
    xc = [xc;x];
    yc = [yc;y];
    areac = [areac;area];
    intensityc = [intensityc;intensity];    
end

% Merge the information
k_list = [2:k-1]';
idx = areac>area_th; % only keep continuous drought area exceeding the area threshold
% lon, lat, area, area-weighted PDSI, flag
centroid_info = [xc(idx),yc(idx),areac(idx),intensityc(idx),k_list(idx)];



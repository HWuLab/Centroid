function [centroid_info,pdsiFlagMat] = cInfoMat(S, pdsi_th, area_th)
% Calculate lon lat of centriods for all the years, 
% based on output of centroidInfoMat (Calculate lon lat of centriods for a year)

pdsi3dim = S.pdsi;
xx = S.xx;
yy = S.yy;
area_grid = S.area_grid;

centroid_info = [];
for ii = 1:size(pdsi3dim,3)
    [centroid_info_1year,pdsiFlagMat(:,:,ii)] = centroidInfoMat(pdsi3dim(:,:,ii), xx, yy, area_grid, pdsi_th, area_th);
    centroid_info = [centroid_info;   repmat( S.yr_list(ii),size(centroid_info_1year,1),1 ),  centroid_info_1year ];    
end
centroid_info(:,4) = centroid_info(:,4)./1000000;
centroid_info = [centroid_info,   centroid_info(:,4) .* centroid_info(:,5)];


function [x,y,area,intensity] = centroidWMat(pdsiFlagMat,pdsiMat,area_grid,k,minLon,maxLat,interval)
% calculate area-weighted centroid information 
% output: x,y (lon,lat)
[row,col] = find(pdsiFlagMat==k);
area = 0;
areaw = 0;
x = 0;
y = 0;
for ii = 1:length(row)
    x = x + col(ii) .* area_grid(row(ii),col(ii)) .* pdsiMat(row(ii),col(ii)) .* -1;
    y = y + row(ii) .* area_grid(row(ii),col(ii)) .* pdsiMat(row(ii),col(ii)) .* -1;
    areaw = areaw + area_grid(row(ii),col(ii)) .* pdsiMat(row(ii),col(ii)) .*-1;
    area = area + area_grid(row(ii),col(ii));
end
x = x./areaw;
y = y./areaw;
% convert index (row, col) to lon lat
x = (x-1).*interval + minLon;   
y = maxLat - (y-1).*interval;  
intensity = areaw./area;
    
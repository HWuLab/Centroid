function coord = centroid1ly(cinfo,isinterp)
% calculate a centroid from clusters (centroids) of a year

yr = unique(cinfo(:,1));

x=[]; y = [];

for ii = 1:length(yr)
    logi = cinfo(:,1) == yr(ii);
    temp = cinfo(logi,:);
    x(ii,1) = wmean( temp(:,2),temp(:,4) );
    y(ii,1) = wmean( temp(:,3),temp(:,4) );
end
coord = [x,y];

if isinterp == 1
    yrn = [yr(1):yr(end)]';
    xn = interp1(yr,x,yrn);
    yn = interp1(yr,y,yrn);
    coord = [xn,yn];
end



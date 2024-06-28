function cinfo = cinfoMask(cinfo,shp)
% output lon lat in the polygon
% shp can be string or struct from shaperead

switch class(shp)
    case {'char','string'}
        shp = shaperead(shp);
    case 'double'
        shp = lonlat2polygon(shp(1:2),shp(3:4));
end

logi = inpolygon(cinfo(:,2),cinfo(:,3),shp.X,shp.Y);
cinfo = cinfo(logi,:);
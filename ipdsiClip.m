function S2= ipdsiClip(S,areaRange)
S2 =S;
if areaRange(2)< areaRange(1)
    flag_x = (S.xx(1,:) >= areaRange(1) & S.xx(1,:) <= 180) |...
        (S.xx(1,:) >= -180 & S.xx(1,:) <= areaRange(2));
else
    flag_x = S.xx(1,:) >= areaRange(1) & S.xx(1,:) <= areaRange(2);
end
flag_y = S.yy(:,1) >= areaRange(3) & S.yy(:,1) <= areaRange(4);
S2.xx = S.xx(flag_y,flag_x);
S2.yy = S.yy(flag_y,flag_x);
S2.area_grid = S.area_grid(flag_y,flag_x);
S2.pdsi = S.pdsi(flag_y,flag_x,:);
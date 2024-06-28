function [ds,recentroid,S] = cdist(cinfo,yrRange,xyRange)

siglevel = [0.95,0.9]; 

% clip data according to date and lon lat
data = cinfoRange(cinfo,yrRange) ;     
data = cinfoMask(data, xyRange);  

recentroid = centroid1ly(data,1)  ;
recentroid_f = fliplr( recentroid) ;
yrRange = [data(1,1):data(end,1)]';

% calcuate distance
baseC =  min(recentroid_f) ;
baseC2 = baseC;
baseC2(:,1) =  mean(recentroid_f(:,1));
d = distance(baseC, recentroid_f, referenceEllipsoid('wgs84')  );
dx = distance(baseC2, [repmat(baseC2(1),size(recentroid_f,1),1), recentroid_f(:,2)], referenceEllipsoid('wgs84')  );
dy = distance(baseC, [recentroid_f(:,1),repmat(baseC(2),size(recentroid_f,1),1)], referenceEllipsoid('wgs84')  );

ds(1).dist= [yrRange,d./1e3]; 
ds(2).dist= [yrRange,dx./1e3]; 
ds(3).dist= [yrRange,dy./1e3];

wavey = 3.7;
for ii = 1:3
    S(ii) = mywave(ds(ii).dist,siglevel,wavey,'detrend1',[1,1,0,0]);
    set(gcf,'Position',[1.1695e+03 349.5000 455.5000 420]);
end
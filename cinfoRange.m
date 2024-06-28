function  cinfo = cinfoRange(cinfo,range)

% output lon lat info according to year

if length(range) > 2
    range = [range(1),range(end)];
end

idx1 = find(cinfo(:,1)>=range(1),1);
idx2 = find(cinfo(:,1)<=range(2),1,'last');

cinfo = cinfo(idx1:idx2,:);
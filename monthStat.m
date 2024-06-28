function res = monthStat(data,range,fun)
% data be a monthly data with 3 colmons, namely year, month, and value
% range is vector with 2 value, corresponding to start and end month
% If the statistical months span across a year, the previous year is represented as a negative number,
% for example [-11, 2], which indicates November of the previous year to February of the current year.
% fun: @mean or @sum...
% output: 2 colmons, namely year (corresponding to end month) and statistic 

if range(1)<0
    n_month = (12-abs(range(1))+1) + range(2);
else
    n_month = range(2)-range(1)+1;
end

row_beg = find(data(:,2)==abs(range(1)));
row_end = find(data(:,2)==abs(range(end)));

idx = find(row_end - row_beg(1) + 1 == n_month);
row_end = row_end(idx:end);
row_beg = row_beg(1:length(row_end));
row_idx = [row_beg,row_end];


yr_list = data(row_end,1);
res = [yr_list, nan(length(yr_list),size(data,2)-2)];

for ii = 1:length(row_end)
    if strcmp(func2str(fun),'max') || strcmp(func2str(fun),'min')
        res(ii,2:end) = fun(data(row_idx(ii,1):row_idx(ii,2),3:end),[], 1);
    else
        res(ii,2:end) = fun(data(row_idx(ii,1):row_idx(ii,2),3:end), 1);
    end
end



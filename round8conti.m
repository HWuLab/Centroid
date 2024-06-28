function mat = round8conti(mat0,x0,y0,k)
% set the flag to continuous drought area
% x0, y0 are the initial row and col of drought grid 

% if the initial grid is 1 (under drought)
if mat0(x0,y0) == 1 
    mat0(x0,y0) = k;

    [r8,mat] = round8(mat0,x0,y0,k);
    % if r8 is empty, indicating the round 8 grids do not have a drought
    % then end the while loop
    while ~isempty(r8)
        r8r2 = [];
        row = size(r8);
         for ii = 1:row
             [r8_temp,mat] = round8(mat,r8(ii,1),r8(ii,2),k);
             r8r2 = [r8r2;r8_temp];
         end         
         r8 = unique(r8r2,'row');  
    end
else
    fprintf('Error of initial grid')
end

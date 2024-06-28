function [r8,mat] = round8(mat,x,y,k)
% search the round 8 grids, if is 1 (under drought), set the value to k (flag)
% save the index to r8

    r8 = [];
    [row,col] = size(mat);
    for jj = y-1:y+1
        for ii = x-1:x+1
            if ~(ii == x && jj==y)
                % check the row and col index within the matrix
                if inrange(ii,1,row) && inrange(jj,1,col)  
                    if mat(ii,jj) == 1
                        mat(ii,jj)=k;
                        r8 =[r8;ii jj];
                    end
                end
            end
        end
    end

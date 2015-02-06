function [ finalmatrix ] = repmat2sizeof( initmatrix, refmatrix )
%REPMAT2SIZE Summary of this function goes here
%   Detailed explanation goes here
    scaleratio = size(refmatrix)./size(initmatrix);
    if(any(mod(scaleratio, 1)))
        error('Cannot repmat: the matrix sizes are not divisible!')
    end
    % if(sum(scaleratio < 1) | % implement error checks
    finalmatrix = repmat(initmatrix, scaleratio);
end


function [ matrix_normalized ] = normrange( matrix_in, alongdimension )
%NORMRANGE Takes a matrix and renormalizes all values to be
%fractional proportions of between 0 and 1.
    if(~exist('alongdimension', 'var'))
        alongdimension = 1;
    end

    matrix_offset = matrix_in - repmat2sizeof(min(matrix_in, [], alongdimension), matrix_in);
    matrix_range = repmat2sizeof(range(matrix_in, alongdimension), matrix_in);
    
    matrix_normalized = matrix_offset ./ matrix_range;

end


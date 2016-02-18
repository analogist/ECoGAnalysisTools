function [ mat_out ] = cumsumlim( mat_in, limits )
%CUMSUMLIM Summary of this function goes here
%   Detailed explanation goes here
%   Future expansion: error checking for limits. Limits can be determined
%   per column.

    mat_out = mat_in;
    
    for iter = 1:size(mat_out, 2)
        for elemiter = 2:size(mat_out, 1)
            elemsum = mat_out(elemiter, iter) + mat_out(elemiter-1, iter);
            if elemsum > max(limits)
                elemsum = max(limits);
            elseif elemsum < min(limits)
                elemsum = min(limits);
            end  
            mat_out(elemiter, iter) = elemsum;
        end
    end

end


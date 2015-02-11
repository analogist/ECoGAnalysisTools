function [ realmin, realmax ] = despike( inputdata )
%function [ output_args ] = despike( inputdata )
%   Detailed explanation goes here

    function output = getmin(input)
        output = min(input(:, sum(input, 1) ~= 0), [], 2);
    end

realmin = getmin(inputdata);

realmax = max(inputdata, [], 2);
nmax = quantile(inputdata, .995, 2);

dmax = (realmax - realmin) - (1.5 * (nmax - realmin)); 

realmax(dmax > 0) = nmax(dmax > 0);


end

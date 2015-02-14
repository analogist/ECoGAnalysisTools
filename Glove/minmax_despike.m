function [ realmin, realmax ] = minmax_despike( inputdata )
%MINMAX_DESPIKE Computes min and max of timeseries, but all
%1.5*(min -> 99.5 percentile range) is corrected to 99.5 percentile
%   Detailed explanation goes here

    function output = getmin(input)
        % exclude dropouts (channel == 0) from the glove data when
        % computing the realmin
        output = min(input(:, sum(input, 1) ~= 0), [], 2);
    end

realmin = getmin(inputdata);

realmax = max(inputdata, [], 2);
nmax = quantile(inputdata, .995, 2);

dmax = (realmax - realmin) - (1.5 * (nmax - realmin)); 

realmax(dmax > 0) = nmax(dmax > 0);


end

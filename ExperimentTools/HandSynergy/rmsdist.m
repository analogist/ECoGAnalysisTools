function [ distances ] = rmsdist( series1, series2 )
%RMSDIST Summary of this function goes here
%   Detailed explanation goes here
    if(nargin ~= 2)
        error('Matrix must be 2xn or nx2')
    end

    if( ~isequal(size(series1),size(series2)) )
        error('Two matrices do not match in size')
    end
    
    [~, mindex] = min(size(series1));
    distances = sqrt(sum((series1 - series2).^2, mindex));
end


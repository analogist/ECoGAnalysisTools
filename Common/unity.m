function [ output ] = unity( input, centered, excludeextremes )
%UNITY Summary of this function goes here
%   Detailed explanation goes here

    if(~exist('centered', 'var'))
        centered = false;
    end
    if(~exist('excludeextremes', 'var'))
        excludeextremes = false;
    end
    
    output = zeros(size(input));
    for i = 1:size(input, 2)
        if(excludeextremes)
            range = (quantile(input(:, i), .995)-quantile(input(:, i), .005));
        else
            range = max(input(:, i)) - min(input(:, i));
        end
        if(centered)
            baseline = mean(input(:, i));
            range = range/2;
        else
            baseline = min(input(:, i));
        end
        output(:, i) = (input(:, i) - baseline) / range;
    end

end


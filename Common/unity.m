function [ output ] = unity( input )
%UNITY Summary of this function goes here
%   Detailed explanation goes here
    output = zeros(size(input));
    for i = 1:size(input, 2)
        output(:, i) = (input(:, i) - min(input(:, i)))/range(input(:, i));
    end

end


function [ output ] = unity( input )
%UNITY Summary of this function goes here
%   Detailed explanation goes here
    output = (input - min(input))/range(input);

end


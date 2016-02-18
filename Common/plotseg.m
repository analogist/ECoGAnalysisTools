function [ ] = plotseg( input, red )
%PLOTSEG Summary of this function goes here
%   Detailed explanation goes here
    if(~exist('red', 'var'))
        red = 0;
    end
    if(red)
        hold on
        plot((1:length(input(10000:round(1220.7*10+10000), :)))/1220.7, input(10000:round(1220.7*10+10000), :), 'r')
    else
        plot((1:length(input(10000:round(1220.7*10+10000), :)))/1220.7, input(10000:round(1220.7*10+10000), :))
    end
end


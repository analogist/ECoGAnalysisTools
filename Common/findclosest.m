function [ timept ] = findclosest( input, tlist )
%FINDCLOSEST Summary of this function goes here
%   Detailed explanation goes here
    [~, timept] = min(abs(tlist - input));
    timept = timept(round(length(timept)/2));
end


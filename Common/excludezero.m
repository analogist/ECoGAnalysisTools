function [ outputvector ] = excludezero( inputvector, thres )
%EXCLUDEZERO Summary of this function goes here
%   Detailed explanation goes here
    mask = abs(inputvector) >= thres;
    outputvector = inputvector(mask);

end


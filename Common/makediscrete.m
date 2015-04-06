function [ outputmat ] = makediscrete( inputmat )
%MAKEDISCRETE Summary of this function goes here
%   Detailed explanation goes here
    matmins = min(zscore(inputmat));
    outputmat = zscore(inputmat) + repmat2sizeof((0-matmins), inputmat);
    outputmat = round(outputmat*10);
end


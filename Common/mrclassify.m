function [sumout] = mrclassify(xtr, ytr, xte, yte)
%MRCLASSIFY Summary of this function goes here
%   Detailed explanation goes here

    crit = mrmr_mid_d(xtr, uint8(ytr), 10);
    
    xtrprune = xtr(:, crit);
    xteprune = xte(:, crit);
    sumout = sum(yte==classify(xteprune, xtrprune, ytr));
end


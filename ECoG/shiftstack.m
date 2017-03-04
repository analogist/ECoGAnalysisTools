function [ Xaug ] = shiftstack( X, nstacks )
%SHIFTSTACK Summary of this function goes here
%   Detailed explanation goes here
    Xaug = [];
    for st = 1:nstacks
        Xaug = [Xaug X(st:end-nstacks+st, :)];
    end
end


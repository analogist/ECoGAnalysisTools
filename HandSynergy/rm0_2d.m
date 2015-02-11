function [ newsyncoef ] = rm0_2d( syncoef )
%RM0_2D Removes all [0 0] elements from a [t x 2] matrix.
%   Such as synergy coefficients.
    syncoef(all(syncoef==0, 2), :)=[];
    newsyncoef = syncoef;
end


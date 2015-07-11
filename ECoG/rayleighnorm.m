function [ normalized, rayleighfitobj ] = rayleighnorm( data )
%RAYLEIGHNORM Summary of this function goes here
%   Detailed explanation goes here
    rayleighfitobj = fitdist(data, 'rayleigh');
    normalized = cdf(rayleighfitobj, data);
    
end


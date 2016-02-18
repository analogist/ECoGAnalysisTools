function [ distances ] = linedist( linevt1, linevt2, point )
%LINEDIST Summary of this function goes here
%   Detailed explanation goes here
    
    a = linevt2 - linevt1;
    distances = zeros(size(point, 1), 1);
    
    for iter = 1:size(distances, 1)
        b = point(iter, :) - linevt1;
        distances(iter) = abs(det([a; b]))/norm(a);
    end
    
end


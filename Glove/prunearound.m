function [ dx3ptspruned ] = prunearound( dx2pts, dx3pts )
%REMOVEIFNOT Summary of this function goes here
%   Detailed explanation goes here
    for i = length(dx3pts):-1:2 
        endpt = dx3pts(i);
        startpt = dx3pts(i-1);
        
        if( ~any(dx2pts < endpt & dx2pts >= startpt) & ~any(dx2pts >= endpt & dx2pts < startpt) )
            dx3pts(i) = [];
        end
    end
    
    dx3ptspruned = dx3pts(2:end);

end


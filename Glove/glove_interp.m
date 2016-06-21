function [ interpglove ] = glove_interp( rawglove )
%GLOVE_INTERP Summary of this function goes here
%   Detailed explanation goes here
    interpglove = zeros(size(rawglove));
    qpoints = 1:size(rawglove, 1);

    for i = 1:size(rawglove,2)
        dglove = [1; find(diff(rawglove(:, i)) ~= 0)];
        interpglove(:, i) = interp1(dglove, rawglove(dglove, i), qpoints, 'pchip');
    end
end


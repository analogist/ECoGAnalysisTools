function [ shuffledmat ] = matshuffle( origmatrix, dim )
%FROMTO Shuffle the input matrix along dimension [dim]
%   dim is 1 (vertical, rows) by default

	if ~exist('dim', 'var')
        dim = 1;
    end

    permlength = size(origmatrix, dim);
    switch(dim)
        case 1
        shuffledmat = origmatrix(randperm(permlength), :);
        case 2
        shuffledmat = origmatrix(:, randperm(permlength));
    end

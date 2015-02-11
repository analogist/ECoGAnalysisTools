function [ synergies, origpos ] = synergy_pca( calibglovedata, dims )
%SYNERGY_PCA Given calibrated glovedata (in Adroit space),
%PCA out the synergies and the origin position of the postures. Dims is #
%of dimensions of the synergy space.
%Glovedata should be in the format of [24 x time]. Default dims = 3.

    if(nargin < 2)
        dims = 3; % default is 3
    end

    fprintf('Glove: Decomposing %d synergies\n', dims)
    
    if(size(calibglovedata, 1) ~= 24 || size(calibglovedata, 2) <= 24)
        error('Glovedata should be in the format of [24 x time]');
    end
    
    synergies = pca((calibglovedata)');
    origpos = mean(calibglovedata, 2);

    synergies = synergies(:, 1:dims);

end


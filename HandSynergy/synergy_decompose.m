function [ synergy_ts ] = synergy_decompose( calibglovedata, origpos, synergies )
%SYNERGY_DECOMPOSE Projects the movements in Adroit position space into
%synergy space given the origin and synergy components.
    disp('Glove: Projecting glove data into PCA space')
    calibglovedata = calibglovedata - repmat2sizeof(origpos, calibglovedata);
    synergy_ts = synergies'*calibglovedata;
end
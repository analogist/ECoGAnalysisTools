function [ codepoints ] = labelstartstops( stimuluscode, codes )
%LABELSTARTSTOPS Summary of this function goes here
%   Detailed explanation goes here
    codepoints = cell(numel(codes), 1);
        
    for i = 1:numel(codes)
        codemask = (stimuluscode == codes(i));
        startpoints = find(diff(codemask) == 1) + 1;
        stoppoints = find(diff(codemask) == -1);
        
        codepoints{i} = [startpoints stoppoints];
    end
end


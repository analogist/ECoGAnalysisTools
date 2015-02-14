function [ glovedata, stimdata ] = loadRawGlove( filename )
%LOADRAWGLOVE Loads the raw glove data from [LR]Cyber state variables in
%bci2000 dat files, as well as the stimulus codes.
%   The stimulus codes are passed through. Be sure to runGloveCalib.

glovechannels = 22;

[~, states, params] = load_bcidat(filename);

%%determine handedness
if(isfield(params, 'Handedness'))
    glovedata.handedness = params.Handedness.NumericValue;
elseif(isfield(params, 'CyberGloveHandedness'))
    if(params.CyberGloveHandedness.Value{1} == 'L')
        glovedata.handedness = 2;
    elseif(params.CyberGloveHandedness.Value{1} == 'R')
        glovedata.handedness = 1;
    else
        error('Glove handedness in .dat invalid!')
    end
else
    error('Glove handedness in .dat not found!')
end

if(isfield(states, 'lCyber1'))
    fieldname = 'lCyber';
elseif(isfield(states, 'rCyber1'))
    fieldname = 'rCyber';
else
    fieldname = 'Cyber';
end

glovedata.signals = zeros(glovechannels, size(states.SourceTime, 1));
for ni = 1:glovechannels
    eval(sprintf('glovedata.signals(%d, :) = states.%s%d;', ni, fieldname, ni))
end

stimdata = states.StimulusCode'; 

end


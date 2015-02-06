function [ glovedata, stimdata ] = loadRawGlove( filename )
% function [ glovedata, stimdata ] = loadRawGlove( filename )
% glovedata{1} is handedness
% glovedata{2} is cyberglove values


glovedata = cell(2, 1);
glovedata{1} = 2;

glovechannels = 22;

[sig, states, params] = load_bcidat(filename);


%%determine handedness
if(isfield(params, 'Handedness'))
    glovedata{1} = params.Handedness.NumericValue;
elseif(isfield(params, 'CyberGloveHandedness'))
    
    if(params.CyberGloveHandedness.Value{1} == 'L')
        glovedata{1} = 2;
    elseif(params.CyberGloveHandedness.Value{1} == 'R')
        glovedata{1} = 1;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%

if(isfield(states, 'lCyber1'))
    fieldname = 'lCyber';
elseif(isfield(states, 'rCyber1'))
    fieldname = 'rCyber';
else
    fieldname = 'Cyber';
end



glovedata{2} = zeros(glovechannels, size(states.SourceTime, 1));
for ni = 1:glovechannels
    eval(sprintf('glovedata{2}(%d, :) = states.%s%d;', ni, fieldname, ni))
end

stimdata = states.StimulusCode'; 

end


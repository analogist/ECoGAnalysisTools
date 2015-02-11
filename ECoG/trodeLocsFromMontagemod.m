function [ coords ] = trodeLocsFromMontagemod( subject, Montage, useTLRC )
%TRODELOCALIZATION Given subject and given a particular montage,
%   Detailed explanation goes here
% subject is encoded subject ID
% Montage is a montage from a given recording (or set of recordings)
    if (~exist('useTLRC','var'))
        useTLRC = true;
    end
    if (~exist('Montage','var'))
        Montage.MontageTokenized = {'Grid(1:64)'};
    end
    
    subjDir = [fileparts(subject) '/other'];
    
    if (~useTLRC)
        load([subjDir '\trodes.mat']);
    else
        load([subjDir '\tail_trodes.mat']);
    end
    
    coords = [];
    
    for token = Montage.MontageTokenized
        [name, idxStr] = processToken(token{:});
        eval(sprintf('trodesOfInterest = %s(%s, :);', name, idxStr));
        coords = [coords; trodesOfInterest];
    end
end

function [name, idxStr] = processToken(token)
    inpar = strfind(token, '(');
    outpar = strfind(token, ')');
    
    name = token(1:(inpar-1));
    idxStr = token((inpar+1):(outpar-1));

end
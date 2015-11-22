function [ subj_signal, subj_state, subj_params ] = loadECoG( subjid, refmode, notchmode )
%LOADECOG_CAR Summary of this function goes here
%   Detailed explanation goes here
disp('ECoG: Loading ECoG')

[~, ~, fileext] = fileparts(subjid);
switch(fileext)
    case '.dat'
        disp('BCI2000 .dat detected')
        [subj_signal, subj_state, subj_params] = load_bcidat(subjid);
    case '.mat'
        disp('MATLAB file detected')
        load(subjid);
    otherwise
        error('Not a recognized ECoG file!')
end

if(~exist('refmode', 'var'))
    disp('refmode not defined, assuming Miah compatibility mode')
    subj_signal = subj_signal(:, 1:64);
    montageFilepath = strrep(subjid, '.dat', '_montage.mat');

    if (exist(montageFilepath, 'file'))
        load(montageFilepath);
    else
        % default Montage
        Montage.Montage = size(subj_signal,2);
        Montage.MontageTokenized = {sprintf('Channel(1:%d)', size(subj_signal,2))};
        Montage.MontageString = Montage.MontageTokenized{:};
        Montage.MontageTrodes = zeros(size(subj_signal,2), 3);
        Montage.BadChannels = [];
        Montage.Default = true;
    end
    
    disp('ECoG: Common average reference');
    subj_signal = ReferenceCAR(GugerizeMontage(Montage.Montage), Montage.BadChannels, subj_signal);
    subj_signal = double(subj_signal);
end

if(~exist('notchmode', 'var'))
    disp('notchmode not defined, assuming Miah compatibility mode')
        disp('ECoG: Notch filter')
        subj_signal = notch(subj_signal, [60 120 180], 1200, 4);
    end
end

end


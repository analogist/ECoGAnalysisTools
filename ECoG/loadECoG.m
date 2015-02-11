function [ subj_signal, subj_state ] = loadECoG( subjid )
%LOADECOG_CAR Summary of this function goes here
%   Detailed explanation goes here
disp('ECoG: Loading ECoG')
[subj_signal, subj_state] = load_bcidat(subjid);
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

disp('ECoG: Notch filter')
subj_signal = notch(subj_signal, [60 120 180], 1200, 4);

end


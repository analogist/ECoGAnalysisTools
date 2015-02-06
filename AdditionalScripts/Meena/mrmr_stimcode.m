function [feat, hpwr] = mrmr_stimcode(file_input, n, removeZero, extractMovement, k)
% function [feat] = mrmr_stimcode(file_input, n, removeZero, extractMovement, descretize)
% n : int - how many features should mrmr return
% removeZero : boolean - whether to remove timepoints where stimcode is 0
% extractMovement : boolean - whether to extract only time windows of
                        %       greatest movement during each stim trial
% k : float - less than 0 = false, greater or equal to 0 means
                        % descretize by size of k * SD

[sig, states, params] = load_bcidat(file_input);

sigsize = size(sig);
 
stimcode = double(states.StimulusCode);


%%%%% apply CAR %%%%%%%%%%%%%
meansig_o = mean(sig, 2);
 
signal_spatial = double(sig - repmat(meansig_o, [1 sigsize(2)]));
%%%%% apply CAR %%%%%%%%%%%%%%%


%%% remove 120 and 180 frequencies %%%%
filtsig = notch(signal_spatial, [120 180], 1200, 4);
%%% remove 120 and 180 frequencies %%%%

%%% apply bandpass and power analysis %%
hpwr = log(hilbAmp(filtsig, [70 100], 1200).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%% okay how to descretize .... Hmmmm
if(k >= 0)
    hpwr = descretize(hpwr,k); 
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(removeZero)
    nonzero = stimcode ~= 0;
    stimcode = stimcode(nonzero);
    hpwr = hpwr(nonzero, :);
elseif(extractMovement);
    movemask = movementmask(file_input);
    stimcode = stimcode(movemask == 1);
    hpwr = hpwr(movemask == 1, :);
end

feat = mrmr_miq_d(hpwr, stimcode, n);

%% exclude 0

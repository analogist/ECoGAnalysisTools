function [ corrmap, lagmap ] = xcov_analyzesubj( subjpath, binhertz, diffnumber, normalizecolumns, xtype )
%XCOV_ANALYZESUBJ Load the Glove and ECoG data, and run the matrixwise
%comparison of the cross-correlation between glove and ecog data
if(~exist('diffnumber', 'var'))
    diffnumber = 1;
end

if(~exist('binhertz', 'var'))
    binhertz = 5;
end

if(~exist('normalizecolumns', 'var'))
    normalizecolumns = false;
end

if ~exist('xtype', 'var')
    xtype = 'xcov';
end

%% Load data
calibrated = loadCalibratedGlove(subjpath);
subjsig = loadECoG(subjpath);
%% Transform data
[subjsynergies, subjorigpos] = synergy_pca(calibrated);
synergy_ts = synergy_decompose(calibrated, subjorigpos, subjsynergies);

disp('ECoG: Calculating hilbert')
subjHG = hilbAmp(subjsig, [70 100], 1200) .^ 2;
subjHG = zscore(log(subjHG));
subjHG_bin = binevery(subjHG, 1200/binhertz);

if(normalizecolumns)
    subjHG_bin = normrange(subjHG_bin);
end

% scattercloud(calibrated_subjsynts(1, :), calibrated_subjsynts(2, :), 25, 20, 'k+', autumn);
%% Bin data to average samples
disp('Glove: binning data')
%%% mean binning method %%%
synergy_ts_filt = binevery(synergy_ts', 1200/binhertz);
% %%% lowpass method %%%%
% synergy_ts_filt = lowpass(synergy_ts', 5, 1200);
% %%% wavelet method %%%%
% synergy_ts = synergy_ts';
% synergy_ts_filt = zeros(size(synergy_ts));
% for iter=1:size(synergy_ts, 2)
%     synergy_ts_filt(:, iter) = wden(synergy_ts(:, iter), 'minimaxi', 's', 'one', 7, 'sym8');
% end

disp('Glove: Differentiating synergy time series')
% calibrated_subjsynts_diff = diff(synergy_ts_filt); % this one usually
calibrated_subjsynts_diff = diff(synergy_ts_filt, diffnumber); %%%%% acceleration 
disp('Glove: making positive and negative synergies')
calibrated_subjsynts_diff = splitsyns(calibrated_subjsynts_diff);

%% Diffing the glove + XCOV
disp('Making covariance maps')
[corrmap, lagmap] = xcov_matrixwise(calibrated_subjsynts_diff, subjHG_bin, xtype, 'pos', round(0.5*binhertz));
% [corrmap, lagmap] = xcov_matrixwise(calibrated_subjsynts_diff, subjHG); 


end


function [ f, t, powerout ] = morletprocess( inputs, fs, time_res, use_lmp )
%MORLETPROCESS Processing ECoG spectrum using analytic/nonanalytic Morlet
%wavelets in Matlab cwtft(). Outputs spectral power.
%   [POWEROUT, PHASEANGLE] = MORLETPROCESS(INPUTS, FS, TIME_RES, USE_LMP)
%
%   This function wraps cwtft to get an efficiently spaced Morlet/Morlex
%   power spectrum estimation with certain time resolution bins.
%
%   POWEROUT = MORLETPROCESS(INPUTS, FS, TIME_RES) takes INPUTS as
%   [time x channels] with time along dim 1. It iterates through all
%   channels to compute POWEROUT, with sampling frequency FS, and bins by
%   TIME_RES in seconds.
%
%   Example: POWEROUT = MORLETPROCESS(INPUTS, 1200, 0.050) for 1200 Hz
%   sampling frequency and 50ms bins.
%
%   USE_LMP is a bool (true, false). Setting USE_LMP to true will add an
%   additional "0 Hz" frequency track to all power outputs, to estimate
%   "local motor potential".
%

    if(~exist('use_lmp', 'var'))
        use_lmp = false;
    end
    
    % initialize dt and bins
    dt = 1/fs;
    binsize = round(fs*time_res);
    truncateby = mod(length(inputs), binsize);
    
    % establish scales, frequencies, and time
    scales = helperCWTTimeFreqVector(2, 200, 3/pi, dt, 8);
    f = (3/pi)./scales;
    t = (binsize*dt/2):(binsize*dt):((length(inputs)-truncateby)*dt);

    powerout = zeros(length(f), length(t), size(inputs, 2));
    if(use_lmp)
        siglmp = zeros(1, length(t), size(inputs, 2));
    end
    
    for i = 1:size(inputs, 2)
        cwty = cwtft({inputs(:, i), dt},'wavelet','morlex','scales',scales,'padmode','symw');
        powerout(:, :, i) = truncbindata(abs(cwty.cfs), truncateby, binsize);

        if(use_lmp)
            lmpprebin = glove_smooth(inputs(:, i), 1220.7, 1, 3);
            siglmp(:, :, i) = truncbindata(lmpprebin, truncateby, binsize);
        end
    end

    if(use_lmp)
        powerout = cat(1,powerout, siglmp);
        f(end+1) = 0;
    end
end

function [ postbin ] = truncbindata( prebin, truncateby, binsize, forcedim )
% This function bins input along time, and assumes time is the longer dim.
% If this is not true, set forcedim = 1 or 2
%
% When output, time is along dim 2
    if(~exist('forcedim', 'var'))
        forcedim = [];
    end
    if(isempty(forcedim))
        if(size(prebin, 2) > size(prebin, 1))
            prebin = prebin';
        end
    elseif(forcedim == 2)
        prebin = prebin';
    elseif(forcedim ~= 1)
        error('dimensional error on binning');
    else
        error('dimensional parameter error on binning');
    end

    binningtemp = prebin(1:end-truncateby, :);
    binningtemp = reshape(binningtemp, binsize, size(binningtemp, 1)/binsize, size(binningtemp, 2));
    binningtemp = squeeze(mean(binningtemp, 1));
    
    postbin = binningtemp';
end


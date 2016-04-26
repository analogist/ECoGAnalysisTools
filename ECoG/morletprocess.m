function [ powerout, phaseangle ] = morletprocess( inputs, fs, time_res, use_lmp )
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

    dt = 1/fs;
    binby = round(fs*time_res);
    truncateby = mod(length(inputs), binby)
    scales = helperCWTTimeFreqVector(2, 200, 3/pi, dt, 8);
    cwty = cwtft({sig(:, 1), dt},'wavelet','morlex','scales',scales,'padmode','symw');
    f = cwty.frequencies;
    t = binby*dt/2:binby*dt:trueend*dt;

    siglmp = zeros(1, length(t), size(sig, 2));
    sigfft = zeros(length(f), length(t), size(sig, 2));
    for i = 1:size(sig, 2)
        cwty = cwtft({sig(:, i), dt},'wavelet','morlex','scales',scales,'padmode','symw');
        cfsprebin = abs(cwty.cfs);
        cfsprebin = cfsprebin(:, 1:trueend);
        cfsbinning = cfsprebin';
        cfsbinning = reshape(cfsbinning, binby, size(cfsbinning, 1)/binby, size(cfsbinning, 2));
        cfsbinning = squeeze(mean(cfsbinning, 1));
        cfsbinning = cfsbinning';
        sigfft(:, :, i) = cfsbinning;

        if(use_lmp)
            lmpprebin = glove_smooth(sig(:, i), 1220.7, 1, 3);
            lmpprebin = lmpprebin(1:trueend, :);
            lmpbinning = reshape(lmpprebin, binby, size(lmpprebin, 1)/binby, size(lmpprebin, 2));
            lmpbinning = squeeze(mean(lmpbinning, 1));
            lmpbinning = lmpbinning';
            siglmp(:, :, i) = lmpbinning;
        end
        disp(i);
    end
    clear cfsprebin;
    clear cfsbinning;

    if(use_lmp)
        sigfft = cat(1,sigfft, siglmp);
        f(end+1) = 0;

        clear lmpprebin;
        clear lmpbinning;

        if(freemem)
            clear siglmp;
        end
    end
end


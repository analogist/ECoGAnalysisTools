function [ powerout, phaseout ] = morletprocess( inputs, fs, time_res, lmptrack )
%MORLETPROCESS Summary of this function goes here
%   Detailed explanation goes here
    %% wavelet
    dt = 1/1220.7;
    binby = round(1220.7*0.050);
    trueend = floor(length(sig)/binby)*binby;
    % scales = helperCWTTimeFreqVector(1, 150, 2/pi, 1/1220.7, 8);
    % cwty = cwtft({sig(:, 1), 1/1220.7},'wavelet','morlex','scales',scales,'padmode','symw');
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


    forcebin = zeros(length(t), size(force, 2));
    for i = 1:size(force, 2)
        forceprebin = force(1:trueend, i);
        forcebinning = reshape(forceprebin, binby, size(forceprebin, 1)/binby);
        forcebinning = squeeze(mean(forcebinning, 1));
        forcebinning = forcebinning';
        forcebin(:, i) = forcebinning;
    end
end


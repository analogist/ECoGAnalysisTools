function [ s, f, t, p ] = fftprocess( signalin, fs, spec_res, time_res )
%FFTPROCESS Summary of this function goes here
%   Detailed explanation goes here
%function [ s, f, t, p ] = fftprocess( signalin, fs, spec_res, time_res, min_freq )

%    nfft = max(round(fs/spec_res), round(fs/min_freq)); % nfft is both constrained by
                                            % low freq and by spectral resolution
    nfft = round(fs/spec_res);
    windowlen = nfft; % window length == nfft for max information. If nfft > window,
                    % that's just interpolating across frequency bins
    noverlap = round(nfft - time_res*fs); % time_res = (nfft-noverlap)/fs
    
%    [s, f, t, p] = spectrogram(signalin, hann(windowlen), noverlap, nfft, fs, 'power');
    [s, f, t, p] = spectrogram(signalin, hann(windowlen), noverlap, nfft, fs);

end


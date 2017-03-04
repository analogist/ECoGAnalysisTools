function [ s, f, t, p ] = fftprocess( signalin, fs, spec_res, time_res )
%FFTPROCESS Extract one-sided spectral power using Short-Time Fourier
%Transform as a wrapper around SPECTROGRAM for multi-channel, and more
%human-readable temporal and spectral resolution options.
%   [p, f, t] = FFTPROCESS(signalin, fs, spec_res, time_res ) extracts
%   spectral power p of size [frequency x time x channel]
%   Matching frequency vectors is f (dim 1), and time vector t (dim 2),
%   for all channels (dim 3).
%
%   signalin must be [time x channel]
%   fs: sampling frequency
%   spec_res: spectral resolution, which will decide f vector
%   time_res is time resolution, which decide overlap in order to produce
%   the t vector.

    nfft = round(fs/spec_res);
    windowlen = nfft; % window length == nfft for max information. If nfft > window,
                    % that's just interpolating across frequency bins
    noverlap = round(nfft - time_res*fs); % time_res = (nfft-noverlap)/fs
        
    t = (((1 + (0:((fix((size(signalin, 1)-noverlap)/(nfft-noverlap)))-1))*(nfft-noverlap))-1)+((nfft)/2)')/fs;

    for ch = 1:size(signalin, 2)


        [s, f, t, p] = spectrogram(signalin, hann(windowlen), noverlap, nfft, fs);
    end

end


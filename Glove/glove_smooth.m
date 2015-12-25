function [ out_glove ] = glove_smooth( in_glove, fs, minfeaturesize, attenu )
%GLOVE_SMOOTH Summary of this function goes here
%   Detailed explanation goes here
    v = version;
    if(str2double(v(1:3)) >= 8.3)
        
    out_glove = zeros(size(in_glove));
    
    % MATLAB 2014a and after
        d = designfilt('lowpassiir', 'PassbandFrequency', 0.2, ...
                                    'StopbandFrequency', 1/2/minfeaturesize, ...
                                    'PassbandRipple', 1, ...
                                    'StopbandAttenuation', attenu, ...
                                    'SampleRate', fs, ...
                                    'DesignMethod', 'butter');

        for i = 1:size(in_glove, 2)
            out_glove(:, i) = filtfilt(d, in_glove(:, i));
        end
        
    else

    % MATLAB 2013b and before
        
        h  = fdesign.lowpass(0.2, 1/2/minfeaturesize, 1, attenu, fs);
        Hd = design(h, 'butter', 'MatchExactly', 'stopband');
        [b, a] = sos2tf(Hd.sosMatrix, Hd.ScaleValues);

        for i = 1:size(in_glove, 2)
            out_glove(:, i) = filtfilt(b, a, in_glove(:, i));
        end
        
    end
end

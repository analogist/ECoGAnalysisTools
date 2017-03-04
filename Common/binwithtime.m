function [ timeseries_bin, t ] = binwithtime( inputs, fs, time_res, method )
%BINEVERY Bin ("downsample") using mean of the bin period
    if size(inputs,2) > size(inputs,1)
        error('Please put time on the row (1st) dimension')
    end
    if nargin == 2
        method = 'mean';
    end
    
    dt = 1/fs;
    binsize = round(fs*time_res);
    truncateby = mod(length(inputs), binsize); % make round bins
    t = (binsize*dt/2):(binsize*dt):((length(inputs)-truncateby)*dt);
    
    if binsize == 1
        timeseries_bin = inputs;
        disp('binsize == 1: No binning occurred!');
        return
    end
    
    timeseries_bin = zeros(length(t), size(inputs, 2));
    for eachcolumn = 1:size(inputs, 2)
        timeseries_bin(:, eachcolumn) = truncbindata(inputs, truncateby, binsize, method);
    end

end

function [ postbin ] = truncbindata( prebin, truncateby, binsize, method, forcedim)
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
    switch method
        case 'mean'
            binningtemp = squeeze(mean(binningtemp, 1));
        case 'median'
            binningtemp = squeeze(median(binningtemp, 1));
        case 'mode'
            binningtemp = squeeze(mode(double(binningtemp), 1));
        otherwise
            error('Invalid method, please use mean, median, or mode');
    end
    
    postbin = binningtemp';
end


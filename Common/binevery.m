function [ timeseries_bin ] = binevery( timeseries, bin_by, method )
%BINEVERY Bin ("downsample") using mean of the bin period
    if size(timeseries,2) > size(timeseries,1)
        error('Please put time on the row (1st) dimension')
    end
    
    if nargin == 2
        method = 'mean';
    end
    
    if bin_by == 1
        timeseries_bin = timeseries;
        disp('bin_by == 1: No binning occurred!');
        return
    end
    
    truncatenum = mod(size(timeseries, 1), bin_by);
    if truncatenum > 0
        warning('Warning: the last %d timepoint(s) of each timeseries will be truncated!\n', truncatenum)
        timeseries = timeseries(1:end-truncatenum, :);
    end
    
    bincount = size(timeseries, 1)/bin_by;
    timeseries_bin = zeros(bincount, size(timeseries, 2));
    
    for eachcolumn = 1:size(timeseries, 2)
        reshapetemp = reshape(timeseries(:, eachcolumn), bin_by, bincount);
        switch method
            case 'mean'
                timeseries_bin(:, eachcolumn) = mean(reshapetemp, 1)';
            case 'median'
                timeseries_bin(:, eachcolumn) = median(reshapetemp, 1)';
            case 'mode'
                timeseries_bin(:, eachcolumn) = mode(double(reshapetemp), 1)';
            otherwise
                error('Invalid method, please use mean, median, or mode');
        end
    end
    
    if(strcmp(method, 'mode'))
        timeseries_bin = int16(timeseries_bin);
    end

end


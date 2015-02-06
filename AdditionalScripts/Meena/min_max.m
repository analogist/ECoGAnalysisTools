function [output, files] = min_max( inputfile, channel, ARwindow, ARstep, nfft, bucketrange)
%function output = min_max( inputfile, channel, ARwindow, ARstep, nfft, bucketrange)
%   Detailed explanation goes here

function [ output ] = pburg_wrap( inmat )
        output = pburg(double(inmat), 16, nfft)';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


numbuckets = length(bucketrange);
numfiles = length(inputfile);

output = zeros(numbuckets, numfiles, 3) ;

%debugging
files = cell(1, numfiles);

for fileIndex = 1 : numfiles
    %load from inputfile
    [sig_o, state_o, param_o] = load_bcidat(inputfile{fileIndex});
    
    
    sigsize = size(sig_o);
     
    %spatial filter
    meansig_o = mean(sig_o, 2);
    
    signal_spatial = double(sig_o - repmat(meansig_o, [1 sigsize(2)]));
    signal_spatial = signal_spatial(:, channel);
   
    %%apply moving ARfilter 
    %window of 600 samples and step size of 40
    specmatrix = moving_calc(signal_spatial, ARwindow, ARstep, @pburg_wrap);
    specmatrix = specmatrix(:, bucketrange); %isolate frequency buckets of interest
    
    
    
    run_gamescore = max(state_o.GameScore, [], 1);
    run_mean = mean(specmatrix, 1)';
    run_min = min(specmatrix, [], 1)';
    run_max = max(specmatrix, [] ,1)';
    
    %debugging
    files{fileIndex} = specmatrix;
    
    output(:, fileIndex, 2) = run_mean - run_min;
    output(:, fileIndex, 1) = run_max - run_mean;
    output(:, fileIndex, 3) = run_gamescore;
    
end
    
    


end


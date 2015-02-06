function varargout = variance_multfiles( inputfile, channel, ARwindow, ARstep, varwindow, varstep, nfft, bucketrange, stimcodeon)
%function varianceMatrix  = variance( inputfile, channel, ARwindow, ARstep, varwindow, varstep, nfft, bucketrange )
%output matricies have dimensions (time x freqbucket)
    
    %%% wrapper of pburg for input into moving_calc function  %%%%%%%%
    function [ output ] = pburg_wrap( inmat )
        output = pburg(double(inmat), 16, nfft)';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

varargout = cell(1, nargout);
numbuckets = length(bucketrange);

numfiles = length(inputfile);


for fileIndex = 1 : 1 : numfiles
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
    
  
    


    if(stimcodeon)
        stimcode = state_o.StimulusCode;   %retrieve stimulus code
        stimcode = moving_calc(single(stimcode), ARwindow, ARstep, @mode); %reduce number of samples to match specmatrix


        %%populate varargout cells

        for iter = 0: 1 : range(stimcode)     %iterate through stimcode range
            iterstim = repmat((stimcode == iter), [1 numbuckets]);          %stimMatrix for current stimcode

            rename = reshape(specmatrix(find(iterstim)), sum(iterstim(:,1)), numbuckets);      %isolate specmatrix entries corresponding current stimcode
            varargout{iter + 1} = [varargout{iter + 1} ; moving_calc(rename, varwindow, varstep, @var)];    %apply moving variance calculation
        end
    else 
        varargout{1} = [varargout{1} ; moving_calc(specmatrix, varwindow, varstep, @var)];
    end
  

end

%%%%%%%%%%%%%%%%%%%%%%%%%END%%%%%%%%%%%%%%%%%%%%%%%%%%


%%Original values of parameters
% ARwindow = 600;
% ARstep = 40;
% % ^^ each of these steps is sliding window 0.5s, increment by 33ms
% 
% varwindow = 600; % possibly 10
% varstep = 40; % possibly 2
% % ^^ sliding window of 5 sec, increment by 
% 
% nfft = 240; %nfft param value for pburg 
% bucketrange = [14:18];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end


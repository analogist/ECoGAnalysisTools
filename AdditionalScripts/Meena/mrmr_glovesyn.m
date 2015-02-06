function [ feat, hpwr ] = mrmr_glovesyn( file_input, n, torontoSpace, k_class, k_features)
%function [ output_args ] = mrmr_glovesyn( file_input )
% n : int - how many features should mrmr return
% torontoSpace : boolean - whether Toronto synergy space should be used
% k_class : float - less than 0 = don't descetize class vector, 
            % greater or equal to 0 means descretize by size of k * SD
% k_features : float - less than 0 = don't descetize features matrix, 
            % greater or equal to 0 means descretize by size of k * SD

            
[sig, states, params] = load_bcidat(file_input);

% process brain signal
hpwr = preproc_brainsignal(double(sig)); 


%extract and calibrate glove data
[glovedata, stimdata, params] = loadRawGlove(file_input); 
gloveCalib = runGloveCalib(glovedata);
gloveCalib(1 : 2, :) = 0; %% remove any wrist movement. 


% determine synergies and originpos
if(torontoSpace)
    synergies = csvread('meena_protosyn\protosynergies_full_meena.csv', 0, 0, [0 0 23 2]);
    origpos = csvread('meena_protosyn\originpos_full_meena.csv');
else
    [synergies, origpos] = synergy_pca(gloveCalib, 3);
end

% decompose glove data into synergy components 
syn_coefs = synergy_decompose(gloveCalib, origpos, synergies);
diff_syn_coefs = [0 0 0; diff(syn_coefs')];

%turn into single dimension class vector
classes = (diff_syn_coefs(:, 3) * 25) + (diff_syn_coefs(:, 2) * 5) + (diff_syn_coefs(:, 1));

% descretize if true
if(k_class >= 0)
    classes = descretize(classes, k_class);
end

if(k_features >= 0)
    hpwr = descretize(hpwr, k_features);
end

% apply mRMR, yay!! 
feat = mrmr_miq_d(hpwr, classes, n);
end


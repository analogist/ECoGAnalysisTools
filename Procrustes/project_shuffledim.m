function [ projs_epochs ] = project_shuffledim( inputmat, dim_cells, pcs )
%PCA_VALIDATE Summary of this function goes here
%   Detailed explanation goes here
    f_dim = dim_cells{1}; %freq
    t_dim = dim_cells{2}; %time
    ch_dim = dim_cells{3}; %channel
    tr_dim = dim_cells{4}; %trial
    
    projecttrials = reshape(...
        permute(inputmat,...
            [t_dim tr_dim f_dim ch_dim]),...
            size(inputmat, t_dim) * size(inputmat, tr_dim),...
                size(inputmat, f_dim) * size(inputmat, ch_dim));
    projs = (projecttrials - mean(projecttrials, 1))*pcs;
    
    if(size(projs, 2) ~= size(inputmat, f_dim) * size(inputmat, ch_dim))
        error('dim mismatch!')
    end
    
    projs_epochs = reshape(projs, [size(inputmat, t_dim),...
                                    size(inputmat, tr_dim),...
                                    size(projs, 2)]);
    projs_epochs = permute(projs_epochs, [1 3 2]);

end


function [ test_hat ] = classify_procrustes( train_input, trainlist, trainconds, test_input, testlist, maxdims, sweepby_t, sweepby_dim )
%CLASSIFY_PROCRUSTES Summary of this function goes here
%   Detailed explanation goes here

%     f_dim = dim_cells{1}; %freq
%     t_dim = dim_cells{2}; %time
%     ch_dim = dim_cells{3}; %channel
%     tr_dim = dim_cells{4}; %trial
    dim_cells = {1 2 3 4};
    [train_epochs, train_pcs] = pca_shuffledim(train_input, dim_cells);
    test_epochs = project_shuffledim(test_input, dim_cells, train_pcs);
    
    if(~exist('var', sweepby_t) || isempty(sweepby_t))
        timelist = length(
    end
    
    [trainmeans] = procrustes_mean(train_epochs, trainlist, trainconds, dims);
    meanproc = nan(numel(testlist), numel(trainconds), 2);
    for i = 1:numel(testlist)
        for j = 1:numel(trainconds)
            [~, ~, proctemp] = procrustes(test_epochs(:, 1:dims, i), trainmeans(:, 1:dims, j));
            meanproc(i, j, :) = [abs(proctemp.b-1) norm(proctemp.c(1, :), 1)]; %sum(sum(abs(proctemp.T)))
        end
    end
    [~, minidx] = min(sqrt(sum(meanproc.^2, 3)), [], 2);
    
    test_hat = trainconds(minidx)';

end


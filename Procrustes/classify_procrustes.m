function [ test_hat, timelist, dimlist ] = classify_procrustes( train_input, trainlist, trainconds, test_input, testlist, maxdims, sweepby_t, sweepby_dim )
%CLASSIFY_PROCRUSTES Summary of this function goes here
%   Detailed explanation goes here

%     f_dim = dim_cells{1}; %freq
%     t_dim = dim_cells{2}; %time
%     ch_dim = dim_cells{3}; %channel
%     tr_dim = dim_cells{4}; %trial
    if(~exist('sweepby_t', 'var') || isempty(sweepby_t))
        timelist = size(test_input, 1);
    else
        timelist = size(test_input, 1):-1*sweepby_t:1;
    end
    
    if(~exist('sweepby_dim', 'var') || isempty(sweepby_dim))
        dimlist = maxdims;
    else
        dimlist = mod(maxdims, sweepby_dim):sweepby_dim:maxdims;
    end
    
    dim_cells = {1 2 3 4};
    [train_epochs, train_pcs] = pca_shuffledim(train_input, dim_cells);
    [trainmeans] = procrustes_mean(train_epochs, trainlist, trainconds, maxdims);
    test_epochs = project_shuffledim(test_input, dim_cells, train_pcs);
    
    test_hat = zeros(numel(testlist), numel(timelist), numel(dimlist));
    for t_i = 1:numel(timelist)
        timelen = timelist(t_i);
        for d_i = 1:numel(dimlist)
            dims = dimlist(d_i);
            meanproc = nan(numel(testlist), numel(trainconds), 2);
            for i = 1:numel(testlist)
                for j = 1:numel(trainconds)
                    [~, ~, proctemp] = procrustes(test_epochs(1:timelen, 1:dims, i), trainmeans(1:timelen, 1:dims, j));
                    meanproc(i, j, :) = abs(proctemp.b-1);%[abs(proctemp.b-1) norm(proctemp.c(1, :), 1)]; %sum(sum(abs(proctemp.T)))
                end
            end
            [~, minidx] = min(sqrt(sum(meanproc.^2, 3)), [], 2);
            test_hat(:, t_i, d_i) = trainconds(minidx)';
        end
    end

end


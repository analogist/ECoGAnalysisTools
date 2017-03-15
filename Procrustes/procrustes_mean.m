function [ epochmean ] = procrustes_mean( projs_epochs, trainlist, trainconds, dims )
%PROCRUSTES_MEAN Summary of this function goes here
%   Detailed explanation goes here

    epochmean = zeros(size(projs_epochs, 1), dims, numel(trainconds));
    
    for i = 1:length(trainlist)
        for j = 1:numel(trainconds)
            found_epochs = find(trainlist == trainconds(j));
            epochmean(:, :, j) = mean(...
                projs_epochs(:, 1:dims, found_epochs) - ...
                mean(projs_epochs(:, 1:dims, found_epochs), 1)...
                , 3);
        end
    end

end


function [yfit] = hmmclassify(XTRAIN, ytrain, XTEST, hmmstates)
%MRCLASSIFY Summary of this function goes here
%   Detailed explanation goes here

    if(~exist('hmmparams', 'var'))
        hmmstates = 10;
    end
    
    classes = unique(ytrain);
    numemits = numel(unique(XTRAIN));
    classprob = zeros(numel(classes), 1);
    estTR = cell(numel(classes), 1);
    estE = cell(numel(classes), 1);
    
    transguess = eye(hmmstates)*0.5 + (ones(hmmstates)-eye(hmmstates))*0.5/(hmmstates-1);
    emisguess = ones(hmmstates, numemits)/hmmstates;
    
    for i = 1:numel(classes)
        [estTR{i} estE{i}] = hmmtrain(XTRAIN(ytrain == classes(i), :), transguess, emisguess);
    end
    
    for i = 1:numel(classes)
        [~, classprob(i)] = hmmdecode(XTEST, estTR{i}, estE{i});
    end
    
    [~, likelyclass] = max(classprob);
    yfit = classes(likelyclass);
end


function [yfit] = mrclassify(XTRAIN, ytrain, XTEST, mrparams, classifier)
%MRCLASSIFY Summary of this function goes here
%   Detailed explanation goes here

    if(~exist('classifier', 'var'))
        classifier = 'LDA';
    end
    if(~exist('mrparams', 'var'))
        mrparams = 10;
    end

    crit = mrmr_mid_d(XTRAIN, uint8(ytrain), mrparams);
    XTRAINprune = XTRAIN(:, crit);
    XTESTprune = XTEST(:, crit);
    
    switch classifier
        case 'LDA'
            yfit = classify(XTESTprune, XTRAINprune, ytrain);
        otherwise
           error('classifier error') 
    end
end


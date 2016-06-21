function [yfit] = featureclassify(XTRAIN, ytrain, XTEST, classifier, featmode, featparams)
%MRCLASSIFY Summary of this function goes here
%   Detailed explanation goes here

    if(~exist('classifier', 'var'))
        classifier = 'LDA';
    end
    if(~exist('featmode', 'var'))
        featmode = 'none';
    end
    if(~exist('featparams', 'var'))
        featparams = 10;
    end
    
    switch featmode
        case 'none'
            XTRAINprune = XTRAIN;
            XTESTprune = XTEST;
        case 'mRMR'
            crit = mrmr_mid_d(XTRAIN, uint8(ytrain), featparams);
            XTRAINprune = XTRAIN(:, crit);
            XTESTprune = XTEST(:, crit);
        case 'lasso'
            beta = lasso(XTRAIN, double(ytrain));
            betathres = find(sum(beta ~= 0, 1) <= featparams);
            betathres = betathres(end);
            XTRAINprune = XTRAIN(:, find(beta(:, betathres)));
            XTESTprune = XTEST(:, find(beta(:, betathres)));
        otherwise
            error('unknown feature selector')
    end
    
    switch classifier
        case 'LDA'
            yfit = classify(XTESTprune, XTRAINprune, ytrain);
        case 'QDA'
            yfit = classify(XTESTprune, XTRAINprune, ytrain, 'quadratic');
        case 'dLDA'
            yfit = classify(XTESTprune, XTRAINprune, ytrain, 'diaglinear');
        case 'MLR'
            B = mnrfit(XTRAINprune, ytrain);
            [~, yfit] = max(mnrval(B, XTESTprune));
        otherwise
           error('unknown classifier')
    end
end


function [yfit] = mrclassify(XTRAIN, ytrain, XTEST, mrparams, classifier, skipmr)
%MRCLASSIFY Summary of this function goes here
%   Detailed explanation goes here

    if(~exist('classifier', 'var'))
        classifier = 'LDA';
    end
    if(~exist('mrparams', 'var'))
        mrparams = 10;
    end
    if(~exist('skipmr', 'var'))
        skipmr = false;
    end
    
    if(skipmr)
        XTRAINprune = XTRAIN;
        XTESTprune = XTEST;
    else
        crit = mrmr_mid_d(XTRAIN, uint8(ytrain), mrparams);
        XTRAINprune = XTRAIN(:, crit);
        XTESTprune = XTEST(:, crit);
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
           error('classifier error')
    end
end


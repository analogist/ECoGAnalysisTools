function [ rsq ] = lmrsquare( x, y )
%LMRSQUARE Summary of this function goes here
%   Detailed explanation goes here
    mdl = LinearModel.fit(x, y);
    rsq = mdl.Rsquared.Ordinary;

end


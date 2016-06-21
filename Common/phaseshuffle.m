function [ shuffledata ] = phaseshuffle( indata, startpt )
%PHASESHUFFLE Summary of this function goes here
%   Detailed explanation goes here

%    if(~exist('interp', 'var'))
    if(~exist('startpt', 'var'))
        datadiff = diff(indata);
%         diffshuff = datadiff(randperm(length(datadiff)));
        diffshuff = datadiff(randi(length(datadiff), length(datadiff), 1));
        shuffledata = cumsum([indata(1); diffshuff]);
    else
        datadiff = diff(indata);
        diffshuff = datadiff(randi(length(datadiff), length(datadiff), 1));
        shuffledata = cumsum([indata(1); diffshuff]);
    end

%    else
%        if(interp == 1)
%            datadiff = diff(glove_interp(indata));
%            diffshuff = datadiff(randperm(length(datadiff)));
%            shuffledata = cumsum([indata(1); diffshuff]);
%        elseif(interp == 2)
%            datadiff = diff(glove_interp(indata));
%            diffshuff = datadiff(randi(length(datadiff), length(datadiff), 1));
%            shuffledata = cumsum([indata(1); diffshuff]);
%        end
%    end

end


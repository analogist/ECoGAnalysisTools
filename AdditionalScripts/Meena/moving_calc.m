function [ output ] = moving_calc( inmat, windowsize, stepsize, func)
%function output = moving_calc_ugly( inmat, windowsize, stepsize, func)
%   REQUIRES : -inmat must be at most two dimensional
%              -func(inmat) must be a valid call 
%                   -and output at most a two dimensional matrix
%              -windowsize >= size(inmat)(1)


%Do one window of func
% to determine dimensions of output matrix
iter_1 = func(inmat(1: windowsize, :));
itersize = size(iter_1);


matsize = size(inmat);
outputsize = (floor((matsize(1) - windowsize)/ stepsize)) + 1;

output = zeros(outputsize, itersize(2));
output(1, :) = iter_1;


for i = stepsize+1 : stepsize : outputsize * stepsize
    itermat = func(inmat(i : i+ windowsize - 1, :));
    output((i+stepsize - 1)/stepsize, :) = itermat;
end

end


function [ vector ] = fromto( from_no, to_no, no_no )
%FROMTO Summary of this function goes here
%   Detailed explanation goes here
if (nargin == 3)
    vector = from_no:(to_no-from_no)/(no_no-1):to_no;
else
    vector = repmat(from_no, 1, to_no);
end


function [ gridout ] = flipgrid( gridin, flipaxis)
%FLIPGRID Will swap channels in a matrix along the dimension of choice
%   FLIPGRID mainly concerns when a matrix, representing [t x channel]
%   or [channel x coord] is derived from channels that are from a square
%   grid (8x8), and the channels need to be rearranged such that the square
%   grid is mirrored along some axis.
%
%   Usage: FLIPGRID( grid_input, flipaxis)
%   Example: FLIPGRID( Grid, 1 )
%
%   flipaxis=1: will flip ch 1-8 with 8-1
%   flipaxis=2: will flip ch 1-8 with 57-64

    if(~exist('flipaxis', 'var'))
        error('Please specify axis to flip along. See help for details');
    end

    flipdim = find(size(gridin) == 64); % this searches for the dimension along
                                        % which there are 64 channels
    if(flipdim == 2) % transposes the input if 
        gridin = gridin';
    elseif(flipdim ~= 1)
        error('Invalid matrix! Matrix must be 64 ch with [t x ch] or [ch x coord]');
    end

    if(flipaxis == 1)
        ch_order = reshape(flipud(reshape(1:64, 8, 8)), 64, 1);
                            % generates the channel order with 1-8 -> 8-1 flip
    elseif(flipaxis == 2)
        ch_order = reshape(fliplr(reshape(1:64, 8, 8)), 64, 1);
                            % generates the channel order with 1-8 -> 57-64 flip
    else
        error('flipaxis must be 1 or 2!')
    end

    gridout = gridin(ch_order, :);

    if(flipdim == 2)
        gridout = gridout';
    end

end


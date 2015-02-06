function [ ] = plot_asgrid( channelsmap, orientation, rescaleoption, usecolormap, useinsubs)
%PLOT_ASGRID Plot a [channels x space] as "space"-number of figures (space
%could be synergy space), each as according to a square grid, with
%orientation as specified. Default colormap: autumn, default orientation:
%'RD'

    if (~exist('useinsubs', 'var') || isempty(useinsubs))
        useinsubs = false;
    end
    
    if (~exist('usecolormap', 'var') || isempty(usecolormap))
        usecolormap = autumn(64);
    end
    
    if (~exist('rescaleoption', 'var') || isempty(rescaleoption))
        rescaleoption = 'relative';
    end
    
    if ~exist('orientation', 'var')
        orientation = 'RD';
    end

    synergycount = size(channelsmap, 2);
    channelcount = size(channelsmap, 1);
    
    imageside = sqrt(channelcount);
    if (imageside ~= floor(imageside)) %if not whole number
        error('Error: # of channels isn''t a square');
    end
    
    % Create text labels of channels (1:64), then orient them
    [xtextloc, ytextloc] = meshgrid(1:imageside, 1:imageside); % x, y text label loc
    textlabels = reshape(1:channelcount, imageside, imageside);
    textlabels = grid_reorient(textlabels, orientation);
    
    for iter = 1:synergycount % plot each [64xsynergy] as a separate fig
        reshapemap = reshape(channelsmap(:, iter), imageside, imageside);
        reshapemap = grid_reorient(reshapemap, orientation);
        if(~useinsubs)
            figure
        end
        if ( strcmp(rescaleoption,'relative') )
            imagesc(1:imageside, 1:imageside, reshapemap)
        elseif ( strcmp(rescaleoption, 'absolute') )
            imagesc(1:imageside, 1:imageside, reshapemap, [min(channelsmap(:)), max(channelsmap(:))])
        end
        colormap(usecolormap)
        if(~useinsubs)
            colorbar
        end
        set(gca, 'XTick', [], 'YTick', [], 'XTickLabel', [], 'YTickLabel', []);
        text(xtextloc(:), ytextloc(:), num2str(textlabels(:)),...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end
end

function [ map_oriented ] = grid_reorient( map_to_orient, orientation)
    switch orientation
        case 'DR'
            operation = 1; % don't flip
        case 'DL'
            operation = 2; % fliplr
        case 'UR'
            operation = 3; % flipud
        case 'UL'
            operation = 4; % fliplr + flipud
        case 'RD'
            operation = 11; % '
        case 'RU'
            operation = 12; % fliplr + '
        case 'LD'
            operation = 13; % flipud + '
        case 'LU'
            operation = 14; % fliplr + flipud + '
        otherwise
            error('Unrecognized orientation');
    end
    
    map_oriented = map_to_orient;
    
    fliptype = mod(operation, 10);
    if(fliptype == 2 || fliptype == 4)
        map_oriented = fliplr(map_oriented);
    end
    if(fliptype == 3 || fliptype == 4)
        map_oriented = flipud(map_oriented);
    end
    if(operation > 10)
        map_oriented = map_oriented';
    end
end


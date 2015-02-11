function [ ] = synergy_plotposture( coord, originposfile, synergyfile )
%SYNERGY_PLOTDIMENSION Visualizes a specific synergy component coord
%   SYNERGY_PLOTDIMENSION( coordinate, [csv file with origin], [csv file with synergies])
%   
%   ex: SYNERGY_PLOTDIMENSION([-1 0.5])
%   ex: SYNERGY_PLOTDIMENSION([-1 0.5], originpos.csv, synergies_full.csv)
%   plots the coordinate in the relevant syn space. If the origin and
%   synergy files are not specified, it will be read in from the .ini file

%% Initiate and connect to Mojoco visualizer
    model = 'Adroit_Hand';
    so = mjcVizualizer;
    mjcLoadModel(so, which([model '.xml']));
    m = mjcGetModel(so);
    V0 = zeros(m.nq,1);
    
%% Prepare the synergies and origin positions
    if(nargin == 3)
        originpos = csvread_if_file(originposfile);
        synergies = csvread_if_file(synergyfile);
    else
        error('default synergy and origin file not implemented!!')
    end
    
    if(size(coord, 2) ~= 1)
        warning('Warning: coordinate should be in the form of [n x 1]. Transposing...');
        coord = coord';
    end
    
    if(size(coord, 1) < size(synergies, 2)) % if need to truncate synergies\
        warning('Warning: coordinate dimensions < synergy dimensions. Truncating...');
        synergies = synergies(:, 1:size(coord, 1));
    end
        
%     pause(0.5);
    
    newposition = synergies*coord;
    newposition = newposition + originpos;
    mjcPlot(so, newposition, V0);
    
    mjcClose(so);
    disp('End of plot')
end


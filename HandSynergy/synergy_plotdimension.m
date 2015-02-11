function [ ] = synergy_plotdimension( range, alongdimension, originposfile, synergyfile )
%SYNERGY_PLOTDIMENSION Visualizes a specific synergy component dimension
%   SYNERGY_PLOTDIMENSION( range through which to plot, dimension along
%   which to plot, [csv file with origin], [csv file with synergies])
%   
%   ex: SYNERGY_PLOTDIMENSION([-2 2], 1)
%   ex: SYNERGY_PLOTDIMENSION([-2 2], 1, originpos.csv, synergies_full.csv)
%   plots along the first dimension of the synergy space. If the origin and
%   synergy files are not specified, it will be read in from the .ini file

%% Initiate and connect to Mojoco visualizer
    model = 'Adroit_Hand';
    so = mjcVizualizer;
    mjcLoadModel(so, which([model '.xml']));
    m = mjcGetModel(so);
    V0 = zeros(m.nq,1);
    
%% Prepare the synergies and origin positions
    if(nargin == 4)
        originpos = csvread_if_file(originposfile);
        synergies = csvread_if_file(synergyfile);
    else
        error('default synergy and origin file not implemented!!')
    end
    mjcPlot(so, originpos, V0);
    
    populatewith = fromto(range(1), range(2), 500);
    poses = zeros(size(synergies, 2), size(populatewith, 2));
    poses(alongdimension, :) = populatewith;
    poses = poses';
    
    disp('Press [Enter] in the MATLAB window...');
    pause();
    pause(0.5);
    
    for i=1:size(poses, 1)
        newposition = synergies*poses(i, :)';
        newposition = newposition + originpos;
        mjcPlot(so, newposition, V0);
        pause(0.01);
    end
    
    mjcClose(so);
    disp('End of plot')
end


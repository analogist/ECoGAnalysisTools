function [ ] = Miahsetup( appdir )
%MIAHSETUP Setup path for Miah's tools
    addpath([appdir '/Miah/DataPrep']);
    addpath([appdir '/Miah/SigAnal']);
    addpath([appdir '/Miah/Visualization']);
    addpath([appdir '/Miah/Visualization/recon']);
    addpath([appdir '/Miah/External/spm8']);
    addpath([appdir '/Miah/External/MeshLab']);

end


function [ ] = Adroit_simsetup( appdir )
%ADROITBCISETUP Setup path for AdroitBCI and simulator
    oldpath = pwd();
    addpath([appdir '/Adroit_sim(0.72)']);
    addpath([appdir '/Adroit_sim(0.72)/VizualizerComm']);
%     addpath([appdir '/AdroitBCI/bci_depends']);
%     addpath([appdir '/AdroitBCI/bci_depends/data_bci']);
    cd([appdir '/Adroit_sim(0.72)']);
    setenv('PATH', [getenv('path') ';' pwd()]);
    cd(oldpath);
end


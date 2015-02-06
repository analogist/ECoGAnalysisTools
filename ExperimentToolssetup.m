function [ ] = ExperimentToolssetup( appdir )
%EXPERIMENTTOOLSSETUP Setup up the pathway for experiment-specific tools
    addpath([appdir '/ExperimentTools/']);
    addpath([appdir '/ExperimentTools/Common']);
    addpath([appdir '/ExperimentTools/HandSynergy']);
    addpath([appdir '/ExperimentTools/HandSynergy/components']);
    addpath([appdir '/ExperimentTools/XCovAnalysis']);
    addpath([appdir '/ExperimentTools/ECoG']);
    addpath([appdir '/ExperimentTools/Force']);
end


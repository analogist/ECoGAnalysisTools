function [ gloveCalib ] = runGloveCalib( glovedata_in )
%GLOVECALIB Converts 22 channel raw glove space to Adroit space
%   Needs minmax_despike

right_calib = 'calibration_JamesRight.mat';
left_calib = 'calibration_MeenaLeft.mat';

% load('../AdroitDataGlove/calibration - MeenaLeft.mat');
if(glovedata_in.handedness == 1)
    load(right_calib);
elseif(glovedata_in.handedness == 2)
    load(left_calib);
else
    error('Handedness invalid during calibration')
end
% addpath('bci_depends/data_bci/')
% addpath('../Adroit_sim(0.72)')

% mj('load', '../Adroit_sim(0.72)/Adroit_Hand.xml');
mj('load', which('Adroit_Hand.xml'));
m = mj('getmodel');

[minvec, maxvec] = minmax_despike(glovedata_in.signals);

minmat = repmat2sizeof(minvec, glovedata_in.signals);
maxmat = repmat2sizeof(maxvec, glovedata_in.signals);


gloveNRaw  = (glovedata_in.signals - minmat) ./ (maxmat - minmat);

gloveNRaw(gloveNRaw == -Inf) = 0;
gloveNRaw(gloveNRaw == Inf) = 0;
    
% calibrate and enforce limits
gloveCalib = calibration*([gloveNRaw; repmat2sizeof([1], gloveNRaw(1, :))]);
gloveCalib(gloveCalib<0) = 0;
gloveCalib(gloveCalib>1) = 1;
gloveCalib = gloveCalib.*repmat2sizeof((m.jnt_range(:,2)-m.jnt_range(:,1)), gloveCalib) + repmat2sizeof(m.jnt_range(:,1), gloveCalib);

end


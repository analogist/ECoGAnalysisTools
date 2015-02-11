function [ gloveCalib ] = runGloveCalib( glovedata_in )
%function [ gloveCalib ] = runGloveCalib( glovedata_in )
%   Detailed explanation goes here

right_calib = 'calibration - JamesRight.mat';
left_calib = 'calibration - MeenaLeft.mat';


glovedata = glovedata_in{2};
handedness = glovedata_in{1};


% load('../AdroitDataGlove/calibration - MeenaLeft.mat');
if(handedness == 1)
    load(right_calib);
else
    load(left_calib);
end
% addpath('bci_depends/data_bci/')
% addpath('../Adroit_sim(0.72)')

% mj('load', '../Adroit_sim(0.72)/Adroit_Hand.xml');
mj('load', which('Adroit_Hand.xml'));
m = mj('getmodel');

[minvec, maxvec] = despike(glovedata);

minmat = repmat2sizeof(minvec, glovedata);
maxmat = repmat2sizeof(maxvec, glovedata);


gloveNRaw  = (glovedata - minmat) ./ (maxmat - minmat);

gloveNRaw(gloveNRaw == -Inf) = 0;
gloveNRaw(gloveNRaw == Inf) = 0;
    
% calibrate and enforce limits
gloveCalib = calibration*([gloveNRaw; repmat2sizeof([1], gloveNRaw(1, :))]);
gloveCalib(gloveCalib<0) = 0;
gloveCalib(gloveCalib>1) = 1;
gloveCalib = gloveCalib.*repmat2sizeof((m.jnt_range(:,2)-m.jnt_range(:,1)), gloveCalib) + repmat2sizeof(m.jnt_range(:,1), gloveCalib);

end


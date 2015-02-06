function [ calibratedglove, stimdata ] = loadCalibratedGlove( subjid )
%LOADCALIBRATEDGLOVE Summary of this function goes here
%   Detailed explanation goes here
    disp('Glove: Loading glovedata');
    [glovedata,stimdata] = loadRawGlove(subjid);
    disp('Glove: Calibrating glovedata');
    calibratedglove = runGloveCalib(glovedata);
    disp('Glove: Zeroing wrist data');
    calibratedglove(1:2, :) = 0;
end


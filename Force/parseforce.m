function [ tracelabel, tracetime, forcelevel ] = parseforce( filename )
%PARSEFORCE Summary of this function goes here
%   Detailed explanation goes here
    if(~exist(filename, 'file'))
        error('Error: file to parse not found')
    end
    forcefile = fopen(filename, 'r');
    forcedata = textscan(forcefile, '%s %u32,%d16');
    tracelabel = forcedata{1};
    tracetime = forcedata{2};
    forcelevel = forcedata{3};
    
    fclose(forcefile);
end


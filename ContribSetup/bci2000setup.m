function [ ] = bci2000setup( appdir )
%BCI2000SETUP Setup up the pathway for bci2000 matlab tools
    olddir = pwd;
    cd([appdir '/bci2000'])
    cd tools, cd matlab
    bci2000path -AddToMatlabPath tools/matlab
    bci2000path -AddToMatlabPath tools/mex
    bci2000path -AddToSystemPath tools/cmdline   % required so that BCI2000CHAIN can call the command-line tools
    cd(olddir) % change directory back to where we were before
    clear olddir
end


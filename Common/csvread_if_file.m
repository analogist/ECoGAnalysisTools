function [ content ] = csvread_if_file( filename )
%CSVREAD_IF_FILE If argin is a filename, csvread the file
%  If the input is a string, assume it's a filename, and csvread the file
%  Otherwise, pass the input to the output
    if(ischar(filename))
        % if it's a string, it's probably a filename. csvread() it.
        % else, it's probably the actual matrix, so pass it through
        if(exist(filename) == 2)
            content = csvread(which(filename));
            disp(['Note: loaded ' which(filename)])
        else
            error(['File ' filename ' was not found'])
        end
    else
        content = filename;
    end
end


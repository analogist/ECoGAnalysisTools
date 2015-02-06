function [ datfiles ] = name_contains( filecell, matchstrings )
%NAME_CONTAINS Take a cell list of file names and prune down by string
%matching
%   NAME_CONTAINS({'aa', 'bb', 'cc', 'dd', 'aab', 'ccd'}, 'aa') will
%   give you back all cell elements containing 'aa': {'aa', 'aab'}
%   Can be use for pruning down large file lists, or to match by file
%   extension (e.g., prune down to only '.dat' files)
    if(ischar(matchstrings)) % if only a string
        datfiles = filecell(~cellfun('isempty',strfind(filecell, matchstrings)));
        % from filecell, select the mask:
            % mask is created from the inversion of
                % running isempty on each element of strfind
                % with strfind output [21] [] [] [] [21] [] [] []....
    elseif(iscell(matchstrings)) % if lots of strings
        datfiles = {};
        
        for iter = 1:numel(matchstrings)
            foundmatches = filecell(~cellfun('isempty',strfind(filecell, matchstrings{iter})));
            datfiles = [datfiles foundmatches];
        end
    else
        error('matchstrings must be string or cell of strings');
    end
end
%% 
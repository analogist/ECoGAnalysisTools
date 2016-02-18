function [ stimdatawithexit ] = stimulus_labelouts( stimdata )
%STIMULUS_LABELOUTS Goes through a t x 1 stimdata with 0's and non-0's,
% then labels all the zeros with the -1*stimcode that came
% before the 0 time periods.
    stimdatawithexit = int16(stimdata);
    for iter = 1:length(stimdatawithexit)-1
        if(stimdatawithexit(iter) ~= 0 && stimdatawithexit(iter+1) == 0)
            if(stimdatawithexit(iter) > 0)
                stimdatawithexit(iter+1) = -1*stimdatawithexit(iter);
            elseif(stimdatawithexit(iter) < 0)
                stimdatawithexit(iter+1)  = stimdatawithexit(iter);
            end
        end
    end
end


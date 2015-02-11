function [ corrmap, lagmap ] = xcov_matrixwise( synergy_move_ts, spectralpower, xtype, condition, offset )
%XCOV_ACROSS Takes a synergy movement timeseries [t x dims], spectral power
%of the signal [t x channels], and condition (all / pos), and gives the
%covariance matrix of [channels x synergies x c/lag]
%   corrmap refers to the max of the covariance for each chan/synergy.
%   lapmap contains the offset lag of where the max above is.
%   The argument [offset] is number of samples to offset. Default 600.
%   The argument [condition] has the option of 'all' or 'pos'. 'all' will
%   compute the max over +- offset. 'pos' will only compute max over
%   +offset.

    if (~exist('xtype', 'var') || isempty(xtype))
        xtype = 'xcov';
    end
    if ~exist('offset', 'var')
        offset = 600; % this is 0.5 sec when sampled at 1200
    end
    if ~exist('condition', 'var')
        condition = 'all';
    end

    
    % size check
    if(size(synergy_move_ts, 1) <= size(synergy_move_ts, 2))
        error('Make sure the movement timeseries is in the form of [t x dims]');
    end
    if(size(spectralpower, 1) <= size(spectralpower, 2))
        error('Make sure the spectral power is in the form of [t x channels]');
    end
    
    % mutual length check
    cutby = size(spectralpower, 1) - size(synergy_move_ts, 1);
    if(cutby ~= 0)
        if( abs(cutby) > 2)
            error('The number of samples of hand and neural are mismatched by more than 2 samples! Terminating...')
        elseif(cutby > 0)
            warning('Warning: the hand timeseries is shorter. Truncating neural by %d samples...\n', cutby)
            spectralpower = spectralpower(1:end-cutby, :);
        else
            warning('Warning: the neural timeseries is shorter. Truncating hand by %d samples...\n', -1*cutby)
            synergy_move_ts = synergy_move_ts(1:end+cutby, :);
        end
    end
    
    corrmap = zeros(64, size(synergy_move_ts, 2));
    lagmap = zeros(64, size(synergy_move_ts, 2));
    
    fprintf('Running correlations:');

    for syniter = 1:size(synergy_move_ts, 2)
        fprintf('\nSynergy %d:', syniter);
        for chaniter = 1:size(spectralpower, 2)
            switch(xtype)
                case 'xcov'
                    [c, lag] = xcov(synergy_move_ts(:, syniter), spectralpower(:, chaniter), offset, 'coeff');
                case 'xcorr'
                    [c, lag] = xcorr(synergy_move_ts(:, syniter), spectralpower(:, chaniter), offset, 'coeff');
                otherwise
                    error('Unknown method type of correlation/covariance')
            end
            
            % 'all' is the default, which allows +-offset
            % 'pos' and 'neg' are if you need to specify that one has to
            % come first; 'pos' is when brain leads, 'neg' is when hand
            % leads
            if(strcmp(condition, 'pos'))
                posmask = (lag >= 0);
                c = c(posmask);
                lag = lag(posmask);
            elseif(strcmp(condition, 'neg'))
                negmask = (lag < 0);
                c = c(negmask);
                lag = lag(negmask);
            end
            
            corrmap(chaniter, syniter) = max(c);
            lagmap(chaniter, syniter) = lag(c == max(c));
            fprintf(' %d', chaniter);
        end
    end
    
    disp('Covariance complete');

end


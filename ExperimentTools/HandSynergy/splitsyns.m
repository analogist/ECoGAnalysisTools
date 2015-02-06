function [ diff_synergy_split ] = splitsyns( diffsynergy )
%SPLITSYNS Given a [t x syns] array, split into pos and neg syns
    if(size(diffsynergy, 1) < size(diffsynergy, 2))
        error('Not a synergy matrix? Should be [t x syns]');
    end
    diff_synergy_split = repmat(diffsynergy, [1 2]);
    
    for iter = 1:size(diff_synergy_split, 2)        
        tempsyn = diff_synergy_split(:, iter);
        
        if( mod(iter, 2) == 1 ) %odd, pos only, zero the neg
            tempsyn(tempsyn < 0) = 0;
        elseif( mod(iter, 2) == 0 ) %even, neg only, zero the pos
            tempsyn(tempsyn > 0) = 0;
        else
            error('Not an even or odd synergy??!')
        end
        diff_synergy_split(:, iter) = abs(tempsyn);
    end
        
end


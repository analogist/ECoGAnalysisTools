function [ output_ts ] = zeroall_if( timeseries, condition )
%ZEROALLPOS Given an array, make zero any value that matches the condition
%given. Implemented is 'pos' and 'neg' for zeroing only positive and only
%negative values. To implement: 10percent.
    switch(condition)
        case 'pos'
            output_ts = arrayfun(@(x) zeropos(x), timeseries);
        case 'neg'
            output_ts = arrayfun(@(x) zeroneg(x), timeseries);
        otherwise
            error('Condition not implemented')
    end
end

function [ nonzero ] = zeropos( value )
    if(value > 0)
        nonzero = 0;
    else
        nonzero = value;
    end
end

function [ nonzero ] = zeroneg( value )
    if(value < 0)
        nonzero = 0;
    else
        nonzero = value;
    end
end
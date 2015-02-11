function [ matchtable ] = synergy_findbestmatch( subjectsynergies, referencesynergies )
%SYNERGY_FINDBESTMATCH Goes through all of subjectsynergies and see
%   which components match best with the referencesynergies

    subjectsynergies = csvread_if_file(subjectsynergies);
    syncount = size(subjectsynergies,2);
    
    referencesynergies = csvread_if_file(referencesynergies);
    refcount = size(referencesynergies, 2);
    
    % duplicate so negative synergies can be matched too
    referencesynergies = [referencesynergies, -referencesynergies];
    
    matchtable = [(1:syncount)' zeros(syncount, 2)];

    for iter=1:syncount
        differences = referencesynergies - repmat2sizeof(subjectsynergies(:, iter), referencesynergies);
        differences = sqrt(sum(differences .^ 2, 1));
        [~, matchindex] = min(differences);
        if(matchindex > refcount) % the 2nd half of the table are the negative of the references
            matchindex = matchindex - refcount;
            matchtable(iter,3) = 1;
        end
        matchtable(iter,2) = matchindex;
    end

end


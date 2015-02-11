function [ ordinal_classes ] = make_ordinal_classes( integer_codes )
%MAKE_ORDINAL_CLASSES Summary of this function goes here
%   Detailed explanation goes here
    uniqueclasses = unique(integer_codes, 'stable');
    ordinal_classes = uint16(changem(integer_codes, 1:length(uniqueclasses), uniqueclasses));
end


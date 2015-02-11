function [ ] = saveallopenfigs( idstring )
%SAVEALLOPENFIGS Literally save all open figures with the handle, number,
%and as a .png
    figHandles = get(0,'Children');
    for iter = numel(figHandles):-1:1
        saveas(figHandles(iter), [idstring num2str(figHandles(iter)) '.png']);
        close(figHandles(iter));
    end
end


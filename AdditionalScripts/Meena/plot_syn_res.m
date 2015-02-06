originpos = csvread('meena_protosyn\originpos.csv'); 

space_all = csvread('meena_protosyn\protosynergies.csv');
space_all = space_all - repmat(originpos, 1, size(space_all, 2));

poses = csvread('meena_protosyn\TargetHandVectors.csv');


% space_all = pca(poses');
% originpos = mean(poses, 2);



maxdim = 4;
Toronto_res = zeros(size(poses, 2), maxdim);


for i = 1 : maxdim
    Toronto_res(:, i) = synergy_acc(poses, space_all(:, (1 : i)), originpos);
end  


originpos2 = csvread('bci_depends\originpos.csv'); 
space2 = csvread('bci_depends\2components.csv');

James_res  = synergy_acc(poses, space2, originpos2);


bar([Toronto_res'; James_res'] );
function [ residual ] = synergy_acc( poses, space, originpos)
%function [ remnants ] = synergy_acc( poses, space, originpos )
%REQUIRES : size(originpos) = size(poses(:, 1)); 

%%% joint importance weights for synergy error
% wrist = 0;
% index = 1.5;
% middle = 1;
% ring = .9;
% pinkie1 = 1;
% pinkierest = .8;
% thumb = 1.8;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% uncomment to unweight
% wrist = 1;
% index = 1;
% middle = 1;
% ring = 1;
% pinkie1 = 1;
% pinkierest = 1;
% thumb = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% joint_weights = [repmat(wrist, 2, 1); repmat(index, 4, 1); repmat(middle, 4, 1);
%     repmat(ring, 4, 1); pinkie1; repmat(pinkierest, 4, 1); repmat(thumb, 5, 1)];
% 
% joint_weights  = joint_weights / norm(joint_weights);
% 

residual = zeros(size(poses, 2), 1);


for i = 1 : size(poses, 2)
    pose = poses(:, i) - originpos;
    %find pose in terms of synergy space zero
    
    
    syncoef = inv(space'*space)*space'*pose;
    synrep = space * syncoef;
    residual(i, 1) = norm(pose - synrep);
%     residual(i, 1) = norm((pose - synrep) .* joint_weights);
end


end
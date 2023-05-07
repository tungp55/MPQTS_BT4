% Weight Function of Goal seeking behavior and V-Formation
function [WeightsMatrix] = WeightFunction_Seek_Formation_V(Target, Boids, BoidsNum, Alpha_Horizontal, D_Behind, D_Beside)
% Weight for the 1-st Boid
WeightsMatrix(1) = 1;
% Find the Arrival force of 2-nd boids
f_goal = steer_seek(Boids(2,:),Target);
% Find the right postion of 1-st Boid in the V-Formation
[RightBesideLeader, ~] = FindBesideLeader(Boids(1,:), Alpha_Horizontal, D_Behind, D_Beside);
% Calculate formation force (force to make boid keep the V-formation)
% It's force to make the boid come to the right point after the predecessor
f_formation = steer_pursue_arrival(Boids(2,:),RightBesideLeader);

% Weight for the 2-nd boid
WeightsMatrix(2) = mag(f_formation) / mag(f_goal);

% Calculate weight for other Boids
for Index = 3:BoidsNum
    % Calculate the goal following force (the force to make boid go to the goal)
    f_goal = steer_seek(Boids(Index,:),Target);
    if (mod(Index,2) == 1)  % for odd indexs (left branch)
        [~, LeftBesideLeader] = FindBesideLeader(Boids(Index-2,:), Alpha_Horizontal, D_Behind, D_Beside);
        f_formation = steer_pursue_arrival(Boids(Index,:),LeftBesideLeader);
    else % for even indexs
        [RightBesideLeader, ~] = FindBesideLeader(Boids(Index-2,:), Alpha_Horizontal, D_Behind, D_Beside);
        f_formation = steer_pursue_arrival(Boids(Index,:),RightBesideLeader);
    end
    % Calculate weights for the other boids except 1-st and 2-nd Boids
    WeightsMatrix(Index) = mag(f_formation) / mag(f_goal);
end
end
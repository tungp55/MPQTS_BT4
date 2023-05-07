function [Boids, BoidsIndex]  = steer_Arrival_Formation_Arc(Target, Boids, Leader, D_Behind, D_Beside,...
                    Alpha_Horizontal, NumberBoidsOnTop, NumberBoidsOnBranch)
global BoidsNum;

% Array of flags for boids to mark what boid is arranged to the left or the right
% BoidsFlag(i) = 1 means the Boid i-th was arranged to the left or the right
BoidsFlag = zeros(1, BoidsNum);
BoidsFlag(1) = 1;

% Calculate the Weights for each Boid
WeightsMatrix = WeightFunction_Arrival_Formation_V(Target, Boids, BoidsNum, Alpha_Horizontal, D_Behind, D_Beside);
BoidsIndex(1) = 1;

[RightBesideLeader, LeftBesideLeader] = FindBesideLeader(Leader, Alpha_Horizontal, D_Behind, D_Beside);
[LeaderRight,BoidsFlag,MinRightIndex] = NearestBoid(RightBesideLeader, BoidsFlag);
BoidsIndex(2) = MinRightIndex;
Weight = WeightsMatrix(MinRightIndex);
[LeaderRight,Boids] = Move_Arrival_Formations(Target, Weight, Boids, LeaderRight,Leader,RightBesideLeader, MinRightIndex);

[LeaderLeft,BoidsFlag,MinLeftIndex] = NearestBoid(LeftBesideLeader, BoidsFlag);
BoidsIndex(3) = MinLeftIndex;
Weight = WeightsMatrix(MinLeftIndex);
[LeaderLeft, Boids] = Move_Arrival_Formations(Target, Weight, Boids,LeaderLeft,Leader,LeftBesideLeader,MinLeftIndex);

while (sum(BoidsFlag) < BoidsNum)    
    BoidIndex = sum(BoidsFlag) + 1;
    D_Beside_tmp = D_Beside;
    D_Behind_tmp = D_Behind;
    if ((BoidIndex > NumberBoidsOnTop) && (BoidIndex <= NumberBoidsOnTop + 2*NumberBoidsOnBranch))
        D_Behind_tmp = D_Behind + 10;
        D_Beside_tmp = D_Beside_tmp - 10;
    else
        if (BoidIndex >= NumberBoidsOnTop + NumberBoidsOnBranch)          
            D_Behind_tmp = D_Behind + 20;
        end
    end
    
    [RightBesideLeader, ~] = FindBesideLeader(LeaderRight, Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
    [NearestRight, BoidsFlag, MinRightIndex] = NearestBoid(RightBesideLeader, BoidsFlag);
    BoidsIndex(BoidIndex) =  MinRightIndex;  
    Weight = WeightsMatrix(MinRightIndex);
    [NearestRight, Boids] = Move_Arrival_Formations(Target, Weight, Boids, NearestRight,LeaderRight,RightBesideLeader, MinRightIndex);
    LeaderRight = NearestRight;
    
    [~, LeftBesideLeader] = FindBesideLeader(LeaderLeft, Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
    [NearestLeft,BoidsFlag,MinLeftIndex] = NearestBoid(LeftBesideLeader, BoidsFlag);
    BoidsIndex(BoidIndex + 1) =  MinLeftIndex;
    Weight = WeightsMatrix(MinLeftIndex);
    [NearestLeft, Boids] = Move_Arrival_Formations(Target, Weight, Boids, NearestLeft,LeaderLeft,LeftBesideLeader, MinLeftIndex);
    LeaderLeft = NearestLeft;
end
end
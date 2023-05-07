function [Boids, BoidsIndex]  = steer_Seek_Formation_V(Target, Boids,BoidsNum, Leader, D_Behind, D_Beside, Alpha_Horizontal)
%global BoidsNum;

BoidsFlag = zeros(1, BoidsNum);
BoidsFlag(1) = 1;

% Calculate the Weights for each Boid
WeightsMatrix = WeightFunction_Seek_Formation_V(Target, Boids, BoidsNum, Alpha_Horizontal, D_Behind, D_Beside);

BoidsIndex(1) = 1;
[RightBesideLeader, LeftBesideLeader] = FindBesideLeader(Leader, Alpha_Horizontal, D_Behind, D_Beside);
[LeaderRight,BoidsFlag,MinRightIndex] = NearestBoid(RightBesideLeader, BoidsFlag, Boids, BoidsNum);
BoidsIndex(2) = MinRightIndex; 
Weight = WeightsMatrix(MinRightIndex);
[LeaderRight, Boids] = Move_Seek_Formations(Target, Weight, Boids, BoidsNum, LeaderRight,Leader, RightBesideLeader, MinRightIndex);

[LeaderLeft,BoidsFlag,MinLeftIndex] = NearestBoid(LeftBesideLeader, BoidsFlag, Boids, BoidsNum);
BoidsIndex(3) = MinLeftIndex;
Weight = WeightsMatrix(MinLeftIndex);
[LeaderLeft, Boids] = Move_Seek_Formations(Target, Weight,Boids, BoidsNum, LeaderLeft,Leader,LeftBesideLeader,MinLeftIndex);

while (sum(BoidsFlag) < BoidsNum)    
    BoidIndex = sum(BoidsFlag) + 1;
    [RightBesideLeader, ~] = FindBesideLeader(LeaderRight, Alpha_Horizontal, D_Behind, D_Beside);
    [NearestRight, BoidsFlag, MinRightIndex] = NearestBoid(RightBesideLeader, BoidsFlag, Boids, BoidsNum);
    BoidsIndex(BoidIndex) =  MinRightIndex;   
     Weight = WeightsMatrix(MinRightIndex);
    [NearestRight, Boids] = Move_Seek_Formations(Target, Weight, Boids,BoidsNum, NearestRight,LeaderRight,RightBesideLeader, MinRightIndex);
    LeaderRight = NearestRight;
    
    [~, LeftBesideLeader] = FindBesideLeader(LeaderLeft, Alpha_Horizontal, D_Behind, D_Beside);
    [NearestLeft,BoidsFlag,MinLeftIndex] = NearestBoid(RightBesideLeader, BoidsFlag, Boids, BoidsNum);
    BoidsIndex(BoidIndex + 1) =  MinLeftIndex;   
    Weight = WeightsMatrix(MinLeftIndex);
    [NearestLeft, Boids] = Move_Seek_Formations(Target, Weight, Boids, BoidsNum, NearestLeft,LeaderLeft,LeftBesideLeader, MinLeftIndex);
    LeaderLeft = NearestLeft;
end
end
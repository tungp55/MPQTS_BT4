function [Boids, BoidsIndex]  = steer_CollisionAvoidance_Formation_Column(Boids, Leader, D_Behind)
global BoidsNum;

BoidsFlag = zeros(1, BoidsNum);
BoidsFlag(1) = 1;

% Calculate the Weights for each Boid
WeightsMatrix = WeightFunction_CollisionAvoidance_Formation_Column(Boids, BoidsNum, D_Behind);

BoidsIndex(1) = 1;
BehindLeader = FindBehindLeader(Leader, D_Behind);
[LeaderBehind,BoidsFlag,MinIndex] = NearestBoid(BehindLeader, BoidsFlag);

BoidsIndex(2) = MinIndex; 
Weight = WeightsMatrix(MinIndex);
[LeaderBehind, Boids] = Move_CollisionAvoidance_Formations(Weight, Boids, LeaderBehind,Leader, BehindLeader, MinIndex);

while (sum(BoidsFlag) < BoidsNum)    
    BoidIndex = sum(BoidsFlag) + 1;
    BehindLeader = FindBehindLeader(LeaderBehind, D_Behind);
    [NearestRight, BoidsFlag, MinIndex] = NearestBoid(BehindLeader, BoidsFlag);
    BoidsIndex(BoidIndex) =  MinIndex;   
    Weight = WeightsMatrix(MinIndex);
    [NearestRight, Boids] = Move_CollisionAvoidance_Formations(Weight, Boids, NearestRight,LeaderBehind,BehindLeader, MinIndex);
    LeaderBehind = NearestRight;
end
end
function [Boids, BoidsIndex]  = steer_Arrival_Formation_Column(Target, Boids, Leader, D_Behind)
global BoidsNum;

BoidsFlag = zeros(1, BoidsNum);
BoidsFlag(1) = 1;

% Calculate the Weights for each Boid
WeightsMatrix = WeightFunction_Arrival_Formation_Column(Target, Boids, BoidsNum, D_Behind);

BoidsIndex(1) = 1;
BehindLeader = FindBehindLeader(Leader, D_Behind);
[LeaderBehind,BoidsFlag,MinIndex] = NearestBoid(BehindLeader, BoidsFlag);

BoidsIndex(2) = MinIndex; 
Weight = WeightsMatrix(MinIndex);
[LeaderBehind, Boids] = Move_Arrival_Formations(Target, Weight, Boids, LeaderBehind,Leader, BehindLeader, MinIndex);

while (sum(BoidsFlag) < BoidsNum)    
    BoidIndex = sum(BoidsFlag) + 1;
    BehindLeader = FindBehindLeader(LeaderBehind, D_Behind);
    [NearestRight, BoidsFlag, MinIndex] = NearestBoid(BehindLeader, BoidsFlag);
    BoidsIndex(BoidIndex) =  MinIndex;   
    Weight = WeightsMatrix(MinIndex);
    [NearestRight, Boids] = Move_Arrival_Formations(Target, Weight, Boids, NearestRight,LeaderBehind,BehindLeader, MinIndex);
    LeaderBehind = NearestRight;
end
end
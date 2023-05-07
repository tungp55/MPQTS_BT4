function [Boids, BoidsIndex]  = steer_Seek_Formation_Column(Target, Boids, Leader, D_Behind, BoidsNum)
%global BoidsNum;

BoidsFlag = zeros(1, BoidsNum);
BoidsFlag(1) = 1;

% Calculate the Weights for each Boid
WeightsMatrix = WeightFunction_Seek_Formation_Column(Target, Boids, BoidsNum, D_Behind);

BoidsIndex(1) = 1;
BehindLeader = FindBehindLeader(Leader, D_Behind);
[LeaderBehind,BoidsFlag,MinIndex] = NearestBoid(BehindLeader, BoidsFlag, Boids, BoidsNum);

BoidsIndex(2) = MinIndex;
Weight = WeightsMatrix(MinIndex);


[LeaderBehind, Boids] = Move_Seek_Formation_Column(Target, Weight, Boids,BoidsNum, LeaderBehind,Leader, BehindLeader, MinIndex);


while (sum(BoidsFlag) < BoidsNum)
    BoidIndex = sum(BoidsFlag) + 1;
    BehindLeader = FindBehindLeader(LeaderBehind, D_Behind);
    [NearestRight, BoidsFlag, MinIndex] = NearestBoid(BehindLeader, BoidsFlag, Boids, BoidsNum);
    BoidsIndex(BoidIndex) =  MinIndex;
    Weight = WeightsMatrix(MinIndex);
    [NearestRight, Boids] = Move_Seek_Formation_Column(Target, Weight, Boids,BoidsNum, NearestRight,LeaderBehind,BehindLeader, MinIndex);
    LeaderBehind = NearestRight;
end
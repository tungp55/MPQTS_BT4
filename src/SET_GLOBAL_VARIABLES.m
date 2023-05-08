function SET_GLOBAL_VARIABLES()
global EnvironmentWidth ImageWidth SafeDistance AlignmentRange CohesionRange ...
    wanderAngle FleeDistance SpeedCorrection ...
    TargetsNum Targets D_BehindLeader  ObstaclesNum Obstacles ObstaclesNumB ObstaclesB ObstaclesNumG ObstaclesG ObstaclesNumR ObstaclesR ObstaclesF...  
     blueImg redImg heliImg HeliWidth battleShipImg battleShipWidth tankImg TankWidth...
    BlueMau RedMau...
     FlightsNum BoidsNum Boids Greens GreenNum ArmyBlues ArmyBluesNum...
    DameOfBlue DameOfRed DameOfGreen ...
    AccuracyB AccuracyR AccuracyG DieGNum DieRNum DieBNum...
    ShootDistanceB ShootDistanceR ShootDistanceG SizeHPBar BloodPos RedsHP BluesHP  kB kR Target1 Target2 Boids1...
    Cars CarsNum;

global xConTin
global yConTin

xConTin = 750;
yConTin = 750;

%%

EnvironmentWidth = 800;
ImageWidth = 40;
HeliWidth = EnvironmentWidth / 15;
TankWidth = EnvironmentWidth / 5;
battleShipWidth = EnvironmentWidth/8;
SafeDistance = EnvironmentWidth/40; % set separation range
AlignmentRange = EnvironmentWidth/10; % set alignment range
CohesionRange = EnvironmentWidth/8; % set cohesion range
wanderAngle = 10;
FleeDistance = 200;
SpeedCorrection = 200;

%Number of Targets
TargetsNum = 1;
D_BehindLeader = 1;


%% Boids data
%List of Boids
BoidsNum = 5; % so luong quan ta
Boids = zeros(BoidsNum,15); % initialize boids matrix
%{1-3 position, 4-6 velocity, 7-9 accelaration, 10 maxspeed, 11 maxforce, 12 angle,
% 13 max see ahead (for collision avoidance), 14 max avoid force (collision avoidance)
%}

Boids(:,1:2) = 10*(2*rand([BoidsNum,2])-1); % set random position
% Boids(:,1:2) = 100;
Boids(:,4:5) = 10; %200*(2*rand([BoidsNum,2])-1); % set random velocity
Boids(:,10) =3;%*(rand([BoidsNum,1]) + 0.2); % set maxspeed
Boids(1,10) = 2; % toc do nguoi di dau quan ta
Boids(8:BoidsNum, 10) = 2; % toc do quan ta phia sau
Boids(:,11) = 2; % set maxforce
Boids(:,13) = 10; % set max see ahead
Boids(:,14) = 10; % set max avoid force
Boids(:,15) = 100; % set max blood

% quan dich
ArmyBluesNum = 9;
ArmyBlues = zeros(ArmyBluesNum,15); % initialize boids matrix
%{1-3 position, 4-6 velocity, 7-9 accelaration, 10 maxspeed, 11 maxforce, 12 angle,
% 13 max see ahead (for collision avoidance), 14 max avoid force (collision avoidance)
%}
% ArmyBlues(:,1:2) = EnvironmentWidth*(2*rand([ArmyBluesNum,2])-1); % set random position
ArmyBlues(:,1) =300 + (700-300).*rand(ArmyBluesNum,1);
ArmyBlues(:,2) =400 + (700-400).*rand(ArmyBluesNum,1);
% ArmyBlues(:,2) = 600;
ArmyBlues(:,4:5) = 200; %200*(2*rand([BoidsNum,2])-1); % set random velocity
ArmyBlues(:,10) = 2;%*(rand([BoidsNum,1]) + 0.2); % set maxspeed
ArmyBlues(:,11) = 2; % set maxforce
ArmyBlues(:,13) = 10; % set max see ahead
ArmyBlues(:,14) = 10; % set max avoid force
ArmyBlues(:,15) = 100; % set blood

%%%%%
% quan giai cuu

GreenNum = 3; % so luong quan ta
Greens = zeros(GreenNum,15); % initialize boids matrix
%{1-3 position, 4-6 velocity, 7-9 accelaration, 10 maxspeed, 11 maxforce, 12 angle,
% 13 max see ahead (for collision avoidance), 14 max avoid force (collision avoidance)
%}
% Greens(:,1:2) = EnvironmentWidth*(2*rand([ArmyBluesNum,2])-1); % set random position
Greens(:,1) =200 + (600-200).*rand(GreenNum,1);
Greens(:,2) =400 + (700-400).*rand(GreenNum,1);
% Greens(:,2) = 600;
Greens(:,4:5) = 30; %200*(2*rand([BoidsNum,2])-1); % set random velocity
Greens(:,10) = 4;%*(rand([BoidsNum,1]) + 0.2); % set maxspeed
Greens(1,10) = 4; % toc do nguoi di dau quan ta
Greens(8:GreenNum, 10) = 4; % toc do quan ta phia sau
Greens(:,11) = 10; % set maxforce
Greens(:,13) = 10; % set max see ahead
Greens(:,14) = 10; % set max avoid force
Greens(:,15) = 100; % set blood


%%
%car
CarsNum = 1;
Cars = zeros(CarsNum,14); % initialize boids matrix
%{1-3 position, 4-6 velocity, 7-9 accelaration, 10 maxspeed, 11 maxforce, 12 angle,
% 13 max see ahead (for collision avoidance), 14 max avoid force (collision avoidance)
%}
% Cars(:,1:2) = EnvironmentWidth*(2*rand([CarsNum,2])-1); % set random position
Cars(:,1) =xConTin;
Cars(:,2) =yConTin;
% Cars(:,2) = 600;
Cars(:,4:5) = 70; %200*(2*rand([BoidsNum,2])-1); % set random velocity
Cars(:,10) = 7;%*(rand([BoidsNum,1]) + 0.2); % set maxspeed
Cars(:,11) = 2; % set maxforce
Cars(:,13) = 10; % set max see ahead
Cars(:,14) = 10; % set max avoid force


%% Set static Obstacle data
ObstaclesNum = 6;
Obstacles=zeros(ObstaclesNum,4);
ObstaclesNumB = 1;
ObstaclesB = [0 0 0 0];
ObstaclesNumR = 1;
ObstaclesR = [0 0 0 0];
ObstaclesNumG = 1;
ObstaclesG = [0 0 0 0];


%% Targets data. The targets may be leaders, persuaders... that the flock of agents want to follow.
%List of targets
Targets = zeros(TargetsNum,14);
Targets(:,1:2) = rand([TargetsNum,2])-1; % set random position
Targets(:,4:5) = 2*(2*rand([TargetsNum,2])-1); % set random velocity
Targets(:,10) = 2; % set maxspeed
Targets(:,11) = 2; % set maxforce
Targets(:,13) = 20; % set max see ahead
Targets(:,14) = 2; % set max avoid force

%% Set static Obstacle data

%% Accuracy
AccuracyB = 95;%; % do chinh xac
AccuracyR = 30;%;
AccuracyG = 95;%;
ShootDistanceB = 400; 
ShootDistanceR = 100;
ShootDistanceG = 500;
BloodPos=5;
DieRNum =0 ; 
DieBNum =0;
DieGNum =0;
SizeHPBar=1;
%% Variables
DameOfBlue = 90;
DameOfRed=50;
DameOfGreen=40;

%% Boom

end

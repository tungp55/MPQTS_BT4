function main2
global ArmyBluesNum;
global Boids;
global CarsNum;
CarsNum = 1;
% Set global variables
SET_GLOBAL_VARIABLES()

%% -------------------BEGIN IMPLEMENTATION--------------------------------
        BoidsNum = 3; % so luong quan ta
        Boids(1,10) = 2; % toc do nguoi di dau quan ta
        Boids(8:BoidsNum, 10) = 2; % toc do quan ta phia sau
        ArmyBluesNum = 7; % so luong quan dich
        Behavior__Seek_Formation_Column();
   
end



%---------------------- END IMPLEMENTATION------------------------------

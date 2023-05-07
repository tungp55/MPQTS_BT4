function main ()

%% %% Global variables
global TimeSteps;
TimeSteps = 50000;

global CarsNum;

CarsNum = 1;
% Set global variables
SET_GLOBAL_VARIABLES()

%% -------------------BEGIN IMPLEMENTATION--------------------------------

        Behavior__Seek_Formation_Column();
   
end



%---------------------- END IMPLEMENTATION------------------------------

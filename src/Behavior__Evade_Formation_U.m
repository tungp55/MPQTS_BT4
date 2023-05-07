function Behavior__Evade_Formation_U()
%% global variables
global TimeSteps;
global BoidsNum;
global Boids;
global Targets;
global TargetsNum;
global SaveMousePosition;
global saveText;
global ImageWidth;
global FleeDistance;
% Number of boids on the top of U-formation
global NumberBoidsOnTop;
% Number of boids on the the branch of U-formation
global NumberBoidsOnBranch;
Wingspan = ImageWidth;
% Number of boids on the top of U-formation
NumberBoidsOnTop = 3;
% Number of boids on the the branch of U-formation
NumberBoidsOnBranch = 1;
% Angle at top of U-formation
Alpha_U_Formation = 9*pi/9;
% Distance beside leader in the U-formation
D_Beside = Wingspan*(4 + pi)/8 + 30;
% Distance behind leader in the U-formation
D_Behind = Wingspan*(4 + pi)/(8*tan(Alpha_U_Formation/2)) + 10;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();
[v_Image_r,v_Alpha_r,TargetsPlot] = InitializeTargetBird();

%Initialize the first positon of Goal
RandomPosition = [250 300 0 0 0 0];
MousePosition = [250 300 0 0 0 0];
SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
titleStr = 'Implementation of U-Formation and Evade behavior';
titleStr = [titleStr newline '(The red bird is a pursuer. Use mouse to create a new target for pursuer)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(~,~)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3:6) = 0;
        MousePosition = cursorPosition;
        %Delete the old Target and Redraw a new Target
        delete(SaveMousePosition);
        %Draw Circle - Targer
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
        delete(saveText);
        saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
    end

%% calculate agents' positions to move to each iteration
setappdata(0, 'OldTarget', Targets(1, 1:3));

%% INITIALIZE U-FORMATION FOR FLOCK
Boids(1,1:3) = [-100 -100 0];
Boids(1,:) = applyForce(Boids(1,:), 0);
Leader = Boids(1, :);

% Calculate the horizontal angle of the Leader
Alpha_Horizontal = CalculationHorizontalAngle(Leader);

%Find the RightBeside and LeftBeside positions of Leader
[RightBesidePosition, LeftBesidePosition] = FindBesideLeader(Leader, ...
    Alpha_Horizontal, D_Behind, D_Beside);

% Assign 2-nd Boid to the right of 1-st Boid
Boids(2, 1:6) = RightBesidePosition;
Boids(2,:) = applyForce(Boids(2,:), 0);
RightBesidePosition = Boids(2, :);

% Assign 3-rd boid to the left of of 1-st Boid
Boids(3, 1:6) = LeftBesidePosition;
Boids(3,:) = applyForce(Boids(3,:), 0);
LeftBesidePosition = Boids(3, :);

BoidIndex = 4;
while BoidIndex <= BoidsNum
    D_Beside_tmp = D_Beside;
    D_Behind_tmp = D_Behind;
    if ((BoidIndex > NumberBoidsOnTop) && (BoidIndex <= NumberBoidsOnTop + 2*NumberBoidsOnBranch))
        D_Behind_tmp = D_Behind + 30;
        D_Beside_tmp = D_Beside_tmp - 10;
    else
        if (BoidIndex >= NumberBoidsOnTop + 2*NumberBoidsOnBranch)
            D_Beside_tmp = 0;
            D_Behind_tmp = D_Behind + 50;
        end
    end
    
    %Find the RightBeside position of RightBesidePosition (2-nd Boid)
    [RightBesidePosition, ~] = FindBesideLeader(RightBesidePosition, ...
        Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
    Boids(BoidIndex, 1:6) = RightBesidePosition;
    RightBesidePosition = Boids(BoidIndex,:);
    Boids(BoidIndex,:) = applyForce(Boids(BoidIndex,:), 0);
    
    BoidIndex = BoidIndex + 1;
    [~, LeftBesidePosition] = FindBesideLeader(LeftBesidePosition, ...
        Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
    Boids(BoidIndex, 1:6) = LeftBesidePosition;
    LeftBesidePosition = Boids(BoidIndex,:);
    Boids(BoidIndex,:) = applyForce(Boids(BoidIndex,:), 0);
    
    BoidIndex = BoidIndex + 1;
end
RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);

%% FLOCK MOVE TO THE GOAL
% Generate random colors for drawing the footprints of boids
for BoidIndex = 1:BoidsNum
    randomColors(BoidIndex,1:3) = rand(1,3);
end

timeTick = 1;
while (timeTick < TimeSteps)      
    %% Moving Targets
    for TargetIndex = 1:TargetsNum
        Targets = updateAtBoundary(Targets, TargetIndex);
        CurrentTarget = Targets(TargetIndex, :);
        Seekforce = steer_seek(CurrentTarget, MousePosition); %Move toward the mouse
        Targets(TargetIndex,:) = applyForce(CurrentTarget, Seekforce);
    end
    RedrawGraphics(Targets,TargetsNum,v_Image_r,v_Alpha_r,TargetsPlot);
    %End of Moving Target
    
    Target = Targets(1, :);
    target_velocity = Targets(1, 4:6);
    OldTarget = getappdata(0,'OldTarget');
    setappdata(0, 'OldTarget', Target);
    
    %% Moving the 1-st Boid (as a leader)
     force = 0.1*steer_arrival(Boids(1,:), RandomPosition); 
    force = force + steer_evade(Boids(1,:), Target(1,1:3), target_velocity, FleeDistance);    
    Boids(1,:) = applyForce(Boids(1,:), force);
    
    %% Moving Boids
    Leader = Boids(1, :);
    Alpha_Horizontal = CalculationHorizontalAngle(Leader);
    [Boids, BoidsIndex] = steer_Evade_Formation_U(MousePosition, Boids, Leader, ...
        D_Behind,D_Beside, Alpha_Horizontal, ...
        NumberBoidsOnTop, NumberBoidsOnBranch);
    % Draw the footprint and lines of U-formation every 10 steps
    if (timeTick == 1 || mod(timeTick,100) == 0)
        for BoidIndex = 1:BoidsNum
            %Draw footprints of Boids
            plot(Boids(BoidIndex, 1), Boids(BoidIndex, 2), 'o', 'MarkerSize', ...
                3,'MarkerFaceColor',randomColors(BoidIndex, 1:3),'Color',...
                randomColors(BoidIndex, 1:3));
        end
        %Draw lines of U-formation
        line([Boids(BoidsIndex(1),1), Boids(BoidsIndex(2),1)],[Boids(BoidsIndex(1),2), Boids(BoidsIndex(2),2)],'Color','red','LineStyle','-')
        for BoidIndex = 1:BoidsNum-2
            line([Boids(BoidsIndex(BoidIndex),1), Boids(BoidsIndex(BoidIndex + 2),1)],...
                [Boids(BoidsIndex(BoidIndex),2), Boids(BoidsIndex(BoidIndex + 2),2)],'Color','red','LineStyle','-')
        end
    end
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    % End of Moving Boids
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('U-Formation_EvadeBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
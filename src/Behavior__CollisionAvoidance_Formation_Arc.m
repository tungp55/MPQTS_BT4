function Behavior__CollisionAvoidance_Formation_Arc()
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
global Obstacles;
global ObstaclesNum;
global EnvironmentWidth;
Wingspan = ImageWidth;

% Number of boids on the top of Arc-formation
NumberBoidsOnTop = 4;
% Number of boids on the the branch of Arc-formation
NumberBoidsOnBranch = 2;
%Angle at top of Arc-formation
Alpha_Arc_Formation = 7*pi/9;
% Distance beside leader in the Arc-formation
D_Beside = Wingspan*(4 + pi)/8 + 20;
% Distance behind leader in the Arc-formation
D_Behind = Wingspan*(4 + pi)/(8*tan(Alpha_Arc_Formation/2));

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

%Initialize the first positon of Goal
RandomPosition = [250 300 0 0 0 0];
MousePosition = [250 300 0 0 0 0];
titleStr = 'Implementation of Arc-Formation and Collision Avoidance behavior';
titleStr = [titleStr newline '(Use mouse to create a new obstacle)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        cursorPosition(4) = 40;
        MousePosition = cursorPosition;
        %Delete the old Target and Redraw a new Target
       % delete(SaveMousePosition);
        ObstaclesNum = ObstaclesNum + 1;
        Obstacles(ObstaclesNum, 1:4) = zeros(1, 4);       
        %Draw Circle - Targer      
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',EnvironmentWidth/20, 'MarkerFaceColor','blue','Color','blue');
        Obstacles(ObstaclesNum, 1:4) = MousePosition(1:4);       
    end

%% calculate agents' positions to move to each iteration
setappdata(0, 'OldTarget', Targets(1, 1:3));

%% INITIALIZE ARC-FORMATION FOR FLOCK
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
        D_Behind_tmp = D_Behind + 10;
        D_Beside_tmp = D_Beside_tmp - 10;
    else
        if (BoidIndex >= NumberBoidsOnTop + 2*NumberBoidsOnBranch)            
            D_Behind_tmp = D_Behind + 20;
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
    %% Moving the 1-st Boid (as a leader)
     force = 0.1*steer_arrival(Boids(1,:), RandomPosition); 
    force = force + steer_collision_avoidance(Boids(1,:));    
    Boids(1,:) = applyForce(Boids(1,:), force);
    
    %% Moving Boids
    Leader = Boids(1, :);      
    Alpha_Horizontal = CalculationHorizontalAngle(Leader);        
    [Boids, BoidsIndex] = steer_CollisionAvoidance_Formation_Arc(Boids, Leader, D_Behind, D_Beside,...
                    Alpha_Horizontal, NumberBoidsOnTop, NumberBoidsOnBranch);
    
    % Draw the footprint and lines of Arc-formation every 10 steps
    if (timeTick == 1 || mod(timeTick,100) == 0)
        for BoidIndex = 1:BoidsNum
            %Draw footprints of Boids
            plot(Boids(BoidIndex, 1), Boids(BoidIndex, 2), 'o', 'MarkerSize', ...
                3,'MarkerFaceColor',randomColors(BoidIndex, 1:3),'Color',...
                randomColors(BoidIndex, 1:3));
        end
        %Draw lines of V-formation
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
MyMovie = VideoWriter('Arc-Formation_CollisionAvoidanceBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
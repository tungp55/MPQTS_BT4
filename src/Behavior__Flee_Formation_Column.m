function Behavior__Flee_Formation_Column()
%% global variables
global TimeSteps;
global BoidsNum;
global Boids;
global Targets;
global SaveMousePosition;
global saveText;
global FleeDistance;

% Distance behind leader in the Column-formation
D_Behind = 60; 

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

%Initialize the first positon of Goal
RandomPosition = [250 300 0 0 0 0];
MousePosition = [250 300 0 0 0 0];
SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
titleStr = 'Implementation of Column-Formation and Flee behavior';
titleStr = [titleStr newline '(Use mouse click to create a new goal)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
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

%% INITIALIZE COLUMN-FORMATION FOR FLOCK
Boids(1,1:3) = [-100 -100 0];
Boids(1,:) = applyForce(Boids(1,:), 0);
Leader = Boids(1, :);
BehindPosition  = Leader;
BoidIndex = 2;
while BoidIndex <= BoidsNum
    %Find the RightBeside position of RightBesidePosition (2-nd Boid)
    BehindPosition = FindBehindLeader(BehindPosition,D_Behind);
    Boids(BoidIndex, 1:6) = BehindPosition;
    BehindPosition = Boids(BoidIndex,:);
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
    force = force + steer_flee(Boids(1,:), MousePosition, FleeDistance);
    Boids(1,:) = applyForce(Boids(1,:), force);
    
    %% Moving Boids
    Leader = Boids(1, :);            
    [Boids, BoidsIndex] = steer_Flee_Formation_Column(MousePosition, Boids, Leader, D_Behind);
    
    % Draw the footprint and lines of Column-formation every 20 steps
    if (mod(timeTick,40) == 0)
        for BoidIndex = 1:BoidsNum
            %Draw footprints of Boids
            plot(Boids(BoidIndex, 1), Boids(BoidIndex, 2), 'o', 'MarkerSize', ...
                5,'MarkerFaceColor',randomColors(BoidIndex, 1:3),'Color',...
                randomColors(BoidIndex, 1:3));
        end        
        %Draw lines of Column-formation       
        for BoidIndex = 1:BoidsNum-1
            line([Boids(BoidsIndex(BoidIndex),1), Boids(BoidsIndex(BoidIndex + 1),1)],...
                 [Boids(BoidsIndex(BoidIndex),2), Boids(BoidsIndex(BoidIndex + 1),2)],'Color','red','LineStyle','-')
        end               
    end    
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);    
    % End of Moving Boids
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('Column-Formation_FleeBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
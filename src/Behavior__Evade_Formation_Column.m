function Behavior__Evade_Formation_Column()
%% global variables
global TimeSteps;
global BoidsNum;
global Boids;
global Targets;
global TargetsNum;
global SaveMousePosition;
global saveText;
global FleeDistance;

% Distance behind leader in the Column-formation
D_Behind = 60; 

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();
[v_Image_r,v_Alpha_r,TargetsPlot] = InitializeTargetBird();

%Initialize the first positon of Goal
RandomPosition = [250 300 0 0 0 0];
MousePosition = [250 300 0 0 0 0];
SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
titleStr = 'Implementation of Column-Formation and Evade behavior';
titleStr = [titleStr newline '(The red bird is a pursuer. Use mouse to create a new target for pursuer)'];
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
    [Boids, BoidsIndex] = steer_Evade_Formation_Column(MousePosition, Boids, Leader, D_Behind);
    
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
MyMovie = VideoWriter('Column-Formation_EvadeBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
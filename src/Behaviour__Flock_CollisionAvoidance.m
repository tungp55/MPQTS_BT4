function Behaviour__Flock_CollisionAvoidance ()
%% global variables
global EnvironmentWidth;
global TimeSteps;
global SaveMousePosition;
global Boids;
global BoidsNum;
global Obstacles;
global ObstaclesNum;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

MousePosition = [0 0 0];
titleStr = 'Combination of Flocking and Collision Avoidance Behaviors';
titleStr = [titleStr newline '(Use mouse to create a new obstacle)']
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
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',EnvironmentWidth/10, 'MarkerFaceColor','blue','Color','blue');
        Obstacles(ObstaclesNum, 1:4) = MousePosition(1:4);
    end

%% calculate agents' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
        
        cohesion_force = steer_cohesion(CurrentBoid);
        seperation_force = steer_separation(CurrentBoid);
        alignment_force = steer_alignment(CurrentBoid);
        
        collision_avoidance = steer_collision_avoidance(CurrentBoid);
        
        force = seperation_force*1.5 + alignment_force*1 + cohesion_force*1 + 2*collision_avoidance;
        
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
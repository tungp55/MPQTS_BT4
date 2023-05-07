function Behaviour__CollisionAvoidance ()
%% global variables
global EnvironmentWidth;
global SaveMousePosition;
global TimeSteps;
global Boids;
global BoidsNum;
global Obstacles;
global ObstaclesNum;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

% draw predefined obstacles
for i = 1:ObstaclesNum
    obstacle = Obstacles(i,:);
    %p_obstacle = plot(obstacle(1), obstacle(2), 'o','MarkerFaceColor','r','Color','r');
    plot(obstacle(1), obstacle(2), 'o','MarkerSize',obstacle(4), 'MarkerFaceColor','blue','Color','blue');
end

MousePosition = [0 0 0];
titleStr = 'Implementation of Collision Avoidance Behavior';
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
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum
        Boids = updateAtBoundary(Boids,BoidIndex);
        %Steering Force
        CurrentBoid = Boids(BoidIndex, :);       
        force = steer_collision_avoidance(CurrentBoid);        
       % force = steer_collision_avoidance(Boids, BoidIndex,  Obstacles, ObstaclesNum);        
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
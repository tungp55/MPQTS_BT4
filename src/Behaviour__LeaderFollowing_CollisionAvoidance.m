function Behaviour__LeaderFollowing_CollisionAvoidance ()
%% global variables
global EnvironmentWidth;
global TimeSteps;
global SaveMousePosition;
global Boids;
global BoidsNum;
global Obstacles;
global ObstaclesNum;
global D_BehindLeader;
global FleeDistance;
global TargetsNum;
global Targets;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();
[v_Image_r,v_Alpha_r,TargetsPlot] = InitializeTargetBird();

MousePosition = [0 0 0];
titleStr = 'Combination of Leader following and Collision Avoidance Behaviors';
titleStr = [titleStr newline '(Use mouse click to create a new obstacle)'];
titleStr = [titleStr newline '(Move the cursor to make the Leader move)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);
set(fHandler, 'WindowButtonMotionFcn',@cursorMoveCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;       
        MousePosition = cursorPosition;
        %Delete the old Target and Redraw a new Target
        % delete(SaveMousePosition);
        ObstaclesNum = ObstaclesNum + 1;
        Obstacles(ObstaclesNum, 1:4) = zeros(1, 4);
        %Draw Circle - Targer
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',EnvironmentWidth/10, 'MarkerFaceColor','blue','Color','blue');
        Obstacles(ObstaclesNum, 1:3) = MousePosition(1:3);
        Obstacles(ObstaclesNum, 4) = 40;
    end

%Event Mouse move
 function cursorPosition = cursorMoveCallback(o,e)
       p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        MousePosition = cursorPosition;                
    end

%% calculate agents' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    %% Moving Targets
    for TargetIndex = 1:TargetsNum
        Targets = updateAtBoundary(Targets, TargetIndex);
        CurrentTarget = Targets(TargetIndex, :);
        if (any(MousePosition) || (timeTick == 1))
            Seekforce = steer_arrival(CurrentTarget, MousePosition); %Move toward the mouse
            Targets(TargetIndex,:) = applyForce(CurrentTarget, Seekforce);            
        end
    end
    RedrawGraphics(Targets,TargetsNum,v_Image_r,v_Alpha_r,TargetsPlot);
    %End of Moving Target
    
    
    for BoidIndex = 1:BoidsNum
        Leader = Targets(1, :);
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
                       
        collision_avoidance_force = steer_collision_avoidance(CurrentBoid);
        
        leader_following_force = steer_leader_following(CurrentBoid, Leader, FleeDistance, D_BehindLeader);
        force = leader_following_force + 2*collision_avoidance_force;
        
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
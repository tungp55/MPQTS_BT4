function Behaviour__Pursue ()
%% global variables
global TimeSteps;
global BoidsNum;
global TargetsNum;
global FleeDistance;
global Boids;
global Targets;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();
[v_Image_r,v_Alpha_r,TargetsPlot] = InitializeTargetBird();

MousePosition = [0 0 0];
title('Implementation of Persue Behavior');
SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',10, 'MarkerFaceColor','r','Color','r');
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        MousePosition = cursorPosition;
        %Delete the old Target and Redraw a new Target
        delete(SaveMousePosition);
        %Draw Circle - Targer
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',10,'MarkerFaceColor','r','Color','r');
    end

%% calculate agents' positions to move to each iteration
setappdata(0, 'OldTarget', Targets(1, 1:3));
timeTick = 1;
while (timeTick < TimeSteps)
    %% Moving Targets
    for TargetIndex = 1:TargetsNum
        Targets = updateAtBoundary(Targets, TargetIndex);
        CurrentTarget = Targets(TargetIndex, :);
        Seekforce = steer_seek(CurrentTarget, MousePosition); %Move toward the mouse
        
        Fleeforce = [0,0,0];
        for BoidIndex = 1:BoidsNum
            FleeTarget(1, 1:3) = Boids(BoidIndex, 1:3);
            Fleeforce = Fleeforce + steer_flee(CurrentTarget, FleeTarget, FleeDistance);
        end
        force = Seekforce + Fleeforce;
        Targets(TargetIndex,:) = applyForce(CurrentTarget, force);
    end
    RedrawGraphics(Targets,TargetsNum,v_Image_r,v_Alpha_r,TargetsPlot);
    %End of Moving Target
    
    %% Moving Boids
    for BoidIndex = 1:BoidsNum
        Target = Targets(1, 1:6);                               
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
        %force = steer_pursue(CurrentBoid, Target, target_velocity);
        force = steer_pursue(CurrentBoid, Target);
        
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    % End of Moving Boids
    
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('PursueBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
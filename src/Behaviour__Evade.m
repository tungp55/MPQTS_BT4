function Behaviour__Evade ()
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
title('Implementation of Evade Behavior');
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
        Targets(TargetIndex,:) = applyForce(CurrentTarget, Seekforce);
    end
    RedrawGraphics(Targets,TargetsNum,v_Image_r,v_Alpha_r,TargetsPlot);
    %End of Moving Target
    
    %% Moving Boids
    for BoidIndex = 1:BoidsNum
        Target = Targets(1, 1:3);
        target_velocity = Targets(1, 4:6);
        OldTarget = getappdata(0,'OldTarget');     
        setappdata(0, 'OldTarget', Target);
       
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
        force = steer_evade(CurrentBoid, Target, target_velocity, FleeDistance);        
        %if (any(force))
            Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
        %end
    end
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    % End of Moving Boids
    
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('EvadeBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
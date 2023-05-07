function Behaviour__Flee ()
%% global variables
global TimeSteps;
global FleeDistance;
global BoidsNum;
global Boids;
%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

%% target is optional, if target is undefined,
% then get mouse position on move cursor as target
Target = [0 0 0];
titleStr = 'Implementation of Flee Behavior';
titleStr = [titleStr newline '(Use mouse to create a new target)'];
title(titleStr);
SaveTarget = plot(Target(1), Target(2), 'o','MarkerSize',10, 'MarkerFaceColor','r','Color','r');
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        Target = cursorPosition;
        %Delete the old Target and Redraw a new Target
        delete(SaveTarget);
        %Draw Circle - Targer
        SaveTarget = plot(Target(1), Target(2), 'o','MarkerSize',10,'MarkerFaceColor','r','Color','r');
    end

%% calculate agents' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum
        Boids = updateAtBoundary(Boids,BoidIndex);
        % steering               
        CurrentBoid = Boids(BoidIndex, :);
        force = steer_flee(CurrentBoid, Target, FleeDistance);
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    M(timeTick)=getframe;
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('FleeBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
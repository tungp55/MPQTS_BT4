function Behaviour__Seek_Separation (MousePosition)
%% global variables
global TimeSteps;
global Boids;
global BoidsNum;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

MousePosition = [0 0 0];
titleStr = 'Combination of Seek and Separation Behaviors';
titleStr = [titleStr newline '(Use mouse to create a new target)'];
title(titleStr);
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
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum                                       
        Boids = updateAtBoundary(Boids,BoidIndex);
        %Steering Force
        CurrentBoid = Boids(BoidIndex, :);
        seek_force = steer_seek(CurrentBoid, MousePosition);
        separation_force = steer_separation(CurrentBoid);
        force = seek_force + separation_force;
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
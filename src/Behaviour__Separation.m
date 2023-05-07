function Behaviour__Separation ()
%% global variables
global TimeSteps;
global Boids;
global BoidsNum;

% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

MousePosition = [0 0 0];
title('Implementation of Separation Behavior');
%SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',10, 'MarkerFaceColor','r','Color','r');
%set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);

%% calculate boids' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)   
    for BoidIndex = 1:BoidsNum
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);        
        force = steer_separation(CurrentBoid);                
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
     % End of Moving Boids
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('Separation.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
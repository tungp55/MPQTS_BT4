function Behaviour__Wander ()
%% global variables
global TimeSteps;
global BoidsNum;
global Boids;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

title('Implementation of Wander Behavior');
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum
        % steering
        Boids = updateAtBoundary(Boids,BoidIndex);
        
        CurrentBoid = Boids(BoidIndex, :);
        force = steer_wander(CurrentBoid);
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);                
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
function Behaviour__Cohesion()
%% global variables
global TimeSteps;
global Boids;
global BoidsNum;

% first draw
[v_Image,v_Alpha,BoidsPlot,~] = InitializeGraphics();
title('Implementation of Cohesion Behavior');

%% calculate agents' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
        force = steer_cohesion(CurrentBoid);           
        force = force + steer_separation(CurrentBoid);           
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);      
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
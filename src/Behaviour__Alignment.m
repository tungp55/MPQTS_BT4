function Behaviour__Alignment ()
%% global variables
global TimeSteps;
global Boids;
global BoidsNum;

% first draw
[v_Image,v_Alpha,BoidsPlot,~] = InitializeGraphics();
title('Implementation of Alignment Behavior');
%% calculate boids' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum                    
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);
        force = steer_alignment(CurrentBoid);       
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);        
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
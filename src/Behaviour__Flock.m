function Behaviour__Flock ()
%% global variables
global TimeSteps;
global Boids;
global BoidsNum;

%% first draw
[v_Image,v_Alpha,BoidsPlot,~] = InitializeGraphics();
title('Implementation of Flocking Behavior');
%% calculate agents' positions to move to each iteration
timeTick = 1;
while (timeTick < TimeSteps)
    for BoidIndex = 1:BoidsNum                       
        Boids = updateAtBoundary(Boids,BoidIndex);
        CurrentBoid = Boids(BoidIndex, :);     
        
        cohesion_force = steer_cohesion(CurrentBoid);
        seperation_force = steer_separation(CurrentBoid);
        alignment_force = steer_alignment(CurrentBoid);        
        force = seperation_force*4 + alignment_force + cohesion_force ;
        
        Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
    end
    % redraw
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
end
end
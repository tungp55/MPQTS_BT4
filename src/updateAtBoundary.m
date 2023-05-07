function Boids = updateAtBoundary(Boids, BoidIndex)
global EnvironmentWidth
global SpeedCorrection

if Boids(BoidIndex,1) < 0
    Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    if  Boids(BoidIndex,5) > 0
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    else
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    end
end
if Boids(BoidIndex,1)  > EnvironmentWidth
    Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    if  Boids(BoidIndex,5) > 0
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    else
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    end
end
if Boids(BoidIndex,2) < 0
    Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    if  Boids(BoidIndex,4) > 0
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    else
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    end
end
if Boids(BoidIndex,2)  > EnvironmentWidth
    Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    if  Boids(BoidIndex,4) > 0
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    else
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    end
end
end
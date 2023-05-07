function Boids = updateAtAreaBoundary(Boids, BoidIndex, xA, xB,yA, yB)
global SpeedCorrection

if Boids(BoidIndex,1) < xA
    Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    if  Boids(BoidIndex,5) > 0
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    else
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    end
end
if Boids(BoidIndex,1)  > xB
    Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    if  Boids(BoidIndex,5) > 0
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    else
        Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    end
end
if Boids(BoidIndex,2) < yA
    Boids(BoidIndex,5)  = Boids(BoidIndex,5) + SpeedCorrection;
    if  Boids(BoidIndex,4) > 0
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    else
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    end
end
if Boids(BoidIndex,2)  > yB
    Boids(BoidIndex,5)  = Boids(BoidIndex,5) - SpeedCorrection;
    if  Boids(BoidIndex,4) > 0
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) + SpeedCorrection;
    else
        Boids(BoidIndex,4)  = Boids(BoidIndex,4) - SpeedCorrection;
    end
end
end
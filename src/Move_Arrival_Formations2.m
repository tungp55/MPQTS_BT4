% Merge boid to the left or right branch, if isRight = 1, so Boid will
% come to the Right of Leader
function [CurrentBoid, Boids] = Move_Arrival_Formations2(Target, Weight, Boids, CurrentBoid, Leader, AfterLeader, BoidIndex)
global FleeDistance;
p_following = AfterLeader;
% If the character is on the leader's sight, add a force
% to evade the route immediately.
if (isOnLeaderSight(CurrentBoid, Leader))
    evade_force = 0.002*steer_evade(CurrentBoid, Leader(1:3), Leader(4:6), FleeDistance);
else
    evade_force = [0,0,0];  
end
evade_force = [0,0,0];
avd_force = 0.001 * steer_collision_avoidance(CurrentBoid); 
force = 3.0 * steer_arrival(CurrentBoid, Target);

% kiem tra gap vat can
    if check_reach_obstacles(CurrentBoid) == 1
        pursue_force = [0,0,0];
        avd_force = 0.001 * steer_collision_avoidance(CurrentBoid); 
        force = 0.5 * steer_arrival(CurrentBoid, Target);
    else
        pursue_force = 2*steer_pursue_arrival(CurrentBoid, p_following);
    end



force = force + pursue_force + avd_force;
%force = steer_pursue_arrival(CurrentBoid, p_following);
if (any(evade_force))
    force = force + evade_force;
end
% Separation force to collide avoidance
separation_force = steer_separation(CurrentBoid);
if (any(separation_force))
    force = force + separation_force;
end

%Assign weights to the Boids
force = force*Weight;
Boids(BoidIndex,:) = applyForce(CurrentBoid, force);
Boids = updateAtBoundary(Boids,BoidIndex);
end
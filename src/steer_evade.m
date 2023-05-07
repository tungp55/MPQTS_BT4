function steer = steer_evade(boid, Target, Target_Velocity, fleeDistance)
v_pos = boid(1:3);
v_maxspeed = boid(10);


desired = Target(1:3) - v_pos;

%Calculate the T_Prediction to predict the future position of target
T = mag(desired)/v_maxspeed;
futurePosition = Target(1:3) + Target_Velocity*T;
steer = steer_flee(boid, futurePosition, fleeDistance);
end
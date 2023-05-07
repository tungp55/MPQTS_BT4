function steer = steer_pursue_arrival(boid, Target)
v_pos = boid(1:3);
v_maxspeed = boid(10);
Target_Velocity = Target(4:6);
desired = Target(1:3) - v_pos;
%Calculate the T_Prediction to predict a future position
T = mag(desired)/v_maxspeed;
futurePosition = Target(1:3) + Target_Velocity*T;
steer = steer_arrival(boid, futurePosition);
end
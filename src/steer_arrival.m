function steer = steer_arrival(boid, Target)
v_pos = boid(1:3);
v_vel = boid(4:6);
v_maxspeed = boid(10);
v_maxforce = boid(11);

desired = Target(1:3) - v_pos;

d = mag(desired);
slowingRadius = 300;

desired = setMag(desired, v_maxspeed); % set magnitude
if (d < slowingRadius)
    desired = desired * (d / slowingRadius);
end

steer = desired - v_vel;
steer = setLimit(steer, v_maxforce); % set limit steer force

end
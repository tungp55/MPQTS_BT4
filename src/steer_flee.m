function steer = steer_flee(boid, Target, fleeDistance)
v_pos = boid(1:3);
v_vel = boid(4:6);
v_maxspeed = boid(10);
v_maxforce = boid(11);

steer = [0 0 0];

d = dist(v_pos, Target(1:3));
if (d <= fleeDistance) % only avoid the target if it's near
    desired = Target(1:3) - v_pos;
    desired = setMag(desired, v_maxspeed); % set magnitude
    
    steer = desired - v_vel;
    steer = -setLimit(steer, v_maxforce); % set limit steer force
end
end
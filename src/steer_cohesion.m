function steer = steer_cohesion(Boid,Boids,BoidsNum)
global CohesionRange;

v_pos = Boid(1:3);
v_vel = Boid(4:6);
v_maxspeed = Boid(10);
v_maxforce = Boid(11);

steer = [0 0 0];

desired = [0 0 0];
count = 0;
for vhl_o = 1:BoidsNum
    vhl_o_pos = Boids(vhl_o,1:3);
   
    d = dist(v_pos, vhl_o_pos);
    if ((d > 0) && (d < CohesionRange))
        desired = desired + vhl_o_pos;
        count = count+1;
    end
end

if (count > 0)
    desired = desired/count;
    desired = desired - v_pos;
    
    %steer = steer_seek(Boid, desired);            
    desired = setMag(desired, v_maxspeed); % set magnitude    
    steer = desired - v_vel;   
    steer = setLimit(steer, v_maxforce/4); % set limit steer force         
end
end
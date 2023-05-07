function steer = steer_alignment(Boid,Boids,BoidsNum)
global AlignmentRange;

v_pos = Boid(1:3);
v_vel = Boid(4:6);
v_maxspeed = Boid(10);
v_maxforce = Boid(11);

steer = [0 0 0];

desired = [0 0 0];
count = 0;
for vhl_o=1:BoidsNum
    vhl_o_pos = Boids(vhl_o,1:3);
    vhl_o_vel = Boids(vhl_o,4:6);
    d = dist(v_pos, vhl_o_pos);
    if ((d > 0) && (d < AlignmentRange))
        desired = desired + vhl_o_vel;
        count = count+1;
    end
end

if (count > 0)
    desired = desired/count;
    desired = setMag(desired, 2);    
    steer = desired - v_vel;
    steer = setLimit(steer, v_maxforce);
end

end
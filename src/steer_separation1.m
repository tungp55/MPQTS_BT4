function steer = steer_separation(Boid,Boids,BoidsNum)
global SafeDistance;
global TargetZ;
v_pos = Boid(1:3);
v_vel = Boid(4:6);
v_maxspeed = Boid(10);
v_maxforce = Boid(11);

desired = [0 0 0];
count = 0;

%BoidsNumZ=BoidsNum+1;

%Boids(BoidsNumZ,:)=TargetZ;
for vhl_o = 1:BoidsNum
    % check in range of safe distance
    vhl_o_pos = Boids(vhl_o,1:3);    
    d = dist(v_pos, vhl_o_pos);
    %if (vhl_o<BoidsNum)
        safe=SafeDistance;
%     else
%         safe=55;
%     end
    if (d > 0 && d < safe)
        diff = vhl_o_pos - v_pos;
        diff = normalize(diff);        
        desired = desired + diff;
        count = count + 1;
    end
end

steer = [0 0 0];

if count > 0      
    desired = -desired;   
    desired = setMag(desired, v_maxspeed); % set magnitude    
    steer = desired - v_vel;
    MaxSeparationForce = v_maxforce*3; % Increase the SeparationForce
    steer = setLimit(steer, MaxSeparationForce); % set limit steer force        
end
end
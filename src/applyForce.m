function boid = applyForce(boid, steer)
  %add steer force to acceleration
  v_pos = boid(1:3);
  v_vel = boid(4:6);
  v_acc = boid(7:9);
  v_maxspeed = boid(10);
 
  
  v_acc = v_acc + steer;
  v_vel = v_vel + v_acc;
  v_vel = setLimit(v_vel, v_maxspeed);
  v_pos = v_pos + v_vel;
  

  v_angle = (asin(abs(v_vel(1) / (0.01 + norm([v_vel(1),v_vel(2)])))) * 180 / pi) - 180;
  if v_vel(1) >= 0
    if v_vel(2) <= 0
      v_angle = -v_angle;
    else
      v_angle = 180 + v_angle;
    end
  else 
    if v_vel(2) > 0
      v_angle = 180 - v_angle;
    end
  end  
    
  % reset acceleration
  v_acc = [0 0 0];
  
  boid(4:6) = v_vel;
  boid(1:3) = v_pos;
  boid(7:9) = v_acc;
  boid(12) = v_angle;  
end
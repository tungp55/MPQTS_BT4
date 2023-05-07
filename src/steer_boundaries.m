function steer = steer_boundaries(boids, vhl)
  global boundaryWidth;

  v_pos = boids(vhl,1:3);
  v_vel = boids(vhl,4:6);
  v_acc = boids(vhl,7:9);
  v_maxspeed = boids(vhl,10);
  v_maxforce = boids(vhl,11);
  
  desired = [0 0 0];
  steer = [0 0 0];
  
  w = boundaryWidth;
  h = boundaryWidth;
  
%{  
  if (abs(v_pos(1)) < w && abs(v_pos(2)) < h)
    desired = [v_maxspeed v_maxspeed v_pos(3)];
  end
%}
  if (v_pos(1) >= w)
    if (v_pos(2) >= h)
      desired = [-v_maxspeed -v_maxspeed v_pos(3)];
    elseif (v_pos(2) <= -h)
      desired = [-v_maxspeed v_maxspeed v_pos(3)];
    else
      desired = [-v_maxspeed v_pos(2) v_pos(3)];
    end
  elseif (v_pos(1) <= -w)
    if (v_pos(2) >= h)
      desired = [v_maxspeed -v_maxspeed v_pos(3)];
    elseif (v_pos(2) <= -h)
      desired = [v_maxspeed v_maxspeed v_pos(3)];
    else
      desired = [v_maxspeed -v_pos(2) v_pos(3)];
    end
  else 
    if (v_pos(2) >= h)
      desired = [v_pos(1) -v_maxspeed v_pos(3)];
    elseif (v_pos(2) <= -h)
      desired = [v_pos(1) v_maxspeed v_pos(3)];
    end
  end


  %if (any(desired))  % if desired not 0-matrix
    desired = normalize(desired);
    desired = desired*v_maxspeed;
    
    steer = desired - v_vel;
    steer = setLimit(desired, v_maxforce);
  %end
  
end
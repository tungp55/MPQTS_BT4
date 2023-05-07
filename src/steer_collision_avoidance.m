function steer = steer_collision_avoidance(Boid, vhl, obstacles, obstaclesNum)
  v_pos = Boid(vhl,1:3);
  v_vel = Boid(vhl,4:6);
  v_acc = Boid(vhl,7:9);
  v_maxspeed = Boid(vhl,10);
  v_maxforce = Boid(vhl,11);
  v_max_see_ahead = Boid(vhl,13);
  v_max_avoid_force = Boid(vhl,14);

  
  function [fake_closest, closest] = closest_point_on_seg(seg_a, seg_v, circ_pos)
    ac_v = circ_pos - seg_a;
    ahead_v_unit = seg_v/norm(seg_v);
    proj = dot(ac_v,ahead_v_unit);
    proj_v = ahead_v_unit*proj;
    closest = proj_v + v_pos;
    if proj <= 0
        fake_closest = seg_a;
    elseif proj >= norm(seg_v)
        fake_closest = seg_v + v_pos;
    else
        fake_closest = closest;
    end
  end
  
  function checkIntersect = LineIntersectsCircle(dist_v, obstacle) 
  % obstacle
  % 1-3: center
  % 7: radius
%     disp('dist_v');
%     disp(dist_v);
%     disp(norm(dist_v));
    if (norm(dist_v) <= obstacle(4))
        checkIntersect = 1;
    else 
        checkIntersect = 0;
    end
  end

  function [mostThreatenObstacle, mostCloset, mostDistV] = findMostThreateningObstacle()
    mostThreatenObstacle = [0 0 0];
    mostCloset = [0 0 0];
    mostDistV = [0 0 0];
 
    for i = 1:obstaclesNum
        obstacle = obstacles(i,:); % obstacles row ith
        [fake_closest, closest] = closest_point_on_seg(v_pos, ahead_v, obstacle(1:3)); 
        dist_v = fake_closest - obstacle(1:3);
        collision = LineIntersectsCircle(dist_v, obstacle);
           
        if (collision == 1 && (~any(mostThreatenObstacle) || dist(v_pos, obstacle(1:3)) < dist(v_pos, mostThreatenObstacle(1:3))) )
            mostThreatenObstacle = obstacle;
            mostCloset = closest;
            mostDistV = dist_v;
        end
    end
  end
    


  ahead_v = normalize(v_vel) * v_max_see_ahead;
  [mostThreatening, closest, dist_v] = findMostThreateningObstacle();
%   disp('mostThreatening');
%   disp(mostThreatening);

  %ahead2 = v_pos + normalize(v_vel) * v_max_see_ahead * 0.5;
  

  avoidance = [0 0 0];
 
  %if (mostThreatening != null) 
  if (any(mostThreatening))  % if mostThreatening not 0-matrix
%     disp('avoid');
    dist_v = closest - mostThreatening(1:3);
    overlap = (mostThreatening(4)-norm(dist_v)) * (dist_v/norm(dist_v)) ;
%     overlap = (mostThreatening(4)-norm(dist_v)) * (dist_v/norm(dist_v)) ;
    avoidance(1) = 1*overlap(1); %0.0000354
    avoidance(2) = 1*overlap(2);
%     disp('avoidance');
%     disp(avoidance);
    avoidance = setLimit(avoidance, v_max_avoid_force); % set limit steer force

    %avoidance = setMag(avoidance, v_max_avoid_force);
  else 
    avoidance = setMag(avoidance, 0);
  end
  
  steer = avoidance;
  
end
function steer = steer_wander(boid)
  global wanderAngle;  
  v_vel = boid(4:6);

  CIRCLE_DISTANCE = 3;
  CIRCLE_RADIUS = 1;
  ANGLE_CHANGE = 0.3;
  
  circleCenter = setMag(v_vel, CIRCLE_DISTANCE);

  displacement = [0 1 0];
  %displacement = displacement*CIRCLE_RADIUS;
  displacement = setLimit(displacement, CIRCLE_RADIUS);
  %
  % Randomly change the vector direction
  % by making it change its current angle
  function vector = setAngle(vector, value) 
    len = mag(vector);
    vector(1) = cos(value) * len;
    vector(2) = sin(value) * len;
  end
  displacement = setAngle(displacement, wanderAngle);
  %
  % Change wanderAngle just a bit, so it
  % won't have the same value in the
  % next game frame.
  wanderAngle = wanderAngle + (rand() * ANGLE_CHANGE) - (ANGLE_CHANGE * .5);
  steer = circleCenter + displacement;  
end
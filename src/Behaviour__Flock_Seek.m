function Behaviour__Flock_Seek (boids,vNum,target)
  %% global variables
  global TimeSteps;

  %% first draw
  [v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics(boids,vNum);

  %% target is optional, if target is undefined, 
   % then get mouse position on move cursor as target
  if ~exist('target','var')
    target = [0 0 0];
    set(fHandler, 'WindowButtonMotionFcn',@cursorMoveCallback);
  end
  function cursorPosition = cursorMoveCallback(o,e)
    p = get(gca,'CurrentPoint');
    cursorPosition(1:2) = p(1,1:2);
    cursorPosition(3) = 0;
    title( sprintf('(%g,%g)',cursorPosition) );
    setappdata(0,'cursorPosition',cursorPosition)  % save cursorPosition
  end

  %% calculate vehicles' positions to move to each iteration
  timeTick = 1;
  while (timeTick < TimeSteps)
    for vhl = 1:vNum
      target = getappdata(0,'cursorPosition'); % get cursorPosition.
      % steering
      seek_force = steer_seek(boids, vhl, target);
      boundaries_force = steer_boundaries(boids, vhl);
      seperation_force = steer_seperation(boids, vhl, vNum);
      alignment_force = steer_alignment(boids, vhl, vNum);
      cohesion_force = steer_cohesion(boids, vhl, vNum);
      % total force
      force = seek_force + seperation_force*1.5 + alignment_force*2 + cohesion_force*1 + boundaries_force;
      % apply force (calculate new position)
      boids = applyForce(boids, vhl, force);
    end
    % redraw
    RedrawGraphics(boids,vNum,v_Image,v_Alpha,BoidsPlot);
    timeTick = timeTick+1;
  end
end
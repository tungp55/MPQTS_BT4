function Behavior__Pursue_Formation_J
global TimeSteps;
global BoidsNum;
global Boids;
global Targets;
global SaveMousePosition;
global saveText;
global ImageWidth;
global FleeDistance;
% Number of boids on the top of J-formation
global NumberBoidsOnTop;
% Number of boids on the the branch of J-formation
global NumberBoidsOnBranch;
global NumberBoidsOnLeftBranch;
Wingspan = ImageWidth;
% Number of boids on the top of J-formation
NumberBoidsOnTop = 3;
% Number of boids on the branch of J-formation
NumberBoidsOnBranch = 1;
% Number of boids on the left branch of J-formation
NumberBoidsOnLeftBranch = 3;
% Angle at top of J-formation
Alpha_J_Formation= 8*pi/9;
% Distance beside leader in the J-formation
D_Beside = Wingspan*(4 + pi)/8 + 20;
% Distance behind leader in the J-formation
D_Behind = Wingspan*(4 + pi)/(8*tan(Alpha_J_Formation/2)) + 30;

%% first draw
[v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

%Initialize the first positon of Goal
MousePosition = [250 300 0 0 0 0];
SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
titleStr = 'Implementation of J-Formation and Flee behavior';
titleStr = [titleStr newline '(Use mouse click to create a new goal)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);
%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3:6) = 0;
        MousePosition = cursorPosition;
        %Delete the old Target and Redraw a new Target
        delete(SaveMousePosition);
        %Draw Circle - Targer
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
        delete(saveText);
        saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
    end

%% calculate agents' positions to move to each iteration
setappdata(0, 'OldTarget', Targets(1, 1:3));

%% INITIALIZE J-FORMATION FOR FLOCK
Boids(1,1:3) = [-100 50 0];
Boids(1,:) = applyForce(Boids(1,:), 0);
Leader = Boids(1, :);

% Calculate the horizontal angle of the Leader
Alpha_Horizontal = CalculationHorizontalAngle(Leader);      

%Find the RightBeside and LeftBeside positions of Leader
[RightBesidePosition, LeftBesidePosition] = FindBesideLeader(Leader, ...
                                    Alpha_Horizontal, D_Behind, D_Beside + 10);

% Assign 2-nd Boid to the right of 1-st Boid
Boids(2, 1:6) = RightBesidePosition;
Boids(2,:) = applyForce(Boids(2,:), 0);
RightBesidePosition = Boids(2, :);

% Assign 3-rd boid to the left of of 1-st Boid
Boids(3, 1:6) = LeftBesidePosition;
Boids(3,:) = applyForce(Boids(3,:), 0);
LeftBesidePosition = Boids(3, :);

BoidIndex = 4;
while BoidIndex <= BoidsNum            
    %Find the RightBeside position of RightBesidePosition (2-nd Boid)
    [RightBesidePosition, ~] = FindBesideLeader(RightBesidePosition, ...
                                    Alpha_Horizontal, D_Behind + 20, D_Beside + 30);
    Boids(BoidIndex, 1:6) = RightBesidePosition;
    RightBesidePosition = Boids(BoidIndex,:);
    Boids(BoidIndex,:) = applyForce(Boids(BoidIndex,:), 0);
    
    if (BoidIndex < NumberBoidsOnLeftBranch + NumberBoidsOnTop + 2*NumberBoidsOnBranch)        
        BoidIndex = BoidIndex + 1;
        [~, LeftBesidePosition] = FindBesideLeader(LeftBesidePosition, ...
            Alpha_Horizontal, D_Behind + 20, D_Beside - 50);
        Boids(BoidIndex, 1:6) = LeftBesidePosition;
        LeftBesidePosition = Boids(BoidIndex,:);
        Boids(BoidIndex,:) = applyForce(Boids(BoidIndex,:), 0);
    end
    BoidIndex = BoidIndex + 1;
end
RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);

%% FLOCK MOVE TO THE GOAL
% Generate random colors for drawing the footprints of boids
for BoidIndex = 1:BoidsNum
    randomColors(BoidIndex,1:3) = rand(1,3);
end

timeTick = 1;
while (timeTick < TimeSteps)
    %% Moving the 1-st Boid (as a leader)
   force = steer_pursue(Boids(1,:), MousePosition);
    Boids(1,:) = applyForce(Boids(1,:), force);
    
    %% Moving Boids
    Leader = Boids(1, :);      
    Alpha_Horizontal = CalculationHorizontalAngle(Leader);        
    [Boids, BoidsIndex] = steer_Pursue_Formation_J(MousePosition, Boids, Leader, ...
                                    D_Behind,D_Beside, Alpha_Horizontal, ...
                                    NumberBoidsOnTop, NumberBoidsOnBranch, NumberBoidsOnLeftBranch);    
    % Draw the footprint and lines of J-formation every 60 steps
    if (timeTick == 1 || mod(timeTick,100) == 0)
        for BoidIndex = 1:BoidsNum
            %Draw footprints of Boids
            plot(Boids(BoidIndex, 1), Boids(BoidIndex, 2), 'o', 'MarkerSize', ...
                3,'MarkerFaceColor',randomColors(BoidIndex, 1:3),'Color',...
                randomColors(BoidIndex, 1:3));
        end
        %Draw lines of J-formation
        line([Boids(BoidsIndex(1),1), Boids(BoidsIndex(2),1)],[Boids(BoidsIndex(1),2), Boids(BoidsIndex(2),2)],'Color','red','LineStyle','-')
        for BoidIndex = 1:BoidsNum-1
            if (BoidIndex < NumberBoidsOnLeftBranch + NumberBoidsOnTop + 2*NumberBoidsOnBranch - 1)
                line([Boids(BoidsIndex(BoidIndex),1), Boids(BoidsIndex(BoidIndex + 2),1)],...
                    [Boids(BoidsIndex(BoidIndex),2), Boids(BoidsIndex(BoidIndex + 2),2)],'Color','red','LineStyle','-');
            else
                if (BoidIndex > NumberBoidsOnLeftBranch + NumberBoidsOnTop + 2*NumberBoidsOnBranch - 1)
                    line([Boids(BoidsIndex(BoidIndex),1), Boids(BoidsIndex(BoidIndex + 1),1)],...
                        [Boids(BoidsIndex(BoidIndex),2), Boids(BoidsIndex(BoidIndex + 1),2)],'Color','red','LineStyle','-');
                end
            end
        end
    end    
    RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);    
    % End of Moving Boids
    M(timeTick)=getframe; %For recording Video
    timeTick = timeTick+1;
end
%% Record video
MyMovie = VideoWriter('J-Formation_PursueBehavior.avi');
open(MyMovie);
writeVideo(MyMovie,M);
close(MyMovie);
end
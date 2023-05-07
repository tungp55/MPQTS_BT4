% function Behavior__Seek_Formation_U()
% %% global variables
% global TimeSteps;
% global ArmyBluesNum;
% global ArmyBlues;
% global Targets;
% global SaveMousePosition;
% global saveText;
% global ImageWidth;
% % Number of ArmyBlues on the top of U-formation
% global NumberBoidsOnTop;
% % Number of ArmyBlues on the the branch of U-formation
% global NumberBoidsOnBranch;
% Wingspan = ImageWidth;
% % Number of ArmyBlues on the top of U-formation
% NumberBoidsOnTop = 3;
% % Number of ArmyBlues on the the branch of U-formation
% NumberBoidsOnBranch = 1;
% % Angle at top of U-formation
% Alpha_U_Formation = 9*pi/9;
% % Distance beside leader in the U-formation
% D_Beside = Wingspan*(4 + pi)/8 + 30;
% % Distance behind leader in the U-formation
% D_Behind = Wingspan*(4 + pi)/(8*tan(Alpha_U_Formation/2)) + 10;
% 
% %% first draw
% % [v_ImageB,v_AlphaB,BluesPlot,fHandler] = InitializeGraphics();
% % [v_ImageB,v_AlphaB,BluesPlot] = InitializeArmyBlue()
% %Initialize the first positon of Goal
% MousePosition = [700 700 0 0 0 0];
% % SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
% % saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
% % titleStr = 'Implementation of U-Formation and Goal seeking behavior';
% % titleStr = [titleStr newline '(Use mouse click to create a new goal)'];
% % title(titleStr);
% % set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);
% % 
% % %Event Mouse click
% %     function cursorPosition = cursorClickCallback(o,e)
% %         p = get(gca,'CurrentPoint');
% %         cursorPosition(1:2) = p(1,1:2);
% %         cursorPosition(3:6) = 0;
% %         MousePosition = cursorPosition;
% %         %Delete the old Target and Redraw a new Target
% %         delete(SaveMousePosition);
% %         %Draw Circle - Targer
% %         SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',5,'MarkerFaceColor','blue','Color','blue');
% %         delete(saveText);
% %         saveText = text(MousePosition(1) + 30, MousePosition(2)+ 10, 'Goal');
% %     end
% 
% %% calculate agents' positions to move to each iteration
% setappdata(0, 'OldTarget', Targets(1, 1:3));
% 
% %% INITIALIZE U-FORMATION FOR FLOCK
% % ArmyBlues(1,1:3) = [200 600 0];
% % ArmyBlues(1,:) = applyForce(ArmyBlues(1,:), 0);
% % Leader = ArmyBlues(1, :);
% 
% % Calculate the horizontal angle of the Leader
% Alpha_Horizontal = CalculationHorizontalAngle(Leader);
% 
% %Find the RightBeside and LeftBeside positions of Leader
% [RightBesidePosition, LeftBesidePosition] = FindBesideLeader(Leader, ...
%                                     Alpha_Horizontal, D_Behind, D_Beside);
% 
% % Assign 2-nd Boid to the right of 1-st Boid
% ArmyBlues(2, 1:6) = RightBesidePosition;
% ArmyBlues(2,:) = applyForce(ArmyBlues(2,:), 0);
% RightBesidePosition = ArmyBlues(2, :);
% 
% % Assign 3-rd boid to the left of of 1-st Boid
% ArmyBlues(3, 1:6) = LeftBesidePosition;
% ArmyBlues(3,:) = applyForce(ArmyBlues(3,:), 0);
% LeftBesidePosition = ArmyBlues(3, :);
% 
% BlueIndex = 4;
% while BlueIndex <= ArmyBluesNum
%     D_Beside_tmp = D_Beside;
%     D_Behind_tmp = D_Behind;
%     if ((BlueIndex > NumberBoidsOnTop) && (BlueIndex <= NumberBoidsOnTop + 2*NumberBoidsOnBranch))
%         D_Behind_tmp = D_Behind + 30;
%         D_Beside_tmp = D_Beside_tmp - 10;
%     else
%         if (BlueIndex >= NumberBoidsOnTop + 2*NumberBoidsOnBranch)
%             D_Beside_tmp = 0;
%             D_Behind_tmp = D_Behind + 50;
%         end
%     end
%      
%     %Find the RightBeside position of RightBesidePosition (2-nd Boid)
%     [RightBesidePosition, ~] = FindBesideLeader(RightBesidePosition, ...
%                                     Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
%     ArmyBlues(BlueIndex, 1:6) = RightBesidePosition;
%     RightBesidePosition = ArmyBlues(BlueIndex,:);
%     ArmyBlues(BlueIndex,:) = applyForce(ArmyBlues(BlueIndex,:), 0);
%     
%     BlueIndex = BlueIndex + 1;
%     [~, LeftBesidePosition] = FindBesideLeader(LeftBesidePosition, ...
%                                     Alpha_Horizontal, D_Behind_tmp, D_Beside_tmp);
%     ArmyBlues(BlueIndex, 1:6) = LeftBesidePosition;
%     LeftBesidePosition = ArmyBlues(BlueIndex,:);
%     ArmyBlues(BlueIndex,:) = applyForce(ArmyBlues(BlueIndex,:), 0);
%     
%     BlueIndex = BlueIndex + 1;
% end
% RedrawGraphics(ArmyBlues,ArmyBluesNum,v_ImageB,v_AlphaB,BluesPlot);
% 
% %% FLOCK MOVE TO THE GOAL
% % Generate random colors for drawing the footprints of ArmyBlues
% % for BlueIndex = 1:ArmyBluesNum
% %     randomColors(BlueIndex,1:3) = rand(1,3);
% % end
% 
% timeTick = 1;
% while (timeTick < TimeSteps)
%     %% Moving the 1-st Boid (as a leader)
%     force = steer_seek(ArmyBlues(1,:), MousePosition); %Move toward the mouse
%     ArmyBlues(1,:) = applyForce(ArmyBlues(1,:), force);
%     
%     %% Moving ArmyBlues
%     Leader = ArmyBlues(1, :);      
%     Alpha_Horizontal = CalculationHorizontalAngle(Leader);        
%     [ArmyBlues, BoidsIndex] = steer_Seek_Formation_U(MousePosition, ArmyBlues, Leader, ...
%                                     D_Behind,D_Beside, Alpha_Horizontal, ...
%                                     NumberBoidsOnTop, NumberBoidsOnBranch);    
%     % Draw the footprint and lines of U-formation every 10 steps
% %     if (mod(timeTick,20) == 0)
% %         for BlueIndex = 1:ArmyBluesNum
% %             %Draw footprints of ArmyBlues
% %             plot(ArmyBlues(BlueIndex, 1), ArmyBlues(BlueIndex, 2), 'o', 'MarkerSize', ...
% %                 3,'MarkerFaceColor',randomColors(BlueIndex, 1:3),'Color',...
% %                 randomColors(BlueIndex, 1:3));
% %         end
% %         %Draw lines of U-formation
% %         line([ArmyBlues(BoidsIndex(1),1), ArmyBlues(BoidsIndex(2),1)],[ArmyBlues(BoidsIndex(1),2), ArmyBlues(BoidsIndex(2),2)],'Color','red','LineStyle','-')
% %         for BlueIndex = 1:ArmyBluesNum-2
% %             line([ArmyBlues(BoidsIndex(BlueIndex),1), ArmyBlues(BoidsIndex(BlueIndex + 2),1)],...
% %                  [ArmyBlues(BoidsIndex(BlueIndex),2), ArmyBlues(BoidsIndex(BlueIndex + 2),2)],'Color','red','LineStyle','-')
% %         end   
% %     end    
%     RedrawGraphics(ArmyBlues,ArmyBluesNum,v_ImageB,v_AlphaB,BluesPlot);    
%     % End of Moving ArmyBlues
%     M(timeTick)=getframe; %For recording Video
%     timeTick = timeTick+1;
% end
% %% Record video
% % MyMovie = VideoWriter('U-Formation_GoalSeeking.avi');
% % open(MyMovie);
% % writeVideo(MyMovie,M);
% % close(MyMovie);
% end
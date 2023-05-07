function Behaviour__SeekBlue()
global TimeSteps;
global Reds RedsNum MaxRedNum RedsHP DieRNum;
global Blues BluesNum MaxBlueNum BluesHP DieBNum;
global Fights FightsNum MaxFightNum ObstaclesF ;
global Booms BoomsNum Targets TargetsNum;
global SaveMousePosition;
global ImageWidth;
global ObstaclesB ObstaclesNumB;
global ObstaclesR ObstaclesNumR;
global Obstacles ObstaclesNum;
global ShootDistanceB ShootDistanceR;
global kB kR Target1 Target2;
global deviationXB deviationYB deviationXR deviationYR ;
global AccuracyB AccuracyR;
global goToAttack;
goToAttack = 0;
global makeInformation;
makeInformation = zeros(1,RedsNum);
global Counter;

%% first draw
% load image
[v_ImageR,v_AlphaR,v_ImageB,v_AlphaB,v_ImageE,v_AlphaE]=LoadImageBoids();
[v_ImageS1,v_AlphaS1,v_ImageS2,v_AlphaS2,v_ImageS3,v_AlphaS3,v_ImageS4,v_AlphaS4,v_ImageS5,v_AlphaS5,v_ImageS6,v_AlphaS6]=LoadImageOther1();
[v_ImageBB,v_AlphaBB,v_ImageBR,v_AlphaBR,v_ImageBF,v_AlphaBF,v_ImageF,v_AlphaF]=LoadImageBase();
[v_ImageBoom,v_AlphaBoom,v_ImageN,v_AlphaN,v_ImageEmpty,v_AlphaEmpty]=LoadImageBoom();
[v_ImageFR,v_AlphaFR,v_ImageFB,v_AlphaFB]=LoadImageFlag();
% draw graphic
[fHandler]=InitializeGraphicN();

% draw base

[BasesPlot]=InitializeBase(v_ImageBB,v_AlphaBB,v_ImageBR,v_AlphaBR,v_ImageBF,v_AlphaBF);
[BoomsPlot]=InitializeBoom(v_ImageBoom,v_AlphaBoom,v_ImageEmpty,v_AlphaEmpty,Booms,BoomsNum);
[FightsPlot]=InitializeFight(v_ImageF,v_AlphaF);

% draw obstacles
InitializeObstacles(v_ImageS1,v_AlphaS1,v_ImageS2,v_AlphaS2,v_ImageS3,v_AlphaS3,v_ImageS4,v_AlphaS4,v_ImageS5,v_AlphaS5,v_ImageS6,v_AlphaS6)

[RedsPlot]=InitializeBoid(v_ImageR,v_AlphaR,v_ImageE,v_AlphaE,RedsNum,Reds);
[RedsHP]=InitializeHP(RedsNum,MaxRedNum,Reds);

[BluesPlot]=InitializeBoid(v_ImageB,v_AlphaB,v_ImageE,v_AlphaE,BluesNum,Blues);
[BluesHP]=InitializeHP(BluesNum,MaxBlueNum,Blues);

%%load sound
[bomb,gun,fight,bombFs,gunFs,fightFs]=loadSound();


%%
    MousePosition = [0 0 0];
    titleStr = 'Mo phong ';
    titleStr = [titleStr newline '(Click de chon vi tri muon hanh quan den)'];
    title(titleStr);
    set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);
    kB=1;
    kR=1;

%% 
%Event Mouse click
    function cursorPosition = cursorClickCallback(o,e)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        MousePosition = cursorPosition;
        %Draw Circle - position  
        
        if( MousePosition(1:2) <0 )
            ObstaclesNumB = ObstaclesNumB + 1;
            ObstaclesB(ObstaclesNumB, 1:3) = zeros(1, 3);
            SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',6, 'MarkerFaceColor','blue','Color','blue');
            ObstaclesB(ObstaclesNumB, 1:3) = MousePosition(1:3);
            kB = ObstaclesNumB;
            
        elseif( MousePosition(1)>0) | ( MousePosition(2)>0)
            ObstaclesNumR = ObstaclesNumR + 1;
            ObstaclesR(ObstaclesNumR, 1:3) = zeros(1, 3);
            SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',6, 'MarkerFaceColor','red','Color','red');
            ObstaclesR(ObstaclesNumR, 1:3) = MousePosition(1:3);
            kR= ObstaclesNumR;
        end
    end

%% calculate agents' positions to move to each iteration
timeTick = 1;
% sound(fight,fightFs);
count=0;
%% 
while (timeTick < TimeSteps)
  
    %% set Target
    if( kB < BluesNum )
        for IndexB = ( kB +1) : ( BluesNum +1)
            ObstaclesB( IndexB ,(1:3)) = Target1(1:3);
        end
    end
    
    for BlueIndex = 1:BluesNum
        Blues = updateAtBoundary(Blues,BlueIndex);
        CurrentBoid = Blues(BlueIndex, :);
        force = steer_seek(CurrentBoid, ObstaclesB(BlueIndex + 1,1:3));
        if (dist(Blues(BlueIndex,1:3),ObstaclesB(BlueIndex + 1,1:3 )) > 10 )
         Blues(BlueIndex,:) = applyForce(CurrentBoid, force);
        end
    end
        %% Fight attack
     for FightIndex = 1:FightsNum
        %Fights = updateAtBoundary(Fights,FightIndex);
        CurrentBoid = Fights(FightIndex, :);
        force = 5* steer_seek(CurrentBoid, ObstaclesF(FightIndex ,1:3));
        Fights(FightIndex,:) = applyForce(CurrentBoid, force);
        if(dist(Fights(FightIndex,1:3),[0,0,0]) <200)
              count = count+2;
              if(count == 20)
                    [BombsPlot]=InitializeBomb2(v_ImageN,v_AlphaN,FightIndex);
                    pause(0.05);
                    sound(bomb,bombFs);
                    delete(BombsPlot); 
                    count=0;
              end
        end
     end
     
    %% set target Red 
        if( kR < RedsNum )
            for IndexR = ( kR +1) : ( RedsNum +1)
                ObstaclesR( IndexR ,(1:3)) = Target2(1:3);
            end
        end
    
%     for RedIndex = 1:RedsNum
%         Reds = updateAtBoundary(Reds,RedIndex);
%         CurrentBoid = Reds(RedIndex, :);
%         force = steer_seek(CurrentBoid, ObstaclesR(RedIndex + 1,1:3));
%         Reds(RedIndex,:) = applyForce(CurrentBoid, force);
%     end
    %% daviation Bule
    deviationXB = ShootDistanceB*(1-AccuracyB*(2*rand - 1));
    deviationYB = ShootDistanceB*(1-AccuracyB*(2*rand - 1));
    
    %% daviation Red
    deviationXR = ShootDistanceR*(1-AccuracyR*(2*rand - 1));
    deviationYR = ShootDistanceR*(1-AccuracyR*(2*rand - 1));
    %% Reds
    AttackBlue = zeros(1,BluesNum);    
    for i=1:RedsNum
        if (goToAttack == 0)
            Reds = updateAtBoundary(Reds,i);
            CurrentBoid = Reds(i, :);
            see_force = steer_seek(CurrentBoid, ObstaclesR(i + 1,1:3));
            flk_force=steer_flock(CurrentBoid,Reds,RedsNum);
            avd_force=steer_collision_avoidance(CurrentBoid,1,Obstacles, ObstaclesNum);
            force = see_force*1+flk_force*1+avd_force*0.07;
            if(Reds(i,15)>0)
                Reds(i,:) = applyForce(CurrentBoid, force);
                
                if (dist(Reds(i,1:3),ObstaclesR(i + 1,1:3)) < 10)
                   makeInformation(i) = 1; 
                end
                tempMatrix = ones(1,RedsNum);
                if (makeInformation == tempMatrix)
                   goToAttack = 1; 
                end
            else
                makeInformation(i)=1;
            end
           
        else
            if(Reds(i,15)>0)
                Reds = updateAtBoundary(Reds,i);
                CurrentBoid = Reds(i, :);
                [J,tmpDist]=findTarget(Reds(i,:),BluesNum,Blues);       
                if (J>0 && dist(Reds(i,:),Blues(J,:))<ShootDistanceB)
                    c1=line([Reds(i,1), Blues(J,1)],[Reds(i,2), Blues(J,2)],'Color','red','LineStyle','-.');
                    sound(gun,gunFs);
                    pause(0.02);
                    delete(c1);
                    if ( sqrt(deviationXR*deviationXR+deviationYR*deviationYR) < ImageWidth) 
                        AttackBlue(1,J)=AttackBlue(1,J)+40; 
                    end
                else
                    flk_force=steer_flock(CurrentBoid,Reds,RedsNum);
                    avd_force=steer_collision_avoidance(CurrentBoid,1,Obstacles, ObstaclesNum); 

                    if (J>0)
                        arr_force = steer_arrival(CurrentBoid, Blues(J,:));
                    else
                        arr_force = steer_arrival(CurrentBoid, Target1);
                    end
                    force=arr_force*1+flk_force*1+avd_force*0.07;
                    Reds(i,:) = applyForce(CurrentBoid, force); 

                end 
                
            end
            
        end                
    end
    
     %% Blues
    AttackRed=zeros(1,RedsNum);  
    for i=1:BluesNum
        if(Blues(i,15)>0)
            Blues = updateAtBoundary(Blues,i);
            CurrentBoid = Blues(i,:);
            [J,tmpDist]=findTarget(Blues(i,:),RedsNum,Reds);  
            if (J>0 && dist(Blues(i,:),Reds(J,:))<ShootDistanceB)
                % Shoot
                c2=line([Reds(J,1), Blues(i,1)-2],[Reds(J,2), Blues(i,2)],'Color','blue','LineStyle','-.');
                pause(0.02);
                sound(gun,gunFs);
                delete(c2);
                if ( sqrt(deviationXB*deviationXB + deviationYB*deviationYB) < ImageWidth)
                     AttackRed(1,J)=AttackRed(1,J)+50;
               end
                 
            end
        end
    end        
 %% Boom

    for i=1:BoomsNum
        if(Booms(i,4)>0)
            [n]=findTargetBoom(Booms(i,:));
            if (n>0)
              for index = 1:n
                AttackRed(1,Targets(1,index))= AttackRed(1,Targets(1,index))+200;
              end
              Booms(i,4)=0;
              RedrawBoom(Booms,BoomsNum,v_ImageBoom,v_AlphaBoom,v_ImageEmpty,v_AlphaEmpty,BoomsPlot);
              [BombsPlot]=InitializeBomb(v_ImageN,v_AlphaN,i);
              pause(0.3);
              delete(BombsPlot);
            end
        end
    end
    %% 
    timeTick = timeTick+1;
    %% Update Blues
    [BluesNum,Blues] = UpdateBoid(AttackBlue,BluesNum,Blues);    
    %% Update Reds
    [RedsNum,Reds] = UpdateBoid(AttackRed,RedsNum,Reds);   
    
    %% redraw    
    RedrawFight(v_ImageF,v_AlphaF,FightsPlot);
    RedrawBoom(Booms,BoomsNum,v_ImageBoom,v_AlphaBoom,v_ImageEmpty,v_AlphaEmpty,BoomsPlot)
    RedrawBoid(Reds,RedsNum,v_ImageR,v_AlphaR,v_ImageE,v_AlphaE,RedsPlot);
    RedrawBoid(Blues,BluesNum,v_ImageB,v_AlphaB,v_ImageE,v_AlphaE,BluesPlot);
    RedrawRedsHP();
    RedrawBlueHP();

    %% Blue Win 
    for i = 1: RedsNum
        if ( Reds(i,15)<= 0 ) 
            DieRNum = DieRNum +1;
        end
    end   
    if ( DieRNum == RedsNum) 
        InitializeFlag (v_ImageFB,v_AlphaFB);
        break;
     else
       DieRNum =0;
     end
        
    %% Red Win 
   for i = 1: BluesNum
        if ( Blues(i,15)<= 0 ) 
            DieBNum = DieBNum +1;
        end
   end
   if ( DieBNum == BluesNum) 
       InitializeFlag (v_ImageFR,v_AlphaFR);
         break;
   else
       DieBNum =0;
   end 
        
end
end
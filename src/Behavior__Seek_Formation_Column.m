function Behavior__Seek_Formation_Column()
%% global variables
global TimeSteps;
global BoidsNum;
global Boids;
global GreenNum;
global Greens;
global Targets;
global SaveMousePosition SaveMousePosition1;
global saveText;
global kB kR kG;
global RedsHP BluesHP GreenHP DieGNum DieRNum DieBNum;
global ObstaclesB ObstaclesNumB;
global ObstaclesG ObstaclesNumG;
global ObstaclesR ObstaclesNumR;
%%
global AccuracyB AccuracyR AccuracyG  ...
    ShootDistanceB ShootDistanceR ShootDistanceG ;
global goToAttack;
goToAttack = 0;
global makeInformation makeInformationG ;
makeInformation = zeros(1,BoidsNum);
makeInformationG = zeros(1,GreenNum);
global CarsNum Cars;
getConTin = 0;
%%
global xConTin
global yConTin

% Distance behind leader in the Column-formation
D_Behind = 7;
D_Beside = 7;
%%
%wander
global ArmyBlues;
global ArmyBluesNum;
xA =300;
xB = 500;
yA = 300;
yB = 700;
%%

%% first draw
% [v_Image,v_Alpha,BoidsPlot,fHandler] = InitializeGraphics();

[fHandler]=InitializeGraphics();
InitializeBase(); % khoi tao ban do + cac can cu quan su
[v_Image,v_Alpha,BoidsPlot] = InitializeArmyRed(); % khoi tao quan ta
%%
[v_ImageB,v_AlphaB,BluesPlot]=InitializeArmyBlue(); % khoi tao quan dich
[v_ImageG,v_AlphaG,GreensPlot]=InitializeArmyGreen();
[v_ImageC,v_AlphaC,CarsPlot]=InitializeCar();
[v_ImageFR,v_AlphaFR,v_ImageFB,v_AlphaFB]=LoadImageFlag();
[v_ImageRip,v_AlphaRip]=InitializeRip();

%%load sound
[bomb,gun,fight,bombFs,gunFs,fightFs]=loadSound();
%% khoi tao mau
[RedsHP]=InitializeHP(BoidsNum,BoidsNum,Boids);
%[RedsHP1]=InitializeHP(BoidsNum,100,Boids1);
[BluesHP]=InitializeHP(ArmyBluesNum,ArmyBluesNum,ArmyBlues);
[GreenHP]=InitializeHP(GreenNum,GreenNum,Greens);
%%
%Initialize the first positon of Goal
MousePosition = [400 600 0 0 0];
targetPosition = [700 0 0 0 0];
SaveMousePosition1 = plot(670, 700, 'o','MarkerSize',5,'MarkerFaceColor','yellow','Color','yellow');
saveText = text(650, 680, 'Con tin');
titleStr = 'BaiTap4. Giai cuu con tin';
titleStr = [titleStr newline '(Click de chon vi tri nghi binh)'];
title(titleStr);
set(fHandler, 'WindowButtonDownFcn',@cursorClickCallback);
    kB=1;
    kR=1;
    kG=1;


%% -----------------------------------
%Event Mouse click
    function cursorPosition = cursorClickCallback(~,~)
        p = get(gca,'CurrentPoint');
        cursorPosition(1:2) = p(1,1:2);
        cursorPosition(3) = 0;
        MousePosition = cursorPosition;
        %Draw Circle - position  

        delete(SaveMousePosition);
        SaveMousePosition = plot(MousePosition(1), MousePosition(2), 'o','MarkerSize',6, 'MarkerFaceColor','red','Color','red');
       
    end
%%------------------------------------
%% calculate agents' positions to move to each iteration
setappdata(0, 'OldTarget', Targets(1, 1:3));
timeTick = 1;

%% INITIALIZE COLUMN-FORMATION FOR FLOCK
Boids(1,1:3) = [30 100 0];
Boids(1,:) = applyForce(Boids(1,:), 0);
Leader = Boids(1, :);
BehindPosition  = Leader;
BoidIndex = 2;

TargetCar = [ 700 50 0;xConTin yConTin 0;  700 0 0; 50 50 0];%;

TargetIndex = 1;
[tm, tn] = size(TargetCar);
MaxTargetIndex = tm + 1;
TargetCar0 = TargetCar(1, :);

%% INITIALIZE COLUMN-FORMATION FOR GREEN FLOCK
Greens(1,1:3) = [30 100 0];
Greens(1,:) = applyForce(Greens(1,:), 0);
LeaderG = Greens(1, :);
BehindPositionG  = LeaderG;
GreenIndex = 2;



while BoidIndex <= BoidsNum
    %Find the RightBeside position of RightBesidePosition (2-nd Boid)
    BehindPosition = FindBehindLeader(BehindPosition,D_Behind);
    Boids(BoidIndex, 1:6) = BehindPosition;
    BehindPosition = Boids(BoidIndex,:);
    Boids(BoidIndex,:) = applyForce(Boids(BoidIndex,:), 0);
    
    BoidIndex = BoidIndex + 1;
end

while GreenIndex <= GreenNum
    %Find the RightBeside position of RightBesidePosition (2-nd Boid)
    BehindPositionG = FindBehindLeader(BehindPositionG,D_Behind);
    Greens(GreenIndex, 1:6) = BehindPositionG;
    BehindPositionG = Greens(GreenIndex,:);
    Greens(GreenIndex,:) = applyForce(Greens(GreenIndex,:), 0);
    
    GreenIndex = GreenIndex + 1;
end
% RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
% sound(fight,fightFs);
%% FLOCK MOVE TO THE GOAL


timeTick = 1;

while (timeTick < TimeSteps)
    %% don duoc con tin 

    
    %% set Target
    tempBlues = ArmyBlues;
    tempReds = Boids;
    tempCars = Cars;
    tempGreens = Greens;

    for BluesIndex = 1:ArmyBluesNum
        % steering
        ArmyBlues = updateAtBoundary(ArmyBlues,BluesIndex);
        
        CurrentBoid = ArmyBlues(BluesIndex, :);
        %
        force1 = steer_wander(CurrentBoid);% +  steer_separation(CurrentBoid,ArmyBluesNum, ArmyBlues );
        ArmyBlues(BluesIndex,:) = applyForce(CurrentBoid, force1);
    end
    %%

    %%
    %% Moving the 1-st Boid (as a leader)
    %force = steer_arrival(Boids(1,:), MousePosition); %Move toward the mouse
    force = steer_seek(Boids(1,:), MousePosition); %Move toward the mouse
    Boids(1,:) = applyForce(Boids(1,:), force);
    
    %% Moving Boids
    Leader = Boids(1, :);
    % di chuyen hang doc
    %[Boids, ~] = steer_Seek_Formation_Column(MousePosition, Boids, Leader, D_Behind, BoidsNum);
    % di chuyen hinh chu V
    Alpha_Horizontal = CalculationHorizontalAngle(Leader);
    [Boids, ~] = steer_Seek_Formation_V(MousePosition, Boids,BoidsNum, Leader, D_Behind, D_Beside, Alpha_Horizontal);
    %%
    %% Green time
    
    forceG = steer_seek(Greens(1,:), TargetCar(TargetIndex, :)); %Move toward the target 
    Greens(1,:) = applyForce(Greens(1,:), forceG);

    %% Moving Boids
    LeaderG = Greens(1, :);
        %neu da don duoc con tin run
    if (getConTin == 1)
        CurrentBoidC = Cars(1, :);
        forcecar = steer_seek(CurrentBoidC, LeaderG);
       Cars(1,:) = applyForce(CurrentBoidC, forcecar);
        %for CarIndex = 1: CarsNum
        %    Cars = updateAtBoundary(Cars,CarIndex);
            % steering
         %   CurrentBoidC = Cars(CarIndex, :);
         %   forcecar = steer_arrival(CurrentBoidC, TargetCar(TargetIndex, :));
         %   Cars(CarIndex,:) = applyForce(CurrentBoidC, forcecar);
    %         sound(tank,tankFs);
        %end
    end

    
    % Neu di chuyen doi hinh hang doc
    [Greens, ~] = steer_Seek_Formation_Column(TargetCar(TargetIndex, :),Greens, LeaderG, D_Behind, GreenNum);
    % Neu di chuyen doi hinh chu V
    %Alpha_Horizontal = CalculationHorizontalAngle(LeaderG);
    %[Greens, ~] = steer_Seek_Formation_V(MousePosition, Greens,GreenNum, LeaderG, D_Behind, D_Beside, Alpha_Horizontal);
    
    %%
    %% daviation Bule

    deviationXB = ShootDistanceB*(1-AccuracyB*(2*rand - 1));
    deviationYB = ShootDistanceB*(1-AccuracyB*(2*rand - 1));
    
    %% daviation Red
    deviationXR = ShootDistanceR*(1-AccuracyR*(2*rand - 1));
    deviationYR = ShootDistanceR*(1-AccuracyR*(2*rand - 1));
    
    %% daviation Green
    deviationXG = ShootDistanceG*(1-AccuracyG*(2*rand - 1));
    deviationYG = ShootDistanceG*(1-AccuracyG*(2*rand - 1));
    
    %% Reds

    AttackBlue = zeros(1,ArmyBluesNum);
    
    for i=1:BoidsNum
        %         if (goToAttack == 0)
        if(Boids(i,15)>0)
            Boids = updateAtBoundary(Boids,i);
            CurrentBoid = Boids(i, :);
            Boids(i,:) = applyForce(CurrentBoid, force);
            [J,~]=findTarget(Boids(i,:),ArmyBluesNum,ArmyBlues);
            if (J>0 && dist(Boids(i,:),ArmyBlues(J,:))<ShootDistanceB) %%
                %% hàm duong dan cua quan do
                Boids(i, :) = tempReds(i, :);
                Cars = tempCars;
                %%
                c1=line([Boids(i,1)-25, ArmyBlues(J,1)-25],[Boids(i,2)-15, ArmyBlues(J,2)-15],'Color','red','LineStyle','-.');
                sound(gun,gunFs);
                pause(0.02);
                delete(c1);
                
                AttackBlue(1,J)=AttackBlue(1,J)+5;
                
                %%cap nhat mau
%                 [ArmyBluesNum,ArmyBlues] = UpdateArmyBlueHP(AttackBlue,ArmyBluesNum,ArmyBlues)
            end
        end
    end
    
        %% Greens
        %AttackBlue = zeros(1,ArmyBluesNum);
    
    for i=1:GreenNum
        %         if (goToAttack == 0)
        if(Greens(i,15)>0)
            Greens = updateAtBoundary(Greens,i);
            CurrentBoid = Greens(i, :);
            Greens(i,:) = applyForce(CurrentBoid, force);
            [K,~]=findTarget(Greens(i,:),ArmyBluesNum,ArmyBlues);
            if (K>0 && dist(Greens(i,:),ArmyBlues(K,:))<ShootDistanceB) %%
                %% hàm duong dan cua quan do
                Greens(i, :) = tempGreens(i, :);
                Cars = tempCars;
                %%
                c1=line([Greens(i,1)-25, ArmyBlues(K,1)-25],[Greens(i,2)-15, ArmyBlues(K,2)-15],'Color','green','LineStyle','-.');
                sound(gun,gunFs);
                pause(0.02);
                delete(c1);
                
                AttackBlue(1,K)=AttackBlue(1,K)+5;
                
                %%cap nhat mau
%                 [ArmyBluesNum,ArmyBlues] = UpdateArmyBlueHP(AttackBlue,ArmyBluesNum,ArmyBlues)
            end
        end
    end
    %% Blues: duong dan quan xanh
    AttackRed=zeros(1,BoidsNum);
    AttackGreen=zeros(1,GreenNum);
    
    for i=1:ArmyBluesNum
        if(ArmyBlues(i,15)>0)
            ArmyBlues = updateAtAreaBoundary(ArmyBlues,i, xA, xB, yA, yB);
%             CurrentBoid = ArmyBlues(i,:);
            [J]=findTarget(ArmyBlues(i,:),BoidsNum,Boids);
            if (J>0 && dist(ArmyBlues(i,:),Boids(J,:))<ShootDistanceB)
                % Shoot
%                 %Mau xanh duoi theo
                for BlueIndex = i:ArmyBluesNum
                    ArmyBlues = updateAtAreaBoundary(ArmyBlues,BlueIndex, xA, xB, yA, yB);
                    %Steering Force
                    CurrentBoid = ArmyBlues(BlueIndex, :);
                    force = steer_seek(CurrentBoid, Boids(J,1:3));
                    if(dist(ArmyBlues(BlueIndex,1:3),Boids(J,1:3))>200)
                        ArmyBlues(BlueIndex,:) = applyForce(CurrentBoid, force);
                    end
                end
                %%
                %%
                ArmyBlues(i, :) = tempBlues(i, :);
                %%
                c2=line([Boids(J,1)-25, ArmyBlues(i,1)-25],[Boids(J,2)-15, ArmyBlues(i,2)-15],'Color','blue','LineStyle','-.');
                pause(0.02);
                sound(gun,gunFs);
                delete(c2);
                AttackRed(1,J)=AttackRed(1,J)+5;

            end
            
            [K]= findTarget(ArmyBlues(i,:), GreenNum, Greens);
            if (K>0 && dist(ArmyBlues(i,:),Greens(K,:))<ShootDistanceB)
                % Shoot
%                 %Mau xanh duoi theo
                for BlueIndex = i:ArmyBluesNum
                    ArmyBlues = updateAtAreaBoundary(ArmyBlues,BlueIndex, xA, xB, yA, yB);
                    %Steering Force
                    CurrentBoid = ArmyBlues(BlueIndex, :);
                    forceG = steer_seek(CurrentBoid, Greens(K,1:3));
                    if(dist(ArmyBlues(BlueIndex,1:3),Greens(K,1:3))>200)
                        ArmyBlues(BlueIndex,:) = applyForce(CurrentBoid, forceG);
                    end
                end
                %%
                %%
                ArmyBlues(i, :) = tempBlues(i, :);
                %%
                c2=line([Greens(K,1)-25, ArmyBlues(i,1)-25],[Greens(K,2)-15, ArmyBlues(i,2)-15],'Color','green','LineStyle','-.');
                pause(0.02);
                sound(gun,gunFs);
                delete(c2);
                AttackGreen(1,K)=AttackGreen(1,K)+5;
                %AttackGreen(1,J)=AttackGreen(1,J)+5;
%                 [BoidsNum,Boids] = UpdateBoid(AttackRed,BoidsNum,Boids)
            end
        end
    end
    %AttackGreen=zeros(1,GreenNum);
    %
    timeTick = timeTick+1;
%     RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot);
%     RedrawGraphics(ArmyBlues,ArmyBluesNum,v_ImageB,v_AlphaB,BluesPlot);
    RedrawBoid(Boids,BoidsNum,v_Image,v_Alpha,v_ImageRip,v_AlphaRip,BoidsPlot)
    RedrawBoid(Greens,GreenNum,v_ImageG,v_AlphaG,v_ImageRip,v_AlphaRip,GreensPlot)
    RedrawBoid(ArmyBlues,ArmyBluesNum,v_ImageB,v_AlphaB,v_ImageRip,v_AlphaRip,BluesPlot)
    RedrawGraphics(Cars,CarsNum,v_ImageC,v_AlphaC,CarsPlot);
    % End of Moving Boids
    RedrawRedsHP();
    RedrawBlueHP();
    RedrawGreensHP();
    
    %% Update Blues
    [ArmyBluesNum,ArmyBlues] = UpdateBoid(AttackBlue,ArmyBluesNum,ArmyBlues);
    %% Update Reds
    [BoidsNum,Boids] = UpdateBoid(AttackRed,BoidsNum,Boids);
    %% Update Reds
    [GreenNum,Greens] = UpdateBoid(AttackGreen,GreenNum,Greens);
        %% Blue Win 
    DieRNum = 0;
    DieGNum = 0;
    for i = 1: BoidsNum
        if ( Boids(i,15)<= 0) 
            DieRNum = DieRNum +1;
        end
    end 
    for i = 1: GreenNum
        if ( Greens(i,15)<= 0) 
            DieGNum = DieGNum +1;
        end
    end 
    if (DieGNum ==GreenNum)
        InitializeFlag(v_ImageFB,v_AlphaFB);
        break;
    end
    if ( DieRNum == BoidsNum && DieGNum == GreenNum) 
        InitializeFlag(v_ImageFB,v_AlphaFB);
        break;
    else
       DieRNum =0;
       DieGNum = 0;
    end
        %% Mission complete
    LeaderG = Greens (1, :);
    if(int64(LeaderG(1))> (TargetCar0(1)-10)&& int64(LeaderG(2))> (TargetCar0(2)-10)...
       && int64(LeaderG(1))< (TargetCar0(1)+10) && int64(LeaderG(2))< (TargetCar0(2)+10))
         %InitializeFlag(v_ImageFR,v_AlphaFR);
         %break;
         TargetIndex = TargetIndex +1;
         if (TargetIndex == MaxTargetIndex )
            InitializeFlag(v_ImageFR,v_AlphaFR);
            break;
         else
            if (TargetCar0(1) == xConTin && TargetCar0(2) == yConTin)
                getConTin = 1;
            end
            TargetCar0 = TargetCar(TargetIndex, :);

         end
    end
           %% Mission complete
    %if(int64(Cars(1))> (TargetCar0(1)-30)&& int64(Cars(2))> (TargetCar0(2)-30)...
       %&& int64(Cars(1))< (TargetCar0(1)+20) && int64(Cars(2))< (TargetCar0(2)+20))
         %InitializeFlag(v_ImageFR,v_AlphaFR);
         %break;
         %TargetIndex = TargetIndex +1;
         %if (TargetIndex == MaxTargetIndex)
         %   InitializeFlag(v_ImageFR,v_AlphaFR);
        %    break;
       %  else
      %      TargetCar0 = TargetCar(TargetIndex, :);
     %    end
    %end
    
end

end
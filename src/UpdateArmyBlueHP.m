function [ArmyBluesNum,ArmyBlues]=UpdateArmyBlueHP(Attack,ArmyBluesNum,ArmyBlues)
% Point=zeros(1,BoidsNum);
for i=1:ArmyBluesNum
    if(ArmyBlues(i,15)>0)    
        ArmyBlues(i,15)=ArmyBlues(i,15)-Attack(1,i);     
    end
end

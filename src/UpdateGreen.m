function [GreenNum,Greens]=UpdateGreen(Attack,GreenNum,Greens)
% Point=zeros(1,BoidsNum);
for i=1:GreenNum
    if(Greens(i,15)>0)    
        Greens(i,15)=Greens(i,15)-Attack(1,i);     
    end
end

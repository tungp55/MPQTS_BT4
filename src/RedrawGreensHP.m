function RedrawGreensHP()
global Greens;
global GreenNum;
global MaxRedNum;
global GreenHP;
global BloodPos;
global SizeHPBar;

delete(GreenHP); % xoa thanh mau
for i = 1 : GreenNum           
    if (Greens(i,15)>0)       
        x1=Greens(i,1)-45; % toa do cua thanh mau
        x2=Greens(i,1)-45 + Greens(i,15)/2;
        y1=Greens(i,2)+BloodPos+20;
        y2=Greens(i,2)+BloodPos+20;                  
        GreenHP(i)=plot([x1 x2],[y1 y2],'-','Color','g','LineWidth',SizeHPBar);%line([x1 x2],[y1 y2],'Color','green','LineStyle','-');       
    end
end
drawnow;
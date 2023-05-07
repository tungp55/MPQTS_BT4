function [ObstaclesPlot]=InitializeObstacles(v_ImageS1,v_AlphaS1,v_ImageS2,v_AlphaS2,v_ImageS3,v_AlphaS3,v_ImageS4,v_AlphaS4,v_ImageS5,v_AlphaS5,v_ImageS6,v_AlphaS6)
global Obstacles;
global ObstaclesNum;
Width=40;
%   for i=1:ObstaclesNum
%         plot(Obstacles(i,1),Obstacles(i,2),'o','MarkerSize',Obstacles(i,4)/2,'Color','b');
%   end
%%stone 1
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS1, angle);
    alpha_i = imrotate(v_AlphaS1, angle );
    ObstaclesPlot= image(Obstacles(1,1)+200, Obstacles(1,2)+500, img_i);
    ObstaclesPlot.AlphaData = alpha_i;   

%%stone 2
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS2, angle);
    alpha_i = imrotate(v_AlphaS2, angle );
    ObstaclesPlot= image(Obstacles(2,1)+150, Obstacles(2,2)+500, img_i);
    ObstaclesPlot.AlphaData = alpha_i;   
%%stone 3
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS3, angle);
    alpha_i = imrotate(v_AlphaS3, angle );
    ObstaclesPlot= image(Obstacles(3,1)+400, Obstacles(3,2)+200, img_i);
    ObstaclesPlot.AlphaData = alpha_i;   
%%stone 4
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS4, angle);
    alpha_i = imrotate(v_AlphaS4, angle );
    ObstaclesPlot= image(Obstacles(4,1)+500, Obstacles(4,2)+150, img_i);
    ObstaclesPlot.AlphaData = alpha_i;  
%%stone 5
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS5, angle);
    alpha_i = imrotate(v_AlphaS5, angle );
    ObstaclesPlot= image(Obstacles(5,1)+500, Obstacles(5,2)+150, img_i);
    ObstaclesPlot.AlphaData = alpha_i; 
%%stone 6
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageS6, angle);
    alpha_i = imrotate(v_AlphaS6, angle );
    ObstaclesPlot= image(Obstacles(6,1)+700, Obstacles(6,2)+200, img_i);
    ObstaclesPlot.AlphaData = alpha_i;  
   
end
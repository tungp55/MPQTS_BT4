function [v_Image,v_Alpha,BoidsPlot]=InitializeArmyRed()
global BoidsNum;
global Boids;
global ImageWidth;
ImageWidth =70;
[v_Image, ~, v_Alpha]	= imread('ArmyRed.png');
v_Image = imresize(v_Image, [30 30], 'lanczos3' );
v_Alpha = imresize(v_Alpha, [30 30], 'lanczos3' );
% BoidsPlot là m?ng các ð?i tý?ng ðý?c v? trên ð? th?

for BoidsIndex = 1 : BoidsNum
    angle = -180;	% imrotate rotates ccw     
    img_i = imrotate(v_Image, angle);
    alpha_i = imrotate(v_Alpha, angle );
    BoidsPlot(BoidsIndex) = image(Boids(BoidsIndex,1)- ImageWidth/2, Boids(BoidsIndex,2)-ImageWidth/2, img_i);
    BoidsPlot(BoidsIndex).AlphaData = alpha_i;   

end


end

    
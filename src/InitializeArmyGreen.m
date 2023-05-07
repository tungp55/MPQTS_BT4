function [v_ImageG,v_AlphaG,GreensPlot]=InitializeArmyGreen()
global ImageWidth;
global GreenNum;
global Greens;

[v_ImageG, ~, v_AlphaG]	= imread('ArmyGreen.png');
v_ImageG = imresize(v_ImageG, [30 30], 'lanczos3' );
v_AlphaG = imresize(v_AlphaG, [30 30], 'lanczos3' );


for GreensIndex = 1 : GreenNum
    angle = -180;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageG, angle);
    alpha_i = imrotate(v_AlphaG, angle );
    GreensPlot(GreensIndex) = image(Greens(GreensIndex,1)- ImageWidth/2, Greens(GreensIndex,2)-ImageWidth/2, img_i);
    GreensPlot(GreensIndex).AlphaData = alpha_i;  
end


end
function [v_ImageC,v_AlphaC,CarsPlot]=InitializeCar()
global CarsNum;
global Cars;
global ImageWidth;

ImageWidth = 110;
wid = 30;
hei = 30;
[v_ImageC, ~, v_AlphaC]	= imread('Contin1.png');
v_ImageC = imresize(v_ImageC, [wid hei], 'lanczos3' );
v_AlphaC = imresize(v_AlphaC, [wid hei], 'lanczos3' );


for CarsIndex = 1 : CarsNum
    angle = 345;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageC, angle);
    alpha_i = imrotate(v_AlphaC, angle );
    CarsPlot(CarsIndex) = image(Cars(CarsIndex,1)- wid/2, Cars(CarsIndex,2)-hei/2, img_i);
    CarsPlot(CarsIndex).AlphaData = alpha_i;   
end


end

    
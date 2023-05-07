function RedrawGraphics(Boids,BoidsNum,v_Image,v_Alpha,BoidsPlot)
global EnvironmentWidth;
global ImageWidth;
global TimeSteps;

for BoidIndex = 1 : BoidsNum
    v_angle = 180;
    try
        img_i = imrotate(v_Image, v_angle );
        alpha_i = imrotate(v_Alpha, v_angle );
    catch Me
        disp(' hi')
        disp('dsddsd')
        v_angle
    end
    
    BoidsPlot(BoidIndex).CData = img_i;
    BoidsPlot(BoidIndex).AlphaData = alpha_i;
    
    try
        BoidsPlot(BoidIndex).XData = Boids(BoidIndex,1)-ImageWidth/2;
        BoidsPlot(BoidIndex).YData = Boids(BoidIndex,2)-ImageWidth/2;
    catch Me
        disp('hi')
        [Boids(BoidIndex,1),Boids(BoidIndex,2)]
    end
end

drawnow;

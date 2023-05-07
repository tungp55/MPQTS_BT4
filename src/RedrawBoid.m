function RedrawBoid(Boids,BoidsNum,v_Image,v_Alpha,v_ImageE,v_AlphaE,BoidsPlot)
global EnvironmentWidth;
global ImageWidth;


for BoidIndex = 1 : BoidsNum
    if (Boids(BoidIndex, 15) > 0)            
                %     v_angle = Boids(BoidIndex,12);
        v_angle = -180;
        try
            img_i = imrotate(v_Image, v_angle );
            alpha_i = imrotate(v_Alpha, v_angle );
        catch 
            disp(' hi');
            v_angles
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
    else
        BoidsPlot(BoidIndex).CData = v_ImageE;
        BoidsPlot(BoidIndex).AlphaData = v_AlphaE;
    end
end

drawnow;
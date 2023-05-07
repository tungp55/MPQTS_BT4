function InitializeFlag (v_Image,v_Alpha)
    angle = 0;	% imrotate rotates ccw     
    BasesPlot= image(200, 400, v_Image);
    BasesPlot.AlphaData = v_Alpha; 
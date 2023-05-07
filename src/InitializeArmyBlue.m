function [v_ImageB,v_AlphaB,BluesPlot]=InitializeArmyBlue()
global ImageWidth;
global ArmyBlues;
global ArmyBluesNum;

[v_ImageB, ~, v_AlphaB]	= imread('ArmyBlue.png');
v_ImageB = imresize(v_ImageB, [30 30], 'lanczos3' );
v_AlphaB = imresize(v_AlphaB, [30 30], 'lanczos3' );


for BluesIndex = 1 : ArmyBluesNum
    angle = 0;	% imrotate rotates ccw     
    img_i = imrotate(v_ImageB, angle);
    alpha_i = imrotate(v_AlphaB, angle );
    BluesPlot(BluesIndex) = image(ArmyBlues(BluesIndex,1)- ImageWidth/3, ArmyBlues(BluesIndex,2)-ImageWidth/2, img_i);
    BluesPlot(BluesIndex).AlphaData = alpha_i;   
end


end
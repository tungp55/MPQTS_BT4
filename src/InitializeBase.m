function InitializeBase()
global EnvironmentWidth
[v_ImageBR, v_AlphaBR]	= plotImage('baseR.png', 250, 250, 0);

[v_ImageBB, v_AlphaBB]	= plotImage('baseB.png', 250, 250, 0);
angle = -180;	% imrotate rotates ccw    

% [v_ImageBF, ~, v_AlphaBF]	= imread('baseF.png');
% v_ImageBF = imresize(v_ImageBF, [800 800], 'lanczos3' );
% v_AlphaBF = imresize(v_AlphaBF, [800 800], 'lanczos3' );
[v_ImageBF, v_AlphaBF]	= plotImage('Map.png', 800, 800, 0);

%BackGround
img_i = imrotate(v_ImageBF, angle);
alpha_i = imrotate(v_AlphaBF, angle );
BasesPlot= image(0, 0, img_i);
BasesPlot.AlphaData = alpha_i;

angle_r=-180;
%can cu quan su ta
img_i = imrotate(v_ImageBR, angle_r);
alpha_i = imrotate(v_AlphaBR, angle_r );
BasesPlot= image(0, 0, img_i);
BasesPlot.AlphaData = alpha_i;

%can cu quan su dich
img_i = imrotate(v_ImageBB, angle);
alpha_i = imrotate(v_AlphaBB, angle );
BasesPlot= image(600,600, img_i);
BasesPlot.AlphaData = alpha_i;

end
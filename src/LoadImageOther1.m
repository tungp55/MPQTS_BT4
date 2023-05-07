function [v_ImageS1,v_AlphaS1,v_ImageS2,v_AlphaS2,v_ImageS3,v_AlphaS3,v_ImageS4,v_AlphaS4,v_ImageS5,v_AlphaS5,v_ImageS6,v_AlphaS6]=LoadImageOther1()

[v_ImageS1, ~, v_AlphaS1]	= imread('stone1.png');
v_ImageS1 = imresize(v_ImageS1, [90 90], 'lanczos3' );
v_AlphaS1 = imresize(v_AlphaS1, [90 90], 'lanczos3' );

[v_ImageS2, ~, v_AlphaS2]	= imread('stone5.png');
v_ImageS2 = imresize(v_ImageS2, [80 80], 'lanczos3' );
v_AlphaS2 = imresize(v_AlphaS2, [80 80], 'lanczos3' );

[v_ImageS3, ~, v_AlphaS3]	= imread('stone3.png');
v_ImageS3 = imresize(v_ImageS3, [75 75], 'lanczos3' );
v_AlphaS3 = imresize(v_AlphaS3, [75 75], 'lanczos3' );

[v_ImageS4, ~, v_AlphaS4]	= imread('stone4.png');
v_ImageS4 = imresize(v_ImageS4, [75 75], 'lanczos3' );
v_AlphaS4 = imresize(v_AlphaS4, [75 75], 'lanczos3' );

[v_ImageS5, ~, v_AlphaS5]	= imread('stone5.png');
v_ImageS5 = imresize(v_ImageS5, [75 75], 'lanczos3' );
v_AlphaS5 = imresize(v_AlphaS5, [75 75], 'lanczos3' );

[v_ImageS6, ~, v_AlphaS6]	= imread('stone6.png');
v_ImageS6 = imresize(v_ImageS6, [80 80], 'lanczos3' );
v_AlphaS6 = imresize(v_AlphaS6, [80 80], 'lanczos3' );

function [v_ImageRip,v_AlphaRip]=InitializeRip()
global ImageWidth;
[v_ImageRip, ~, v_AlphaRip]	= imread('rip.png');
v_ImageRip = imresize(v_ImageRip, [50 50], 'lanczos3' );
v_AlphaRip = imresize(v_AlphaRip, [50 50], 'lanczos3' );
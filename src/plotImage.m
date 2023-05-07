function [v_img,v_alpha] = plotImage(imgUrl, width, height, isRotated)

[v_img, ~, v_alpha]	= imread(imgUrl);
v_img = imresize(v_img, [width height], 'lanczos3' );
v_alpha = imresize(v_alpha, [width height], 'lanczos3' );
if isRotated == 1
    angle = -180;
    v_img = imrotate(v_img, angle);
    v_alpha = imrotate(v_alpha, angle );
end
v_img = flipdim(v_img, 2);
v_alpha = flipdim(v_alpha, 2);
end


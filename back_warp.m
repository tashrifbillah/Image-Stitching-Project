function [mask, result_img] = back_warp(src_img, resultToSrc_H, dest_canvas_width_height)

Hinv= resultToSrc_H; 

[m,n,~]= size(src_img);
% Corner points in the portrait [X, Y]
corners= [1,1; n,1; n,m; 1,m; 1,1];

% Transformed corner points on the black canvas [X, Y]
trans_corners= transform(inv(Hinv), corners);

w= dest_canvas_width_height(2); % Height Ydim
h= dest_canvas_width_height(1); % Width Xdim

canvas= zeros(h,w);
[poly_x, poly_y]= find(canvas==0);

temp= inpolygon(poly_x, poly_y, trans_corners(:,1), trans_corners(:,2));


mask= reshape(temp,h,w)';
% figure; imshow(mask);

[dx,dy]= find(mask); % Destination points
Dest= [dy,dx];
Sorc= transform(Hinv, Dest);
sx= Sorc(:,1);
sy= Sorc(:,2);

% % Color of (Dest coordinates)= Color from Portrait(Sour coordinates)
A= zeros(w,h,3);
L= length(dx);
for i= 1:L
  
    for j=1:3
        if sy(i)>0 && sx(i)>0 && sy(i)<=m && sx(i)<=n
            A(dx(i),dy(i),j)= src_img(sy(i),sx(i),j);
        end
    end
    
end

% imshow(A);
result_img= A;


end



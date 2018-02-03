function [ ]= Im_Stitching_Panorama( )

cd('Sub_Images\'); 

im1 = im2single(imread('a1.png'));
im2 = im2single(imread('a2.png'));
im3 = im2single(imread('a3.png'));

cd ..

stitched_img = stitching(im1, im2, im3);
%figure, imshow(stitched_img);
imwrite(stitched_img, 'stitched_panorama.png');


end


























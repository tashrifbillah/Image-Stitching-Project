# Image-Stitching-Project

A program has to be written that stitches the input images into one mosaic. The program should accept an arbitrary number of images. However, stitching images along only a single row/column is considered.

In brief, when warping multiple images on to a single base image, you want to first compute the bounding box where left and right images superimpose on the center image. Once you have the bounding boxe coordinates, you can homograph your source images into the common canvas. Finally, you want to blend the images assigning appropriate weight to the pixels of all the images.

This is a [good read](https://courses.engr.illinois.edu/cs498dwh/fa2010/lectures/Lecture%2017%20-%20Photo%20Stitching.pdf) for the above project that will introduce you to the workflow.


# Function description
Please see the following description of the accompanying functions-

# Im_Stitching_Panorama( )
This is the main function that will interface to the sub routines. You basically put your images in [Panorama](https://github.com/tashrifbillah/Image-Stitching-Project/tree/master/Panorama) folder in number of 3, 5, 7, 9 .... Then you pass the images to [stitching( )](https://github.com/tashrifbillah/Image-Stitching-Project/blob/master/stitching.m) from left to right. The program will save the stiched images (panorama) in the directory you are working in.

The following are the subroutines I have used for the project.

# find_homography( )

In the Ah=0 equation, A is computed iteratively. Thereby, yielding a compact code other than writing all 8 rows by hand. Finally, the homography was reshaped to get 3x3 matrix instead of a 9x1 vector.


# transform( )

To obtain z from z~, we have applied vectorization technique to divide the whole row at once (elementwise) resulting in a compact code.


# back_warp( )

In class we were taught that, if we go from source to destination, there might be wholes between adjacent pixels. That is why, we went from destination to source, obtained corresponding color information, and plugged it back to the pixel in destination image. This process could not be done more efficiently by vectorization. That is why, we have to use for loop to do the barkward image warping. The required time in this process, is essentially a bottleneck of the whole program.

Also, we used a tricky find( ) command to get all the x,y coordinates of the image matrix at once.

The mask was carefully checked step by step during debugging to ensure the program works perfect.


# RAN_SAC( )

We have used the algorithm exactly from class lecture to compute the best homography and inliers. The error margin is 0.5. That means- we choose a pixel as inlier only if it is within 0.5 radius from the actual pixel. On the other hand, we have chosen 500 iteration for the ransac after trial and error with 500, 1000, and 2,000 iterations.

If we allow higher error, then the homographed image looks distorted and shifted. On the other hand, if we allow very low error margin, then there might not be any matches between the source and destination images. Therefore, we did many trials to find out the suitable epsilon, which is settled at 0.5.


# blend_images( )

Overlaying was straighforward. We superimposed one image upon another. To do that, 3-D concatenation was used, looking back at HW1.

However, for blending, we had to calculate weight. bwdist( ) function was used for weight caculation. However, application of bwdist() to get weights was tricky. Since, weight is the nearest edge distance and bwdist( ) assigns the nearest nonzero value to a pixel, the mask was first inverted to get proper weights. Then, the weight matrix was normalized with respect to the maximum of all weights, to transform them in the format shown in class lecture.

Finally, vectorization was used to divide one matrix by another (elementwise) to get weighted mixture of the two images.


# stitching( )

The sequence of image im1,im2,im3,..... is such that the image starts from left. We take three images at a time and stitch them together. Again, when im1,im2,im3 are stitched to IMLeft, we stitch IMLeft,im4,im5 and so on. The algorithm is nicely written so that it can work on arbitrary number of inputs. However, for my algorithm, the input images should be in numbers of 3,5,7,9,....


The steps are briefly described below-

1. Take left and center image, do sift, run ransac, find left to center homography, project left upon center, do blending.......

2. Take right and center image, do sift, run ransac, find right to center homography, project right upon center, do blending.......

3. Finally, crop the uniform rectangular panorama so that it can be nicely merged with next sequence of images


During homography computation, some x,y are negative. To circumvent this problem, all there images are pushed down or to the left. Also, the boudning box is computed first which bounds the three images. After projecting i.e backward warping each image in appropriate location determined by homography, we blend them. To do that, we blend left+center first, center+right second and then combine the above two.

# sift_match( )
This function will find the SIFT features between two similar looking images. Please see the function for credit to appropriate source. The above procedure is built upong finding SIFT match between two images. There is another folder [sift_lib](https://github.com/tashrifbillah/Image-Stitching-Project/tree/master/sift_lib) that you also need to use. The [sift_match](https://github.com/tashrifbillah/Image-Stitching-Project/blob/master/sift_match.m) function automatically interface with the [sift_lib](https://github.com/tashrifbillah/Image-Stitching-Project/tree/master/sift_lib) folder and you can get away without worrying about it.


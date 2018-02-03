function H_3x3 = find_homography(src_pts_nx2, dest_pts_nx2)

Xs= src_pts_nx2(:,1);
Ys= src_pts_nx2(:,2);
Xd= dest_pts_nx2(:,1);
Yd= dest_pts_nx2(:,2);


A= [ ];

for i= 1:4

    A(2*i-1,: )= [Xs(i) Ys(i)  1    0      0    0   -Xd(i)*Xs(i) -Xd(i)*Ys(i) -Xd(i)];            

    A(2*i,: )  = [0      0     0   Xs(i) Ys(i)  1   -Yd(i)*Xs(i) -Yd(i)*Ys(i) -Yd(i)];
    
end


[V,D] = eig(A'*A);
[~,ind]= min(diag(D));

temp= V(:,ind);
H_3x3= reshape(temp,3,3)';


end
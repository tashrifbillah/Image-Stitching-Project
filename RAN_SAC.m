function [inliers_id, Hmin] = RAN_SAC(Xs, Xd, ransac_n, eps)

N= size(Xs,1);

eta= 0; % A big number for computing the best H if max number of iterations exceed

for i= 1:ransac_n
    
    rand_sample= datasample(1:N,4);
    rand_sorc= Xs(rand_sample,: );
    rand_dest= Xd(rand_sample,: );
    
    H= find_homography(rand_sorc, rand_dest);
    
    Xd_prime= transform(H, Xs);
    
    inliers_id= find(sqrt(sum((Xd_prime-Xd).^2,2))<eps);
    
    if length(inliers_id)>eta
        Hmin= H;
        eta= length(inliers_id);
    end    
    
end

% i
% eta

Xd_prime= transform(Hmin, Xs);
% Pointwise error calculation to find out inlers
Error= sqrt(sum((Xd_prime-Xd).^2,2));
inliers_id= find(Error<=eps);  

end


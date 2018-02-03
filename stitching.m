function stitched_img = stitching(varargin)

    
      source= (cell2mat(varargin(1)));
           
     for i= 2:2:nargin
         
        left= source; 
        cen= (cell2mat(varargin(i)));
        right= (cell2mat(varargin(i+1)));
        
        [xl, xlc] = sift_match(left,cen);
        [xcr, xr] = sift_match(cen, right);
        
        ransac_n = 500; % Max number of iterations
        ransac_eps = 0.5; % Acceptable alignment error        
        [~, Hlc] = RAN_SAC(xl, xlc, ransac_n, ransac_eps);                
        [~, Hrc] = RAN_SAC(xr, xcr, ransac_n, ransac_eps);
        
                
        [ml,nl,~]= size(left); % Ydim x Xdim x 3 
        [mc,nc,~]= size(cen); % Ydim x Xdim x 3
        [mr,nr,~]= size(right); % Ydim x Xdim x 3
        % top left, top right, bottom right, bottom left in the source        
        cor_left= [1,1; nl,1; nl,ml; 1,ml; 1,1]; % Column vector [X Y]
        cor_cen= [1,1; nc,1; nc,mc; 1,mc; 1,1]; % Column vector [X Y]
        cor_right= [1,1; nr,1; nr,mr; 1,mr; 1,1]; % Column vector [X Y]
        
        trans_left = transform(Hlc, cor_left); % Column vector [X Y]
        trans_right = transform(Hrc, cor_right); % Column vector [X Y]
        
   

        dyl= 0;
        if sum(trans_left( :,2)<0)            
            % Translation of y coordinate to account for negativity
            dyl= abs(min(trans_left( :,2)));    
            
        end
        
        dxl= 0;
        if sum(trans_left( :,1)<0)            
            % Translation of x coordinate to account for negativity
            dxl= abs(min(trans_left( :,1)));           
        end
        
        
        dyr= 0;
        if sum(trans_right( :,2)<0)            
            % Translation of y coordinate to account for negativity
            dyr= abs(min(trans_right( :,2)));    
            
        end
        
        dxr= 0;
        if sum(trans_right( :,1)>nc)            
            % Translation of x coordinate to account for additional size
            dxr= abs(min(trans_right( :,1)));           
        end
        
        
        Tl= [1 0 dxl+1; 0 1 max(dyl,dyr)+1; 0 0 1];
        Tr= [1 0 dxl+1; 0 1 max(dyl,dyr)+1; 0 0 1]; 
        Hlc_prime= Tl*Hlc;
        Hrc_prime= Tr*Hrc;
        
        left_prime_cor = transform(Hlc_prime, cor_left);
        cen_prime_cor= transform(Tl, cor_cen);
        right_prime_cor = transform(Hrc_prime, cor_right);
        
        % Vertical span
        h= abs(range([left_prime_cor( :,2); cen_prime_cor( :,2); right_prime_cor( :,2)]))+1;        
        w= abs(min(trans_left( :,1)))+ nr+ min(trans_right( :,1)); % Adjusted to nr, keep in mind        

        Hc= [1 0 dxl+1; 0 1 max(dyl,dyr)+1; 0 0 1];

               
         
        % Left image warping
        [mask1, black_canvas_1] = back_warp(left, inv(Hlc_prime),[w,h]);
                
        % Center image warping
        [mask2, black_canvas_2] = back_warp(cen, inv(Hc),[w,h]);
        
        % Right image warping
        [mask3, black_canvas_3] = back_warp(right, inv(Hrc_prime),[w,h]);
        
                              
        blend_lc = blend_images(black_canvas_1, mask1, black_canvas_2, mask2,'blend');
        masklc= mask1 | mask2;
        blend_rc = blend_images(black_canvas_2, mask2, black_canvas_3, mask3,'blend');
        maskrc= mask2 | mask3;
        
        blend_lc(isnan(blend_lc))=0;
        blend_rc(isnan(blend_rc))=0;
        
        temp= blend_images((blend_lc), masklc, (blend_rc), maskrc,'blend');
        % crop the source
        
        % The following cropping feature has been employed because we want
        % to do multi image stitching, not just two of them.
        % If you want to see raw panorama, then use-
        % imshow(temp);
        % source= temp;
        % And comment the following lines
        
        
        bordery= max(dyl,dyr)+1;
        borderx= max(left_prime_cor(1,1), left_prime_cor(4,1));
        source= imcrop(temp, [borderx bordery w-1 mc-1]);
        % figure; imshow(source);
        
     end

    stitched_img= source;

end
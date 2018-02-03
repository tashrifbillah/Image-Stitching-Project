function out_img = blend_images(wrapped_imgs, masks, wrapped_imgd, maskd, mode)


if strcmp(mode,'overlay')
    
    new_mask= uint8(masks & ~maskd);
    out_img= wrapped_imgs .*cat(3, new_mask, new_mask, new_mask) + wrapped_imgd;
    
elseif strcmp(mode,'blend')
    
    new_mask= masks | maskd;
    % figure; imshow(new_mask);
    
    w1= (bwdist(~masks));
    w1= w1/max(w1(:));
    w1= w1.*cat(3, new_mask, new_mask, new_mask);
    % figure; imshow(w1);
    
    w2= (bwdist(~maskd));
    w2= w2/max(w2(:));
    w2= w2.*cat(3, new_mask, new_mask, new_mask);
    % figure; imshow(w2);
   
    out_img= (w1.*im2single(wrapped_imgs)+ w2.*im2single(wrapped_imgd))./(w1+w2);
    
           
else    
    disp('Please enter correct mode and try again.');
    return       
end

% figure; imshow(out_img);

end


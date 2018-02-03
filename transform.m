function dest_pts_nx2 = transform(H_3x3, src_pts_nx2)

N= size(src_pts_nx2,1);
temp = H_3x3*[src_pts_nx2'; ones(1,N)];
dest_pts_nx2= temp(1:2,: ); % Extract the X and Y only

% Scale the destination x and y
dest_pts_nx2(1,: )= dest_pts_nx2(1,: )./temp(3,: );
dest_pts_nx2(2,: )= dest_pts_nx2(2,: )./temp(3,: );

dest_pts_nx2= dest_pts_nx2'; % Make X and Y column vectors
dest_pts_nx2= round(dest_pts_nx2);

end
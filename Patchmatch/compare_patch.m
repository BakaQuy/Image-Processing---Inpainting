function output =compare_patch(image_a,image_b,x,y,xn,yn,dim_wind)
[m,n,~]=size(image_a);
[mb,nb,~]=size(image_b);
[ min_x, min_y, max_x, max_y ]=limit_patch( x, y, m, n, dim_wind );
[ min_xb, min_yb, max_xb, max_yb ]=limit_patch( xn, yn, mb, nb, dim_wind );
% disp([ min_x, min_y, max_x, max_y ])
% disp([ min_xb, min_yb, max_xb, max_yb ])
patch_a=image_a(min_x:max_x,min_y:max_y);
patch_b=image_b(min_xb:max_xb,min_yb:max_yb);

diff=patch_a-patch_b;
output=sum(sum(sum(diff.^2)))/(dim_wind^2);

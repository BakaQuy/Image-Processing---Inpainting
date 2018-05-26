function output =compare_patch(image_a,image_b,x,y,xn,yn,dim_wind)
[m,n,~]=size(image_a);
[ min_x, min_y, max_x, max_y ]=limit_patch(x,y,m,n,dim_wind);
[ min_xn, min_yn, max_xn, max_yn ]=limit_patch(xn,yn,m,n,dim_wind);

patch_a=image_a(min_x:max_x,min_y:max_y,:);
patch_b=image_b(min_xn:max_xn,min_yn:max_yn,:);
% disp(size(patch_a))
% disp(size(patch_b))
diff=patch_a-patch_b;
output=sum(sum(sum(diff.^2)));
% disp(output)
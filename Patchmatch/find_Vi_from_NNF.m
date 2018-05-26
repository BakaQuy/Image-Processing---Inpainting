function Vi = find_Vi_from_NNF(Wi,NNF,inImg,p_position)
x1 = Wi.center(1);
y1 = Wi.center(2);
x2 = NNF(x1,y1,1);
y2 = NNF(x1,y1,2);
[m,n,~]=size(NNF);
% disp(size(NNF))
Window = (sqrt(length(Wi.patch)));
[ min_x, min_y, max_x, max_y ]=limit_patch( x2, y2, m, n, Window );
Vi.patch = reshape(inImg(min_x:max_x,min_y:max_y,:),length(Wi.patch),3);
Similitude = ComputeSim(Wi.patch,Vi.patch);
Vi.wi = 1.3^(-norm([x1,y1]-[x2,y2]))*Similitude;
Vi.color = Vi.patch(Wi.position_rel,:);
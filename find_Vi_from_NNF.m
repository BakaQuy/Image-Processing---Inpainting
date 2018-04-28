function Vi = find_Vi_from_NNF(Wi,NNF,inImg,p_position)
x1 = Wi.center(1);
y1 = Wi.center(2);
x2 = NNF(x1,y1,1);
y2 = NNF(x1,y1,2);

Window = floor(sqrt(length(Wi.patch))/2);

Vi.patch = reshape(inImg(x2-Window:x2+Window,y2-Window:y2+Window,:),length(Wi.patch),3);
Similitude = ComputeSim(Wi.patch,Vi.patch);
Vi.wi = 1.3^(-norm([x1,y1]-[x2,y2]))*Similitude;
Vi.color = Vi.patch(Wi.position_rel,:);

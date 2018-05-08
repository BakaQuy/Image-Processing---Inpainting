function output= patchmatch(image,iteration,dim,mask,dim_wind)

[m,n,p]=size(image);
output=zeros(m,n,p);
norm_matrix=inf*ones(m,n);
NNF=inf*ones(m,n,2);
x_basis=zeros(n,m);
y_basis=zeros(m,n);

for i=1:m
    for j=1:n
        if mask(i,j)~=0
            y_basis(i,j)=j;
            x_basis(j,i)=i;
        end
    end
end

                 
for it=0:iteration
    for i=1:m
        for j=1:n
            a=setdiff(x_basis(j,:),0);
            b=setdiff(y_basis(i,:),0);
            exclusion_x=min(a)-ceil(dim_wind/2):max(a)+ceil(dim_wind/2);
            exclusion_y=min(b)-ceil(dim_wind/2):max(b)+ceil(dim_wind/2);
            x=randsample(setdiff(1:m, exclusion_x), 1);
            y=randsample(setdiff(1:n, exclusion_y), 1);
%             x=randi([1,m],1);
%             y=randi([1,n],1);
            temp1=norm([x y]-[i j]);
            if temp1<=norm([NNF(i,j,1) NNF(i,j,2)]-[i j]) 
                NNF(i,j,1)=x; 
                NNF(i,j,2)=y;
                norm_matrix(i,j)=norm([NNF(i,j,1) NNF(i,j,1)]-[i j]);
            end
        end
    end
    NNF=propagation(norm_matrix,NNF,it,dim); 
end

for k=1:m
    for h=1:n
        x_b=(NNF(k,h,1));
        y_b=(NNF(k,h,2));
        output(k,h,:)=image(x_b,y_b,:);
    end
end
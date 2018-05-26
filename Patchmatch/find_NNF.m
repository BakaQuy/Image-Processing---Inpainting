function output= find_NNF(image,iteration,mask,dim_wind)

[m,n,p]=size(image);
output=zeros(m,n,2);
norm_matrix=inf*ones(m,n);
NNF=max([m,n])*ones(m,n,2);
x_basis=zeros(n,m);
y_basis=zeros(m,n);
image_b=zeros(m,n,p);
tic
for i=1:m
    for j=1:n
        if mask(i,j)~=0
            image_b(i,j,:)=0;
        else
            image_b(i,j,:)=image(i,j,:);
        end
    end
end
toc
disp('imageb done')

for it=0:iteration
    for i=1:m
        for j=1:n
            x=randi([1,m],1);
            y=randi([1,n],1);
%             tic 
            temp1=compare_patch(image,image_b,i,j,x,y,dim_wind);
%             toc
%             disp('time between comparaison')
            if temp1<=norm_matrix(i,j)
                NNF(i,j,1)=x; 
                NNF(i,j,2)=y;
                norm_matrix(i,j)=temp1;
            end
        end
    end
    NNF=propagation(norm_matrix,NNF,iteration,image,image_b,dim_wind); 
end

output=NNF;
        
        
             
                
    

    

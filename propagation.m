function output =propagation(norm_matrix,NNF,it,im_a,im_b,dim_wind)
[m,n,~]=size(NNF);
output=ones(m,n,2);
for i=1:m
    for j=1:n
        if i-1~=0 && j-1~=0
            temp=[norm_matrix(i-1,j) norm_matrix(i,j-1) norm_matrix(i,j)];
            [~,I]=min(temp);
            if I==1
                NNF(i,j,:)=NNF(i-1,j,:);
%                 NNF(i,j,2)=j;
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
            elseif I==2 
                NNF(i,j,:)=NNF(i,j-1,:);
%                 NNF(i,j,2)=j-1;
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
            else
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
            end
        elseif i==1 && j~=1
             temp=[norm_matrix(i,j-1) norm_matrix(i,j)];
             [~,I]=min(temp);
             if I==1 
                NNF(i,j,:)=NNF(i,j-1,:);
%                 NNF(i,j,2)=j-1;
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
             else
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
             end
        elseif j==1 && i~=1
              temp=[norm_matrix(i-1,j) norm_matrix(i,j)];
             [~,I]=min(temp);
            if I==1  
               NNF(i,j,:)=NNF(i-1,j,:);
%                NNF(i,j,2)=j;
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
               output(i,j,1)=vec(1);
               output(i,j,2)=vec(2);
            else
                vec=randomsearch(NNF,i,j,im_a,im_b,it,dim_wind);
                output(i,j,1)=vec(1);
                output(i,j,2)=vec(2);
           end
        end    
    end
end
function [output1,output2]= find_NNF(imageA,imageB,iteration,dim_wind)

% if ~ismatrix(imageA); image = rgb2gray(imageA); end
% if ~ismatrix(imageB); image_b = rgb2gray(imageB); end
% image=im2double(image);
% image_b=im2double(image_b);
image=(imageA);
image_b=(imageB);

[m,n,~]=size(image);
norm_matrix=10*ones(m,n);
NNF=max([m,n])*ones(m,n,2);
[mb,nb,~]=size(image_b);
dim=min(floor(mb/2),floor(nb/2));
width=floor(dim_wind/2);

for it=1:iteration
    tic
    %% initialization
    disp([num2str(it),'th iteration start!. ']);
    for i=1:m
        for j=1:n
            x=randi([1,mb],1);
            y=randi([1,nb],1);
            temp1=compare_patch(image,image_b,i,j,x,y,dim_wind);
            if temp1<=norm_matrix(i,j)
                NNF(i,j,1)=x; 
                NNF(i,j,2)=y;
                norm_matrix(i,j)=temp1;
            end
        end
    end
    
    
    for i=1:m
        for j=1:n
            
            bestx =NNF(i,j,1);
            besty=NNF(i,j,2);
            dist=norm_matrix(i,j);
            
 %%  propagation
 
 
            for k=2:-1:0
                d=2^k;
                if i-d > 0
                    rx=NNF(i-d,j,1)+d;
                    ry=NNF(i-d,j,2);
                    if rx<mb
                    val1=compare_patch(image,image_b,i,j,rx,ry,dim_wind);
                        if val1<dist
                             bestx =rx;
                             besty=ry;
                             dist=val1;
                        end
                    end
                end
                
                if j-d > 0
                    rx=NNF(i,j-d,1);
                    ry=NNF(i,j-d,2)+d;
                    if ry<nb
                    val1=compare_patch(image,image_b,i,j,rx,ry,dim_wind);
                        if val1<dist                            
                            bestx =rx;
                            besty=ry;
                            dist=val1;
                        end
                    end
                end
                
                
                if i+d <=mb 
                    rx=NNF(i+d,j,1)-d;
                    ry=NNF(i+d,j,2);
                    if rx>0
                    val1=compare_patch(image,image_b,i,j,rx,ry,dim_wind);
                        if val1<dist                            
                            bestx =rx;
                            besty=ry;
                            dist=val1;
                        end
                    end
                end
                
                if j+d <=nb 
                    rx=NNF(i,j+d,1);
                    ry=NNF(i,j+d,2)-d;
                    if ry>0
                    val1=compare_patch(image,image_b,i,j,rx,ry,dim_wind);
                        if val1<dist                            
                            bestx =rx;
                            besty=ry;
                            dist=val1;
                        end
                    end
                end
            end
            
            
  %% random search
  
            k=1;
            while dim*(0.5^k)>=1
                v=round(dim*(0.5^k));
                x_min=max(bestx-v,1);
                x_max=min(bestx+v,mb);
                y_min=max(besty-v,1);
                y_max=min(besty+v,nb);
%                 disp([x_min x_max y_min y_max])
%                 disp(v)
                rx=randi([x_min x_max],1);
                ry=randi([y_min y_max],1);
                temp=compare_patch(image,image_b,i,j,rx,ry,dim_wind);
                if temp<=dist 
                    dist=temp;
                    bestx=rx;
                    besty=ry;
                end
                k=k+1;
            end
            
            NNF(i,j,1)=bestx;
            NNF(i,j,2)=besty;
            norm_matrix(i,j)=dist;
            
        end
    end
    
    toc
end
NNF(:,:,1:2)=NNF(:,:,2:-1:1);
output1=NNF;
output2=norm_matrix;
        
        
             
                
    

    

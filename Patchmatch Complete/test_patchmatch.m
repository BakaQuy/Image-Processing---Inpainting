%test patchmatch
aind2=imread('test.jpg');
aind=imread('test.jpg');
im=im2double(aind);
im2=im2double(aind2);
[m,n,p]=size(aind);
% mask=zeros(m,n);
% H=[1 50;1 300];
% im2=im;
% im2(H(1,1):H(1,2),H(2,1):H(2,2),:)=1;
dim_wind=7;
tic;
[NNF,mat]=find_NNF(im,im2,1,dim_wind);
%% test
im_next=zeros(m,n,p);

for k=1:m
    for h=1:n
        x_b=(NNF(k,h,2));
        y_b=(NNF(k,h,1));
        im_next(k,h,:)=double(aind2(x_b,y_b,:))./255;
    end
end
toc;
subplot(1,2,1)
imshow((aind))
title('Original')
subplot(1,2,2)
imshow((im_next))
title('Patchmatch')
figure
imshow(mat)

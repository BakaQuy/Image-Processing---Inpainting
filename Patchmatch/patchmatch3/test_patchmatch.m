%test patchmatch
aind=imread('coque_drole.jpg');
im=im2double(aind);
[m,n,~]=size(im);
mask=zeros(m,n);
mask(1:125,1:20)=1;
dim_wind=7;
tic;
im_next=patchmatch(im,7,7,mask,dim_wind);
toc;
subplot(1,2,1)
imshow(im)
title('Original')
subplot(1,2,2)
imshow(im_next)
title('Patchmatch')

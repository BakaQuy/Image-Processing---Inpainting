%test patchmatch
clear; close all;
aind=imread('coque_drole.jpg');
im=im2double(aind);
tic;
im_next=patchmatch(im,3,7);
toc;
subplot(1,2,1)
imshow(im)
title('Original')
subplot(1,2,2)
imshow(im_next)
title('Patchmatch')
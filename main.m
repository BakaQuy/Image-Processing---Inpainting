clc;clear;
addpath(genpath('CSH'));
addpath(genpath('Images'));

image = 'original2.png';

imageIn = imread(image);
binaryMask = get_binary_mask(imageIn);

tic
A = inpaint(imageIn,binaryMask);
toc

figure
imshow(A)
title('Finito!')

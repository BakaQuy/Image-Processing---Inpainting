clc;clear;close all;
addpath(genpath('CSH'));
addpath(genpath('Images'));
addpath(genpath('Patchmatch'));

image = 'test.jpg';

imageIn = imread(image);
% binaryMask = get_binary_mask(imageIn);
binaryMask = SelectTarget(imageIn); %Jerry's function

tic
A = inpaint(imageIn,binaryMask);
toc

figure
imshow(A)
title('Finito!')
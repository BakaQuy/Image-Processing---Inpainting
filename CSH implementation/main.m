clc;clear;close all;
addpath(genpath('CSH'));
addpath(genpath('Images'));
addpath(genpath('Patchmatch'));

image = 'test.jpg';

imageIn = imread(image);
% binaryMask = get_binary_mask(imageIn);
%binaryMask = SelectTarget(imageIn); %Jerry's function
load testmask1.mat

tic
A8 = inpaint(imageIn,binaryMask);
toc

figure
imshow(A8)
% title('Finito!')



%% Plot
load A2
load A4
load A8
subplot(1, 3, 1);imshow(A2);title('Window Size: 2x2');
subplot(1, 3, 2);imshow(A4);title('Window Size: 4x4');
subplot(1, 3, 3);imshow(A8);title('Window Size: 8x8');
clear;close all;clc;
addpath(genpath('CSH'));
addpath(genpath('Images'));

image = 'original2';

Aorg = imread([image '.png']);
% Morg = imread([image '-mask.png']);

[m,n,o] = size(Aorg);
H = [97 130;279 297];
Morg = zeros(m,n);
Morg(H(1,1):H(1,2),H(2,1):H(2,2)) = 1;

A=patch_inpaint(Aorg,Morg);
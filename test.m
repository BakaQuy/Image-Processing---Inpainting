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

tic
A=patch_inpaint(Aorg,Morg);
toc

% imshow(A)

%%
% A = [1 2 3 4 5 5 5 5;1 2 3 4 5 5 5 5];
% if any(A(:)==1) && ~any(A(:)==6)
%     disp('ok')
% end
%%

% % Resize image to starting scale
% A = Aorg;
% M = Morg;
% M(M>0)=1;
% M3 = repmat(M,[1 1 3])==1;

% % Random starting guess for inpainted image
% [m n rgb] = size(A);
% Rnd = uint8(255*rand(m,n,rgb));
% A(M3) = Rnd(M3);
% 
% B = A;
% B(M3)=0;
% 
% width = 16;
% csh_iterations = 10;
% k = 1;
% calcBnn = 0;
% CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
% 
% i = 133-15;
% j = 167-15;
% patch = A(i:i+width-1,j:j+width-1,:);
% i2 = CSH_ann(i,j,2);
% j2 = CSH_ann(i,j,1);
% patch2 = A(i2:i2+width-1,j2:j2+width-1,:);
% 
% figure
% subplot(1,2,1)
% imshow(im2double(patch))
% subplot(1,2,2)
% imshow(im2double(patch2))
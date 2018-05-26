clear; close all;
addpath(genpath('Images'));
addpath(genpath('Patchmatch'));
addpath(genpath('Spiral'));
addpath(genpath('Wexler'));

%% Parameters
InputImageName = 'test.png';
WindowSize = 15;

inputImg = im2double(imread(InputImageName));
[m,n,o] = size(inputImg);

%% Set black spot (test1.jpg)
% inputImg(134:180,165:208,:) = 1; % place a white spot at the target location
% originalImg = inputImg;
% H = [134 180;165 208];
% mask = zeros(m,n);
% mask(H(1,1):H(1,2),H(2,1):H(2,2)) = 1;

%% Set black spot (test.png)
inputImg(37:78,155:182,:) = 1; % place a white spot at the target location
originalImg = inputImg;
H = [37 78;155 182];
mask = zeros(m,n);
mask(H(1,1):H(1,2),H(2,1):H(2,2)) = 1;

%% All Patches
all_patches = find_patches(inputImg,H,WindowSize);
all_patches = all_patches(1:500:end); % discard some patches otherwise too many 

%% PatchMatch
tic
iteration = 5;
NNF = find_NNF(inputImg,iteration,mask,WindowSize);
toc

%% Image completion
tic
[idX, idY] = spiral_browser(inputImg(H(1,1):H(1,2),H(2,1):H(2,2)));
for iter = 1:100
    for p = 1:length(idX)
        p_position = [idX(p)+H(1,1)-1,idY(p)+H(2,1)-1];
        Wi_set = find_Wi_Set(inputImg,p_position,WindowSize);
%         Vi_set = find_Vi_Set(Wi_set,all_patches,p_position,WindowSize);
        Vi_set = PatchMatch(Wi_set,inputImg,NNF,p_position,WindowSize);
        % compute the color C of the pixel by performing a weighted 
        % average of the colors Ci proposed by each patch Vi
        wi_coef = [Vi_set.wi];
        Ci_coef = reshape([Vi_set.color],3,length(wi_coef));
        product = (wi_coef.*Ci_coef)';
        C = sum(product)/sum(wi_coef);
        inputImg(p_position(1),p_position(2),:) = C;
    end
end
toc

%% Display results
figure
subplot(1,2,1)
imshow(originalImg)
subplot(1,2,2)
imshow(inputImg)

%% Compare patches Wi and Vi
% i = 13;
% figure
% subplot(1,2,1)
% imshow(reshape(Wi_set(i).patch,WindowSize,WindowSize,3))
% subplot(1,2,2)
% imshow(reshape(Vi_set(i).patch,WindowSize,WindowSize,3))

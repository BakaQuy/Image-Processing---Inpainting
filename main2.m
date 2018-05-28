clear; close all;
addpath(genpath('Images'));
addpath(genpath('Patchmatch'));
addpath(genpath('Spiral'));
addpath(genpath('Wexler'));

%% Parameters
InputImageName = 'input.jpg';
Database = 'input.jpg';
WindowSize = 11;

inputImg = im2double(imread(InputImageName));
[m,n,o] = size(inputImg);

%% Set black spot (test.png)
H = [134 178;168 209];
mask = zeros(m,n);
mask(H(1,1):H(1,2),H(2,1):H(2,2)) = 1;
% distT = ones(m,n);
% distT(H(1,1):H(1,2),H(2,1):H(2,2)) = 0;
% distT = bwdist(distT);
originalImg = inputImg;
% inputImg(H(1,1):H(1,2),H(2,1):H(2,2),:) = 1; % place a white spot at the target location
% originalImgwhite = inputImg;

%% Pyramid levels
inputImg2 = im2double(imread(Database));
Pyramid(1).D = inputImg2;

inputImg(H(1,1):H(1,2),H(2,1):H(2,2),:) = 1; % place a white spot at the target location
originalImgwhite = inputImg;

% pyramid1 = imresize(inputImg,0.5);
% pyramid2 = imresize(pyramid1,0.5);
% pyramid3 = imresize(pyramid2,0.5);
% 
% H1 = ceil(H/2);
% H2 = ceil(H1/2);
% H3 = ceil(H2/2);
% 
Pyramid(1).H = H;
Pyramid(1).img = inputImg;

%% All Patches
% all_patches = find_patches(inputImg,H,WindowSize);
% all_patches = all_patches(1:1:end); % discard some patches otherwise too many
% inputImg2 = im2double(imread('D.png'));
% all_patches = find_patches(inputImg2,H,WindowSize);

%% PatchMatch
tic
iteration = 7;
NNF = find_NNF(inputImg,iteration,mask,WindowSize);
toc

%% Image completion
for level = 1:length(Pyramid)
    H = Pyramid(level).H;
    inputImg = Pyramid(level).img;
    D = Pyramid(level).D;
    all_patches = find_patches(D,H,WindowSize);
    [m,n,o] = size(inputImg);
    distT = ones(m,n);
    distT(H(1,1):H(1,2),H(2,1):H(2,2)) = 0;
    distT = bwdist(distT);
    [idX, idY] = spiral_browser(inputImg(H(1,1):H(1,2),H(2,1):H(2,2)));
    for iter = 1:1
        for p = 1:length(idX)
            p_position = [idX(p)+H(1,1)-1,idY(p)+H(2,1)-1];
    %     for raw = H(1,1):H(1,2)
    %         for column = H(2,1):H(2,2)
    %         p_position = [raw,column];
            dist = distT(p_position(1),p_position(2));
            Wi_set = find_Wi_Set(inputImg,p_position,WindowSize);
            Vi_set = find_Vi_Set(Wi_set,all_patches,dist,WindowSize);
%             Vi_set = PatchMatch(Wi_set,inputImg,NNF,dist,WindowSize);

            % compute the color C of the pixel by performing a weighted 
            % average of the colors Ci proposed by each patch Vi
            wi_coef = [Vi_set.wi];
            Ci_coef = reshape([Vi_set.color],3,length(wi_coef));
            product = (wi_coef.*Ci_coef)';
            C = sum(product)/sum(wi_coef);
            inputImg(p_position(1),p_position(2),:) = C;
    %         end
        end
    end
    if level < length(Pyramid)
        image_upscaled = imresize(inputImg,2);
        imgTemp = Pyramid(level+1).img;
        HTemp = Pyramid(level+1).H;
        imgTemp(HTemp(1,1):HTemp(1,2),HTemp(2,1):HTemp(2,2)) = image_upscaled(HTemp(1,1):HTemp(1,2),HTemp(2,1):HTemp(2,2));
        Pyramid(level+1).img = imgTemp;
    end
end
toc

%% Display results
figure
subplot(1,3,1)
imshow(originalImgwhite)
subplot(1,3,2)
imshow(originalImg)
subplot(1,3,3)
imshow(inputImg)

%% Compare patches Wi and Vi
% i = 1;
% figure
% subplot(1,2,1)
% imshow(reshape(Wi_set(i).patch,WindowSize,WindowSize,3))
% subplot(1,2,2)
% imshow(reshape(Vi_set(i).patch,WindowSize,WindowSize,3))

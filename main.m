% clear; close all;
InputImageName = 'original.jpg';
WindowSize = 15;

originImg = im2double(imread(InputImageName));
inImg = originImg;
[m,n,o] = size(inImg);

%% set black spot of test1.jpg
inImg(134:180,165:208,:) = 1; % place a white spot at the target location
H = [134 180;165 208];
mask = zeros(m,n);
mask(H(1,1):H(1,2),H(2,1):H(2,2)) = 1;

%% set black spot of test2.jpg
% inImg(228:234,87:120,:) = 1; % place a white spot at the target location
% H = [228 234;87 120];

%% All Patches
% all_patches = find_patches(inImg,H,WindowSize);
% all_patches = all_patches(1:200:end); % discard some patches otherwise too many 

%% PatchMatch
tic
iteration = 10;
NNF = find_NNF(inImg,iteration,WindowSize,mask);
toc
%% Inpainting
whiteImg = inImg;
tic
for raw = 134:180
    for column = 165:208
        p_position = [raw,column];
        Wi_set = find_Wi_Set(inImg,p_position,WindowSize);
%         Vi_set = find_Vi_Set(Wi_set,all_patches,p_position,WindowSize);
        Vi_set = PatchMatch(Wi_set,inImg,NNF,p_position,WindowSize);
        wi_coef = [Vi_set.wi];
        Ci_coef = reshape([Vi_set.color],3,length(wi_coef));
        product = (wi_coef.*Ci_coef)';
        C = sum(product)/sum(wi_coef);
        inImg(p_position(1),p_position(2),:) = C;
    end
end
toc

%% Display results
figure
subplot(1,2,1)
imshow(whiteImg)
subplot(1,2,2)
imshow(inImg)

%% Compare patches Wi and Vi
i = 10;
figure
subplot(1,2,1)
imshow(reshape(Wi_set(i).patch,WindowSize,WindowSize,3))
subplot(1,2,2)
imshow(reshape(Vi_set(i).patch,WindowSize,WindowSize,3))
clear; close all;
tic
InputImageName = 'original.jpg';
WindowSize = 20;

originImg = im2double(imread(InputImageName));
inImg = originImg;

%% set black spot of test1.jpg
inImg(134:180,165:208,:) = 1; % place a white spot at the target location
H = [134 180;165 208];

%% set black spot of test2.jpg
% inImg(228:234,87:120,:) = 1; % place a white spot at the target location
% H = [228 234;87 120];

%% Inpainting
paintedImg = inImg;

all_patches = find_patches(inImg,H,WindowSize);
all_patches = all_patches(1:200:end); % discard some patches otherwise too many 

for raw = 134:134
    for column = 165:208
        p_position = [raw,column]
        Wi_set = find_Wi_Set_up(inImg,p_position,WindowSize);
        Vi_param = find_Vi_param_set(Wi_set,all_patches,p_position,WindowSize);
        wi_coef = [Vi_param.wi];
        Ci_coef = reshape([Vi_param.color],3,WindowSize);
        product = (wi_coef.*Ci_coef)';
        C = sum(product)/sum(wi_coef);
        inImg(p_position(1),p_position(2),:) = C;
    end
end
toc

%% Display results
figure
subplot(1,2,1)
imshow(paintedImg)
subplot(1,2,2)
imshow(inImg)


clear; close all;
tic
InputImageName = 'test3.jpg';
WindowSize = 20;

inImg = im2double(imread(InputImageName));
% inImg(134:180,168:207,:) = 1;
H = [134 180;168 207];

all_patches = find_patches(inImg,H,WindowSize);
all_patches = all_patches(1:200:end);

for raw = 134:180
    for column = 168:168
        p_position = [raw,column]
        Wi_set = find_Wi_Set(inImg,p_position,WindowSize);
        Vi_param = find_Vi_param_set(Wi_set,all_patches,p_position,WindowSize);
        wi_coef = [Vi_param.wi];
        Ci_coef = reshape([Vi_param.color],3,WindowSize^2);
        product = (wi_coef.*Ci_coef)';
        C = sum(product)/sum(wi_coef);
        inImg(p_position(1),p_position(2),:) = C;
    end
end
toc

%%
figure
imshow(inImg);
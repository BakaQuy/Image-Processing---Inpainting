function [output1]= find_NNF(imageA,imageB,iteration,dim_wind,mask)
image=im2double(imageA);
imageb=im2double(imageB);

[m,n,~]=size(image);
norm_matrix=10*ones(m,n);
[mb,nb,~]=size(imageb);
dim=max(mb,nb);
patchSize=dim_wind;


randomOffsetsY = randi([1 mb-patchSize],m-patchSize,n-patchSize);
randomOffsetsX = randi([1 nb-patchSize],m-patchSize,n-patchSize);

%Combine both random matrices to achieve a 2D random pixel map that is
%patchSize smaller than the original image.
for y = 1:size(randomOffsetsY,1)
    for x = 1:size(randomOffsetsX,2)
        if mask(y,x)~=1
            NNF(y,x,:) = [randomOffsetsY(y,x) randomOffsetsX(y,x)];
        else
            NNF(y,x,:)=[1 1];
        end
    end
end

for it=1:iteration
    if mod(it,2) == 1          
        [NNF] = propOdd(imageb, image, patchSize, NNF, mb-patchSize, nb-patchSize,mask);
    else
        [NNF] = propEven(imageb, image, patchSize, NNF, mb-patchSize, nb-patchSize,mask);
    end
end

NNF(:,:,1:2)=NNF(:,:,2:-1:1);
        
output1=NNF;

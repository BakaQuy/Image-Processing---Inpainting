function [output1]= find_NNF(imageA,imageB,iteration,patchSize,mask)

% if ~ismatrix(imageA); image = rgb2gray(imageA); end
% if ~ismatrix(imageB); imageb = rgb2gray(imageB); end
image=im2double(imageA);
imageb=im2double(imageB);

[m,n,~]=size(image);
[mb,nb,~]=size(imageb);

randomYs = randi([1 mb-patchSize+1],m-patchSize+1,n-patchSize+1);
randomXs = randi([1 nb-patchSize+1],m-patchSize+1,n-patchSize+1);

for y = 1:size(randomYs,1)
    for x = 1:size(randomXs,2)
        if mask(y,x)~=1
            NNF(y,x,:) = [randomYs(y,x) randomXs(y,x)];
        else
            NNF(y,x,:)=[1 1];
        end
    end
end

for it=1:iteration
    if mod(it,2) == 1          
         NNF = propOdd(imageb, image, patchSize, NNF, mb-patchSize+1, nb-patchSize+1, mask);
    else
         NNF = propEven(imageb, image, patchSize, NNF, mb-patchSize+1, nb-patchSize+1, mask);
    end
end

NNF(:,:,1:2)=NNF(:,:,2:-1:1);
        
output1=NNF;
        
        
             
                
    

    

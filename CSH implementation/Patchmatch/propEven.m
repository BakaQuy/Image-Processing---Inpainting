function [NNF] = propEven(imgA, imgB, patchSize, NNF, Mb, Nb, mask)


for y=size(NNF,1):-1:1
    for x=size(NNF,2):-1:1
            
        bPatch = imgB(y:y+patchSize-1,x:x+patchSize-1,:);            
        offset=NNF(y,x,:);

        down = NNF(min(y+1,size(NNF,1)), x,:);
        right = NNF(y,min(x+1,size(NNF,2)),:);

        downOffset = [min(max(1,down(1)-1),Mb),down(2)];
        rightOffset = [right(1),min(max(1,right(2)-1),Nb)];

        centerPatch = imgA(offset(1):offset(1)+patchSize-1,offset(2):offset(2)+patchSize-1,:);
        downPatch = imgA(downOffset(1):downOffset(1)+patchSize-1,downOffset(2):downOffset(2)+patchSize-1,:);
        rightPatch = imgA(rightOffset(1):rightOffset(1)+patchSize-1,rightOffset(2):rightOffset(2)+patchSize-1,:);

        errDist=centerPatch(:)-bPatch(:);
        dist = sum(errDist.^2);
    
        errDownDist=downPatch(:)-bPatch(:);
        distDown = sum(errDownDist.^2);

        errRightDist=rightPatch(:)-bPatch(:);
        distRight = sum(errRightDist.^2);


        if distDown < dist && mask(downOffset(1),downOffset(2))~=1
            offset=downOffset;
        end
        if distRight < dist && mask(rightOffset(1),rightOffset(2))~=1
            offset=rightOffset;
        end
        
        NNF(y,x,:) = randomSearch(bPatch, imgA, NNF, y, x, patchSize, offset,mask);
    end
end
end
function [NNF] = propOdd(imgA, imgB, patchSize, NNF, Mb, Nb, mask)

for y=1:size(NNF,1)
    for x=1:size(NNF,2)
            
        bPatch = imgB(y:y+patchSize-1,x:x+patchSize-1,:);
            
        offset=NNF(y,x,:);
        
        up = NNF(max(1,y-1),x,:);
        left = NNF(y,max(1,x-1),:);

        upOffset = [min(max(1,up(1)+1),Mb),up(2)];
        leftOffset = [left(1),min(max(1,left(2)+1),Nb)]; 

        centerPatch = imgA(offset(1):offset(1)+patchSize-1,offset(2):offset(2)+patchSize-1,:);
        upPatch = imgA(upOffset(1):upOffset(1)+patchSize-1,upOffset(2):upOffset(2)+patchSize-1,:);
        leftPatch = imgA(leftOffset(1):leftOffset(1)+patchSize-1,leftOffset(2):leftOffset(2)+patchSize-1,:);

        errDist=centerPatch(:)-bPatch(:);
        dist = sum(errDist.^2);

        errDistUp=upPatch(:)-bPatch(:);
        distUp = sum(errDistUp.^2);

        errDistLeft=leftPatch(:)-bPatch(:);
        distLeft=sum(errDistLeft.^2);
        
        if distUp < dist && mask(upOffset(1),upOffset(2))~=1
            offset=upOffset;
        end
        if distLeft < dist && mask(leftOffset(1),leftOffset(2))~=1
            offset=leftOffset;
        end
        
        NNF(y,x,:) = randomSearch(bPatch, imgA, NNF, y, x, patchSize, offset, mask);
    end
end
end
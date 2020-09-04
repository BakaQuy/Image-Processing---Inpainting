function [offset] = randomSearch(bPatch, imgA, offsets, y, x, patchSize, offset, mask)

iCounter = 0;

w = size(offsets);

a = 0.5;
r = w.*(a.^iCounter);

while (r(1) > 1) && (r(2) > 1)    
    r = round(r);
    ry = randi([-r(1) r(1)]);
    rx = randi([-r(2) r(2)]);
    
    offcoords = [y+ry, x+rx];
    offcoords(1) = min(max(1,offcoords(1)),size(offsets,1));
    offcoords(2) = min(max(1,offcoords(2)),size(offsets,2));
    
    centerPatch = imgA(offset(1):offset(1)+patchSize-1,offset(2):offset(2)+patchSize-1,:);
    err= centerPatch(:)-bPatch(:);
    dist = sum(err.^2);
    
    candOffset = offsets(offcoords(1),offcoords(2),:);
    
    candidatePatch = imgA(candOffset(1):candOffset(1)+patchSize-1,candOffset(2):candOffset(2)+patchSize-1,:);
    errCandi=candidatePatch(:)-bPatch(:);
    candidateDistance= sum(errCandi.^2);
    
    if candidateDistance < dist && mask(candOffset(1),candOffset(2))~=1
        offset = candOffset;
    end
    
    iCounter = iCounter+1;
    r = w.*(a.^iCounter);
end
end
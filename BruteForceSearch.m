function  i2j2 = BruteForceSearch(ij,imageIn,mask,windowSize)
[m,n,~] = size(imageIn);
i0 = ij(1);
j0 = ij(2);
pi0 = i0:i0+windowSize-1;
pj0 = j0:j0+windowSize-1;
patch0 = imageIn(pi0,pj0,:);

prevd = sum( (zeros(windowSize,windowSize)-ones(windowSize,windowSize)).^2 );
for i = 1:m-windowSize+1
    for j = 1:n-windowSize+1
        pi = i:i+windowSize-1;
        pj = j:j+windowSize-1;
        MTemp = mask(pi,pj);
        if any(MTemp(:) == 1)
            patch = imageIn(pi,pj,:);
            d = sum( (patch(:)-patch0(:)).^2 );
            if d < prevd
                i2j2 = [i,j];
                prevd = d;
            end
        end
    end
end
end
function  imageOut = FinalReconstruction(imageIn,mask,windowSize,iterations,csh_iterations)
I = imageIn;
M = mask;
M(M>0)=1;

[m,n,~] = size(I);
M3 = repmat(M,[1 1 3])==1;
distT = bwdist(~M);

for iter = 1:iterations
    imshow(I);
    title(sprintf('Completion...\nFinal Scale\nIteration %2d/%2d',iter,iterations));
    pause(0.001)

    D = I;
    D(M3)=0;    % Build data base D for Patchmatch
    R = zeros(size(I));
    Rcount = 10*ones(m,n);

    % Compute NN field
    %%% PUT PATCHMATCH
    CSH_ann = CSH_nn(I,D,windowSize,csh_iterations,1,0,M); % Use Patchmacth to compute NNF
    %CSH_ann = find_NNF(I,D,csh_iterations,windowSize);
    %%%

    % Convert the image I to double precision for computation
    I = double(I)./255;
    for i = 1:m-windowSize+1
        for j = 1:n-windowSize+1
            pi = i:i+windowSize-1;
            pj = j:j+windowSize-1;
            MTemp = M(pi,pj);
            if any(MTemp(:) == 1)
                patch = I(pi,pj,:);
                
                i2 = CSH_ann(i,j,2);
                j2 = CSH_ann(i,j,1);
                
%                 i2j2 = BruteForceSearch([i,j],I,M,windowSize);
%                 i2 = i2j2(1);
%                 j2 = i2j2(2);
                
                pi2 = i2:i2+windowSize-1;
                pj2 = j2:j2+windowSize-1;
                patch2 = I(pi2,pj2,:);

                distTemp = distT(pi,pj)+1;
                distTemp = repmat(distTemp,[1 1 3]);
                d = sum( distTemp(:).*(patch(:)-patch2(:)).^2);
                RcountToUpdate = Rcount(pi,pj)>=d;
                Rcount(pi,pj) = Rcount(pi,pj).*~RcountToUpdate;
                Rcount(pi,pj) = Rcount(pi,pj)+d*RcountToUpdate;
                R(pi,pj,:) = R(pi,pj,:).*~RcountToUpdate;
                R(pi,pj,:) = R(pi,pj,:) + RcountToUpdate.*patch2; 
            end
        end
    end 
    R(~M3)=I(~M3);
    I = uint8(255*R);
end
imageOut = I;
end
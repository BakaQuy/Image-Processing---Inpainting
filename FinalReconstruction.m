function  imageOut = FinalReconstruction(imageIn,mask,windowSize,iterations)
%% CSH parameter
csh_iterations = 10;
calcBnn = 0;


% Scale image to firstScale
I = imageIn; % Scale imageIn and store it in I
M = mask;  % Scale mask
M(M>0)=1;

[m,n,~] = size(I);
M3 = repmat(M,[1 1 3])==1;
distT = bwdist(~M);

fprintf('Final Scale\n');

for iter = 1:iterations
    fprintf('  Iteration %2d/%2d',iter,iterations);
    imshow(I);
    title(sprintf('En recontruction...\nFinal Scale\nIteration %2d/%2d',iter,iterations));
    pause(0.001)

    D = I;
    D(M3)=0;
    R = zeros(size(I));
    Rcount = 10*ones(m,n);

    %Compute NN field
    CSH_ann = CSH_nn(I,D,windowSize,csh_iterations,1,calcBnn,M);

    %Now be work in double precision
    I = double(I)./255;

    %Create new image by letting each patch vote
    for i = 1:m-windowSize+1
        for j = 1:n-windowSize+1
            pi = i:i+windowSize-1;
            pj = j:j+windowSize-1;
            MTemp = M(pi,pj);
            if any(MTemp(:) == 1)
                patch = I(pi,pj,:);
                i2 = CSH_ann(i,j,2);
                j2 = CSH_ann(i,j,1);
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

    %Convert back to uint8
    I = uint8(255*R);
end
imageOut = I;
end
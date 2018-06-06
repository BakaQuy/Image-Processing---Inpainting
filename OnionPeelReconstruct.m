function  imageOut = OnionPeelReconstruct(imageIn,mask,windowSize)
%% CSH parameter
csh_iterations = 10;
calcBnn = 0;

%% Pyramid level scaling
% Starting scale
[m,n,~] = size(imageIn);
firstScale = -ceil(log2(min(m,n))) + 5;
scale = 2^(firstScale);

% Scale image to firstScale
I = imresize(imageIn,scale); % Scale imageIn and store it in I
M = imresize(mask,scale);   % Scale mask
M(M>0)=1;

%% Reconstruc in the onion way
[m,n,~] = size(I);
M3 = repmat(M,[1 1 3])==1;
distT = bwdist(~M); % Compute distance transform matrix
D = I;  
D(M3)=0;    % Build data base D for Patchmatch
I(M3)=255;  % Replace the hole area by white pixels
imshow(I)
pause(0.001)

CSH_ann = CSH_nn(I,D,windowSize,csh_iterations,1,calcBnn,M); % Use Patchmacth to compute NNF
I = double(I)./255; % Convert the image I to double precision
for o = 1:ceil(max(distT(:))) % Reconstruct the oclusion area starting from the boundaries  
    k = 1;
    R = zeros(size(I));
    Rcount = zeros(m,n);
    Rdata = zeros(1,5);
    for i = 1:m-windowSize+1
        for j = 1:n-windowSize+1
            pi = i:i+windowSize-1;
            pj = j:j+windowSize-1;
            distTemp = distT(pi,pj);
            if any(ceil(distTemp(:)==o)) && ~any(ceil(distTemp(:)==o+1))
                patch = I(pi,pj,:);
                i2 = CSH_ann(i,j,2);
                j2 = CSH_ann(i,j,1);
                pi2 = i2:i2+windowSize-1;
                pj2 = j2:j2+windowSize-1;
                patch2 = I(pi2,pj2,:);
                
                M2 = ~(distTemp==o);
                patch = patch.*M2;
                patch2temp = patch2.*M2;
    
                d = sum( (patch(:)-patch2temp(:)).^2 );
                Rdata(k,1:4) = [i,j,i2,j2];
                Rdata(k,5) = d;
                k = k+1;
            end
        end
    end
    sigma = prctile(Rdata(:,5),75);
    Rdata(:,5) = exp( -Rdata(:,5) / (2*sigma^2) );
    for raw = 1:k-1
       pi = Rdata(raw,1):Rdata(raw,1)+windowSize-1;
       pj = Rdata(raw,2):Rdata(raw,2)+windowSize-1;
       pi2 = Rdata(raw,3):Rdata(raw,3)+windowSize-1;
       pj2 = Rdata(raw,4):Rdata(raw,4)+windowSize-1;
       R(pi,pj,:) = R(pi,pj,:) + Rdata(raw,5).*I(pi2,pj2,:);
       Rcount(pi,pj) = Rcount(pi,pj) + Rdata(raw,5);
    end
    % Normalize and divide (NUM/DEM)
    Rcount = repmat(Rcount,[1 1 3]);
    R(Rcount>0) = R(Rcount>0) ./ Rcount(Rcount>0);
    % Keep pixels outside mask
    R(~M3) = I(~M3);
    I = R;
    imshow(I)
    pause(0.001)
end
I = uint8(255*I);

[m,n,~] = size(imageIn);
I = imresize(I,[m n]);

M3 = repmat(mask,[1 1 3])==1;

%Outside mask, I is equal to original image
I(~M3) = imageIn(~M3);
imageOut = I;
end

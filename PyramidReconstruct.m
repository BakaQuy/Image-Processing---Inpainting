function  imageOut = PyramidReconstruct(imageIn,mask,windowSize,iterations,thresholdScale)
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

[m,n,~] = size(I);
M3 = repmat(M,[1 1 3])==1;
for logscale = firstScale:-1
    scale = 2^(logscale);
    
    fprintf('Scale = 2^%d\n',logscale);

    for iter = 1:iterations
        fprintf('  Iteration %2d/%2d',iter,iterations);
        imshow(I);
        title(sprintf('En recontruction...\nScale = %d\nIteration %2d/%2d',-logscale,iter,iterations));
        pause(0.001)
        
        D = I;
        D(M3)=0;
        R = zeros(size(I));
        Rcount = zeros(m,n);
        Rdata = zeros(1,5);
        k = 1;
        
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
                    
                    d = sum( (patch(:)-patch2(:)).^2 );
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
        R(~M3)=I(~M3);
        
        %Convert back to uint8
        Iprev = 255*I;
        I = uint8(255*R);
        if iter>1
            %Measure how much image has changed
            diff = sum( (double(I(:))-double(Iprev(:))).^2 ) / sum(M(:)>0);
                fprintf(' diff = %f\n',diff);
            %Stop iterating if change is low
            if diff < thresholdScale
                break;
            end
        else
            fprintf('\n');
        end
    end
    
    %Upsample I for the next scale
    if logscale < 0
        Idata = imresize(imageIn,2*scale);
        [m,n,~] = size(Idata);
        I = imresize(I,[m n]);
        
        M = imresize(mask,[m n]);
        M(M>0)=1;
        M3 = repmat(M,[1 1 3])==1;

        %Outside mask, I is equal to original image
        I(~M3) = Idata(~M3);
    end
end
imageOut = I;
end
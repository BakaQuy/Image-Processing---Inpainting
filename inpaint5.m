function A = inpaint5(Aorg,Morg) 
%% Plot
subplot(1, 3, 1);
imshow(Aorg);
subplot(1, 3, 2);
imshow(Morg);
subplot(1, 3, 3);

% Also accept RGB masks, but only use first channel
verbose = true;
if size(Morg,3) > 1
    Morg = Morg(:,:,1);
end

width = 8;
csh_iterations = 5;
k = 1;
calcBnn = 0;

% Maximum number of iterations on this scale;
% oscillations are possible
iterations = 10;
diffthresh = 1;

%% Pyramid levels
% Determinte starting scale
[m,n,rgb] = size(Aorg);
startscale = -ceil(log2(min(m,n))) + 5;
scale = 2^(startscale);

% Resize image to starting scale
A = imresize(Aorg,scale);
M = imresize(Morg,scale);
M(M>0)=1;
M3 = repmat(M,[1 1 3])==1;

%% Initialization
[m,n,rgb] = size(A);

%% Onion-peel init
distT = bwdist(~M);
B = A;
B(M3)=0;
A(M3)=255;
CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
A = double(A)./255;
for o = 1:max(distT(:))
    k = 1;
    R = zeros(size(A));
    Rcount = zeros(m,n);
    Rdata = zeros(1,5);
    for i = 1:m-width+1
        for j = 1:n-width+1
            pi = i:i+width-1;
            pj = j:j+width-1;
            distTemp = distT(pi,pj);
            if any(distTemp(:)==o) && ~any(distTemp(:)==o+1)
                patch = A(pi,pj,:);
                i2 = CSH_ann(i,j,2);
                j2 = CSH_ann(i,j,1);
                pi2 = i2:i2+width-1;
                pj2 = j2:j2+width-1;
                patch2 = A(pi2,pj2,:);
                
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
       pi = Rdata(raw,1):Rdata(raw,1)+width-1;
       pj = Rdata(raw,2):Rdata(raw,2)+width-1;
       pi2 = Rdata(raw,3):Rdata(raw,3)+width-1;
       pj2 = Rdata(raw,4):Rdata(raw,4)+width-1;
       R(pi,pj,:) = R(pi,pj,:) + Rdata(raw,5).*A(pi2,pj2,:);
       Rcount(pi,pj) = Rcount(pi,pj) + Rdata(raw,5);
    end
    % Normalize and 
    Rcount = repmat(Rcount,[1 1 3]);
    R(Rcount>0) = R(Rcount>0) ./ Rcount(Rcount>0);
    % Keep pixels outside mask
    R(~M3)=A(~M3);
    % Convert back to uint8
    A = R;
end
A = uint8(255*A);

%% Go through all scales
for logscale = startscale:0
    distT = bwdist(~M);
    scale = 2^(logscale);
    
    if verbose
        fprintf('Scale = 2^%d\n',logscale);
    end
    if logscale == 0
        iterations = 1;
    end
    for iter = 1:iterations
        if verbose
            fprintf('  Iteration %2d/%2d',iter,iterations);
            imshow(A);
            title(sprintf('En recontruction...\nScale = %d\nIteration %2d/%2d',-logscale,iter,iterations));
            pause(0.001)
        end
        
        B = A;
        B(M3)=0;
        R = zeros(size(A));
        Rcount = zeros(m,n);
        Rdata = zeros(1,5);
        k = 1;
        if logscale == 0
            Rcount = 10*ones(m,n);
        end
        
        %Compute NN field
        CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
        
        %Now be work in double precision
        A = double(A)./255;
        
        %Create new image by letting each patch vote
        for i = 1:m-width+1
            for j = 1:n-width+1
                pi = i:i+width-1;
                pj = j:j+width-1;
                MTemp = M(pi,pj);
                if any(MTemp(:) == 1)
                    patch = A(pi,pj,:);
                    i2 = CSH_ann(i,j,2);
                    j2 = CSH_ann(i,j,1);
                    pi2 = i2:i2+width-1;
                    pj2 = j2:j2+width-1;
                    patch2 = A(pi2,pj2,:);
                    
                    if logscale ~= 0
                        d = sum( (patch(:)-patch2(:)).^2 );
                        Rdata(k,1:4) = [i,j,i2,j2];
                        Rdata(k,5) = d;
                        k = k+1;
                    else
                        distTemp = distT(pi,pj)+1;
                        distTemp = repmat(distTemp,[1 1 3]);
                        d = sum( distTemp(:).*(patch(:)-patch2(:)).^2);
                        RcountToUpdate = Rcount(pi,pj)>=d;
                        Rcount(pi,pj) = Rcount(pi,pj).*~RcountToUpdate;
                        Rcount(pi,pj) = Rcount(pi,pj)+d*RcountToUpdate;
                        R(pi,pj,:) = R(pi,pj,:).*~RcountToUpdate;
                        R(pi,pj,:) = R(pi,pj,:) + RcountToUpdate.*patch2;
%                         R(pi,pj,:) = patch2;
                    end    
                end
            end
        end
        if logscale ~= 0
            sigma = prctile(Rdata(:,5),75);
            Rdata(:,5) = exp( -Rdata(:,5) / (2*sigma^2) );
            for raw = 1:k-1
               pi = Rdata(raw,1):Rdata(raw,1)+width-1;
               pj = Rdata(raw,2):Rdata(raw,2)+width-1;
               pi2 = Rdata(raw,3):Rdata(raw,3)+width-1;
               pj2 = Rdata(raw,4):Rdata(raw,4)+width-1;
               R(pi,pj,:) = R(pi,pj,:) + Rdata(raw,5).*A(pi2,pj2,:);
               Rcount(pi,pj) = Rcount(pi,pj) + Rdata(raw,5);
            end
            % Normalize and 
            Rcount = repmat(Rcount,[1 1 3]);
            R(Rcount>0) = R(Rcount>0) ./ Rcount(Rcount>0);
            % Keep pixels outside mask
        end    
        R(~M3)=A(~M3);
        
        %Convert back to uint8
        Aprev = 255*A;
        A = uint8(255*R);
        if iter>1
            %Measure how much image has changed
            diff = sum( (double(A(:))-double(Aprev(:))).^2 ) / sum(M(:)>0);
            if verbose
                fprintf(' diff = %f\n',diff);
            end
            %Stop iterating if change is low
            if diff < diffthresh 
                break;
            end
        elseif verbose
            fprintf('\n');
        end
    end
    
    %Upsample A for the next scale
    if logscale < 0
        Adata = imresize(Aorg,2*scale);
        [m,n,rgb] = size(Adata);
        A = imresize(A,[m n]);
        
        M = imresize(Morg,[m n]);
        M(M>0)=1;
        M3 = repmat(M,[1 1 3])==1;

        %Outside mask, A is equal to original image
        A(~M3) = Adata(~M3);
    end
end

%% Final reconstruction
% logscale = 0;
% scale = 2^(logscale);
% 
% if verbose
%     fprintf('Scale = 2^%d\n',logscale);
% end
% distT = bwdist(~M);
% for iter = 1:iterations
%     if verbose
%         fprintf('  Iteration %2d/%2d',iter,iterations);
%         imshow(A);
%         pause(0.001)
%     end
% 
%     B = A;
%     B(M3)=0;
%     R = zeros(size(A));
%     Rcount = ones(m,n);
%     
%     %Compute NN field
%     tic
%     CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
%     toc
% 
%     %Now be work in double precision
%     A = double(A)./255;

%%
%     logscale = 0;
%     scale = 2^(logscale);
%     
%     if verbose
%         fprintf('Scale = 2^%d\n',logscale);
%     end
%     distT = bwdist(~M);
%     for iter = 1:iterations
%         if verbose
%             fprintf('  Iteration %2d/%2d',iter,iterations);
%             imshow(A);
%             pause(0.001)
%         end
%         
%         B = A;
%         B(M3)=0;
%         R = zeros(size(A));
%         Rcount = zeros(m,n);
%         Rdata = zeros(1,5);
%         k = 1;
%         
%         %Compute NN field
%         tic
%         CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
%         toc
%         
%         %Now be work in double precision
%         A = double(A)./255;

%     %Create new image by letting each patch vote
%     for i = 1:m-width+1
%         for j = 1:n-width+1
%             pi = i:i+width-1;
%             pj = j:j+width-1;
%             MTemp = M(pi,pj);
%             if any(MTemp(:) == 1)
%                 patch = A(pi,pj,:);
%                 i2 = CSH_ann(i,j,2);
%                 j2 = CSH_ann(i,j,1);
%                 pi2 = i2:i2+width-1;
%                 pj2 = j2:j2+width-1;
%                 patch2 = A(pi2,pj2,:);
% 
%                 distTemp = distT(pi,pj);
%                 distTemp = repmat(distTemp,[1 1 3]);
%                 d = sum( distTemp(:).*((patch(:)-patch2(:)).^2) );
%                 RcountToUpdate = Rcount(pi,pj)>d;
%                 Rcount(pi,pj) = Rcount(pi,pj).*~RcountToUpdate;
%                 Rcount(pi,pj) = Rcount(pi,pj)+d*RcountToUpdate;
%                 R(pi,pj,:) = R(pi,pj,:).*~RcountToUpdate;
%                 R(pi,pj,:) = R(pi,pj,:) + RcountToUpdate.*patch2;
%                 R(pi,pj,:) = patch2;
%             end
%         end
%     end
% 
%     %Keep pixels outside mask
%     R(~M3)=A(~M3);
%     %Convert back to uint8
%     Aprev = 255*A;
%     A = uint8(255*R);
% 
%     if iter>1
%         %Measure how much image has changed
%         diff = sum( (double(A(:))-double(Aprev(:))).^2 ) / sum(M(:)>0);
%         if verbose
%             fprintf(' diff = %f\n',diff);
%         end
%         %Stop iterating if change is low
%         if diff < diffthresh 
%             break;
%         end
%     elseif verbose
%         fprintf('\n');
%     end
end
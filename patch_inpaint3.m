function A = patch_inpaint3(Aorg,Morg, verbose, sigma) 
%% Parameters
if nargin < 3
    verbose = true;
end
if nargin < 4
    sigma = 0.25;
end

if ~exist('CSH_nn.m','file')
    error('CSH_nn not found. Please download and add to path:  http://www.eng.tau.ac.il/~simonk/CSH/index.html');
end

% Also accept RGB masks, but only use first channel
if size(Morg,3) > 1
    Morg = Morg(:,:,1);
end

width = 8;
csh_iterations = 10;
k = 1;
calcBnn = 0;

% Maximum number of iterations on this scale;
% oscillations are possible
iterations = 20;
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

% Random starting guess for inpainted image
% Rnd = uint8(255*rand(m,n,rgb));
% A(M3) = Rnd(M3);

% Onion-peel init
distT = bwdist(~M);
B = A;
B(M3)=0;
A(M3)=255;
figure
imshow(A);

CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
A = double(A)./255;
R = zeros(size(A));
Rcount = zeros(m,n);
for o = 1:max(distT(:))
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
                patch2index = M(pi2,pj2);
                
                M2 = ~M(pi,pj);
                patch = patch.*M2;
                patch2temp = patch2.*M2;
                
                if any(patch2index(:)==1)
                   disp('pas bon1') 
                end
    
                d = sum( (patch(:)-patch2temp(:)).^2 );
                sim = exp( -d / (2*sigma^2) );

                R(pi,pj,:) = R(pi,pj,:) + sim*patch2;
                Rcount(pi,pj) = Rcount(pi,pj) + sim;
            end
        end
    end
end
Rcount = repmat(Rcount,[1 1 3]);
R(Rcount>0) = R(Rcount>0) ./ Rcount(Rcount>0);
R(~M3)=A(~M3);
A = uint8(255*R);
figure
imshow(A);

% Go through all scales
for logscale = startscale:-1

    scale = 2^(logscale);
    
    if verbose
        fprintf('Scale = 2^%d\n',logscale);
    end
    
    for iter = 1:iterations
        if verbose
            fprintf('  Iteration %2d/%2d',iter,iterations);
            imshow(A);
            pause(0.001)
        end
        
        B = A;
        B(M3)=0;
        
        %Compute NN field
        tic
        CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);
        toc
        
        %Now be work in double precision
        A = double(A)./255;
        
        %Create new image by letting each patch vote
        R = zeros(size(A));
        Rcount = zeros(m,n);
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
                    patch2index = M(pi2,pj2);
                    if any(patch2index(:)==1)
                       disp('pas bon') 
                    end

                    d = sum( (patch(:)-patch2(:)).^2 );
                    sim = exp( -d / (2*sigma^2) );

                    R(pi,pj,:) = R(pi,pj,:) + sim*patch2;
                    Rcount(pi,pj) = Rcount(pi,pj) + sim;
                end
            end
        end

        %Normalize and 
        Rcount = repmat(Rcount,[1 1 3]);
        R(Rcount>0) = R(Rcount>0) ./ Rcount(Rcount>0);
        %Keep pixels outside mask
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

logscale = 0;
    scale = 2^(logscale);
    
    if verbose
        fprintf('Scale = 2^%d\n',logscale);
    end
    
    for iter = 1:10
        if verbose
            fprintf('  Iteration %2d/%2d',iter,iterations);
            imshow(A);
            pause(0.001)
        end
        
        B = A;
        B(M3)=0;
        
        %Compute NN field
        CSH_ann = CSH_nn(A,B,width,csh_iterations,k,calcBnn,M);

        %Now be work in double precision
        A = double(A)./255;
        
        %Create new image by letting each patch vote
        R = zeros(size(A));
        k = 1;
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
                    patch2index = M(pi2,pj2);
                    if any(patch2index(:)==1)
                       disp('pas bon') 
                    end
                    
                    R(pi,pj,:) = patch2;
                end
            end
        end
        
%         for i = 1:m
%             for j = 1:n
%                 if M(i,j) == 1
%                     [~,maxK] = max(Rcount(i,j,:));
%                     R(i,j,:) = R2(i,j,:,maxK);
%                 end
%             end
%         end
                
        %Keep pixels outside mask
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
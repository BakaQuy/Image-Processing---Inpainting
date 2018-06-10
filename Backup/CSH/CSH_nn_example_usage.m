% example usage for CSH_nn function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear
clc

dbstop if error

% don't forget to compile your mex-files first (only once, hence commented out here):
% compile_mex

AddPaths

fprintf('CSH algorithm example script!!!\r\n');
fprintf('*******************************\r\n');


%% preparing the images
img1 = 'Saba1.bmp';
img2 = 'Saba2.bmp';

A = imread(img1);
B = imread(img2);

[hA,wA,dA] = size(A);
[hB,wB,dB] = size(B);

mpa = floor(hB*wB/1000) / 1000;
mpb = floor(hB*wB/1000) / 1000;

MP_A_Str = [num2str(mpa) ' MP'];
MP_B_Str = [num2str(mpb) ' MP'];

fprintf('Image A: %s, size = %s\r\n', img1 , MP_A_Str);
fprintf('Image B: %s, size = %s\r\n', img2 , MP_B_Str);


%% warmup
fprintf('\n--> Dummy run to warmup . . .  ');
CSH_ann = CSH_nn(A,B); %#ok<NASGU>
fprintf('Done!!\r\n');


%% video run
if 0 % doesn't work now
    A = imresize(A,0.4);
    B = imresize(B,0.4);
    A = repmat(A,[1 1 1 8]);
    B = repmat(B,[1 1 1 16]);
    fprintf('Dummy run to warmup...');
    video_width = 4;
    CSH_ann = CSH_nn(A,B,video_width);
    fprintf('Done!!\r\n');
    
    keyboard
end


%% Initialize random seed (this is useful mainly for debugging)
rng(12345689);


%% Example 1: using default defaults to show mapping - and showing reconstruction
%               of A from B, based on PM votemex code
fprintf('\n=== Example 1: =====================================\n');
fprintf('-------> Runing CSH_nn example with default parameter values\r\n');
CSH_TIC_A2B = tic;
%%%%%% CSH RUN %%%%%%%
CSH_ann = CSH_nn(A,B);
%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn elapsed time: %.3f[s]\r\n' , CSH_TOC);

width = 8; % Default patch width value
[errImg,avgErr] = PlotExampleResults(A,B,CSH_ann,width,1,[],'default CSH');    

% reconstruction
c_style_CSH_ann = AnnFromMatlab2c(cat(3,CSH_ann,padarray(errImg,[width-1,width-1,0],0,'post')));

% the PatchMatch reconstruction function
CSH_A_fromB = votemex(B, c_style_CSH_ann, [], 'cpu', width);

VisualizeReconstruction(A,CSH_A_fromB,'CSH','saba',width,'Reconstruction');


%% Example 2: run CSH with user defined parameters settings
keyboard; 
close all

width = 4;
iterations = 4;
k = 1;
fprintf('\n=== Example 2: =====================================\n');
fprintf('-------> Runing CSH_nn example: width = %d, iterations = %d, k = %d\r\n',width,iterations,k);
CSH_TIC_A2B = tic;
%%%%%% CSH RUN %%%%%%%
CSH_ann = CSH_nn(A,B,width,iterations,k,0);
%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn elapsed time: %.3f[s]\r\n' , CSH_TOC);
PlotExampleResults(A,B,CSH_ann,width,k,[],'CSH with user parameters');


%% Example 3: run CSH for KNN mapping - regular case (small k)
keyboard; 
close all

width = 8;
iterations = 3;
k = 8;
fprintf('\n=== Example 3: =====================================\n');
fprintf('-------> Runing CSH_nn example for (regular) KNN (K = %d) demonstration\r\n',k);
CSH_TIC_A2B = tic;
%%%%%% CSH RUN %%%%%%%
CSH_knn = CSH_nn(A,B,width,iterations,k);

%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn elapsed time: %.3f[s]\r\n' , CSH_TOC);
PlotExampleResults(A,B,CSH_knn,width,k,[],'CSH in KNN mode');


%% Example 4: run CSH for KNN mapping - large k ('fast' version)
keyboard; 
close all

width = 8;
iterations = 3;
k = 100;
fprintf('\n=== Example 4: =====================================\n');
fprintf('-------> Runing CSH_nn example for ''fast'' KNN (large K = %d) demonstration\n',k);
fprintf('-------> (shown here on a SMALLER version of image A)\n');
sA = imresize(A,0.5);
CSH_TIC_A2B = tic;
%%%%%% CSH RUN %%%%%%%
[CSH_knn,~,KNN_extraInfo] = CSH_nn(sA,sA,width,iterations,k,0,[],[],[],[],1);

% Note we run here from A to A, but it can work for A to B just as well

% Note - In this case of fastKNN:
% 1] We compute the erros as part of the computation: KNN_extraInfo.sortedErrors
% 2] We return the number of unique NNs per patch (for some patches, the X last NNs are duplicates): KNN_extraInfo.numUniqueResultsPerPixel
% outputting this:
f = figure;
subplot 221; imagesc(KNN_extraInfo.numUniqueResultsPerPixel); colorbar; axis image
title(['number of distinct NNs per patch (target was ' num2str(k) ')']);
subplot 222; hist(KNN_extraInfo.numUniqueResultsPerPixel(:),100); 
title(['hist of number of distinct NNs per patch']); 
meanSortedErrorsImage = mean(KNN_extraInfo.sortedErrors(1:end-(width-1),1:end-(width-1),:),3);
subplot 223; imagesc(meanSortedErrorsImage); colorbar; axis image
title(['mean erros image, with overall mean of: ' num2str(mean2(meanSortedErrorsImage))]);
set(f,'name','fastKNN extra info');
%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn elapsed time: %.3f[s]\r\n' , CSH_TOC);
PlotExampleResults(sA,sA,CSH_knn,width,k,[],'CSH in KNN mode');


%% Example 5: run CSH ANN with mask
keyboard; 
close all

width = 8;
iterations = 3;
k = 1;
fprintf('\n=== Example 5: =====================================\n');
fprintf('-------> Runing CSH_nn example with mask\r\n');

mask = zeros(hB,wB);
mask(round(hB/4):round(hB*3/4),round(wB*2/5):round(wB*4/5)) = 1; % Mark the patches that are NOT used for mapping
% mask(round(hB/54):round(hB*53/54),round(wB/54):round(wB*53/54)) = 1; % Mark the patches that are NOT used for mapping

CSH_TIC_A2B = tic;
%%%%%% CSH RUN %%%%%%%
CSH_ann = CSH_nn(A,B,width,iterations,k,0,mask);
%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn elapsed time: %.3f[s]\r\n' , CSH_TOC);
PlotExampleResults(A,B,CSH_ann,width,k,mask,'CSH with masked area');


%% Example 6: run bidirectional CSH
% here we can see how to save time by running simultaneously in both directions
% in order to save in memory - we get a slightly worse B2A
keyboard; 
close all

width = 8;
iterations = 2;
k = 1;
fprintf('\n=== Example 6: =====================================\n');
fprintf('-------> Runing CSH_nn example with bidirectional mapping (compared to both ways separately)\r\n');

% Initialize random seed (this is useful mainly for debugging)
rng(123456789);

% comparing to 2 x unidirectional first:
CSH_TIC_A2B = tic;
[CSH_ann_uni] = CSH_nn(A,B,width,iterations,k,0);
CSH_TOC = toc(CSH_TIC_A2B);
fprintf('   CSH_nn A=>B elapsed time: %.3f[s]\r\n' , CSH_TOC);

CSH_TIC_B2A = tic;
[CSH_bnn_uni] = CSH_nn(B,A,width,iterations,k,0);
CSH_TOC = toc(CSH_TIC_B2A);
fprintf('   CSH_nn B=>A elapsed time: %.3f[s]\r\n' , CSH_TOC);

PlotExampleResults(A,B,CSH_ann_uni,width,k,[],'unidirectional CSH: A 2 B');
PlotExampleResults(B,A,CSH_bnn_uni,width,k,[],'unidirectional CSH: B 2 A');

% Initialize random seed (this is useful mainly for debugging)
rng(123456789);

% and the bidirectional version (which is faster due to shared computations):

CSH_TIC_A2B2A = tic;
%%%%%% CSH RUN %%%%%%%
calcBnn = 1;
[CSH_ann,CSH_bnn] = CSH_nn(A,B,width,iterations,k,calcBnn);
%%%%%%%%%%%%%%%%%%%%%%
CSH_TOC = toc(CSH_TIC_A2B2A);
fprintf('   CSH_nn bidirectional (A=>B,A=>B) elapsed time: %.3f[s]\r\n' , CSH_TOC);

PlotExampleResults(A,B,CSH_ann,width,k,[],'bidirectional CSH: A 2 B');
PlotExampleResults(B,A,CSH_bnn,width,k,[],'bidirectional CSH: B 2 A');

keyboard

% E O F

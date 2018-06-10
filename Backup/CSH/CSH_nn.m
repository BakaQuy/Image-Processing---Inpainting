function [CSH_ann,CSH_bnn,KNN_extraInfo] = ...
    CSH_nn(A,B,... % basic params - can handle only these (rest can be default)
    width,iterations,k,calcBnn,bMask,patch_mode,distFromIdentity,patch_params,fastKNN) % additional important params
% CSH_NN - Coherence Sensitive Hashing algorithm
%
% usage: nnf = CSH_nn(A,B,[width=8],[iterations=5],[k=1],[width=8],[calcBnn=0],[bMask=[]])
%
% This function runs the CSH (Coherence Sensitive Hashing) algorithm
% to compute the (dense) nearest neighbor field between images A and B
% -----------------------------------------------------------------------------------------------------------------
%
% Inputs:
% - - - - - - -
% 1] A - an RGB image, the source of the NN field.
% 2] B - an RGB image, the destination of the NN field.
% 3] width -  the dimension [in pixels] of a  patch. Supported values are [2,4,8,16,32]
% 4] iterations - iterations algorithm.
% 5] k - as in k-nearest-neighbors, default is 1
% 6] calcBnn - calculated bnn as well as ann
% 7] bMask - mask on the target image, where to take the candidates from: 0 = use patch and 1 = hole.
%
% Outputs:
% - - - - - - - -
% 1] CSH_ann - the nearest neighbor field from A to B, which is of size (hA,wA,2) where
%                        * [hA,wA] are the height and width of A
%                        * ann(i,j,1) and ann(i,j,2) are the (top-left-corner) [x,y] indices in B that the patch
%                          in A with top-left-corner at [j,i] is mapped to
% 2] CSH_bnn - same, but in the other direction

if (nargin < 2), error('too few inputs'); end

if (~exist('width','var')), width = 8; end

if (~exist('iterations','var')), iterations = 5; end

if (~exist('k','var')), k = 1; end

if (~exist('calcBnn','var')), calcBnn = 0; end

if (~exist('bMask','var')), bMask = []; end

if (~exist('patch_mode','var')) || isempty(patch_mode), patch_mode = 0; end

if (floor(log2(width)) ~= log2(width)), error('width must be a power of 2'); end


%% A] PREPARATIONS

% 1) CSH - parameters preparation and packing
% --------------------------------------------
numHashs = 2; % width of hash table
TLboundary = 2*width;
BRboundary = width;
br_boundary_to_ignore = width;
maxKernels = floor((log2(width))^2)*3; % 3 is the number of channels (Y, Cb, Cr)
if (~exist('distFromIdentity') || isempty(distFromIdentity))
    distFromIdentity = 0;% this is for CSH that keeps 'distFromIdentity' pixels in x or y away from identity
end

HashingSchemeParams.width = width;
HashingSchemeParams.descriptor_params.descriptor_mode = 0;

HashingSchemeParams.dist = distFromIdentity;
HashingSchemeParams.maxKernels = maxKernels;
HashingSchemeParams.useTicsInside = 0;
HashingSchemeParams.TLboundary = TLboundary;
HashingSchemeParams.BRboundary = BRboundary;
HashingSchemeParams.br_boundary_to_ignore = br_boundary_to_ignore;
HashingSchemeParams.numHashTables = iterations;
HashingSchemeParams.numHashs = numHashs;
HashingSchemeParams.insideInfo = 0;
HashingSchemeParams.DebugCalcErrors = 0;

if (exist('patch_mode','var') && patch_mode)
    HashingSchemeParams.descriptor_params.hA = patch_params.hA + width -1; % adding width-1 to create an image that includes last patch's pixels
    HashingSchemeParams.descriptor_params.wA = patch_params.wA + width -1;
    HashingSchemeParams.descriptor_params.dA = patch_params.dA;
    HashingSchemeParams.descriptor_params.hB = patch_params.hB + width -1;
    HashingSchemeParams.descriptor_params.wB = patch_params.wB + width -1;
    HashingSchemeParams.descriptor_params.dB = patch_params.dB;
    HashingSchemeParams.descriptor_params.rotation_invariant = patch_params.rotation_invariant;
end


%% B] MAIN CALL TO algorithm

KNN_extraInfo = [];

if (size(A,4)>1)
    filepath_DATA = 'database\self denoising\tennis_20 k=25 iterations=6 gray_scale 20 bits';
    [CSH_ann,CSH_bnn]= HashingSchemeNew_VIDEO(A,B,filepath_DATA,k,calcBnn,HashingSchemeParams,'none', bMask,patch_mode);
return
end

        
if k==1
    
    [CSH_ann,CSH_bnn]= HashingSchemeNew(A,B,k,calcBnn,HashingSchemeParams,'none', bMask,patch_mode);
    
else % KNN
    
    if exist('fastKNN','var') && fastKNN && k >=15
        assert(patch_mode==0);
        assert(isempty(bMask));
        [CSH_ann,CSH_bnn,KNN_extraInfo.numUniqueResultsPerPixel,KNN_extraInfo.sortedErrors] = ...
            HashingSchemeNewKNN_LargeK(A,B,k,calcBnn,HashingSchemeParams, bMask,patch_mode);
    else        
        [CSH_ann,CSH_bnn]= HashingSchemeNew(A,B,k,calcBnn,HashingSchemeParams,'none', bMask,patch_mode);
    end
    
end








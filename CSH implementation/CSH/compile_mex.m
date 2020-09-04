clc
disp('------ In compile_mex ---------------');

%% 1] (temporarily) add the subdirectories to your Matlab PATH
disp('=== Step 1: adding paths...');
AddPaths

%% 2] deleting all previous mex files from the 'C_and_Mex' sub-directory
disp('=== Step 2: deleting old mex files...');
delete ./C_and_Mex/*.mex*

%% 2.5] % compile all CSH mex files in the 'C_and_Mex' sub-directory
disp('=== Step 2.5: compiling patchmatch ''votemex'' mex function ...');
cd .\C_and_Mex\patchmatch_votemex
mex OPTIMFLAGS="/DNDEBUG /DMEX_MODE /openmp"  knn.cpp mexutil.cpp nn.cpp votemex.cpp patch.cpp vecnn.cpp simnn.cpp allegro_emu.cpp -output ../votemex
cd ../../

%% 3] % compile all CSH mex files in the 'C_and_Mex' sub-directory
mex ./C_and_Mex/ApplyPlusKernel8u16s.c                     -output  ./C_and_Mex/ApplyPlusKernel8u16s
disp('=== Step 3: completed  1 out of 18 - file ApplyPlusKernel8u16s');
mex ./C_and_Mex/ApplyPlusKernel8u32s.c                     -output  ./C_and_Mex/ApplyPlusKernel8u32s
disp('=== Step 3: completed  2 out of 18 - file ApplyPlusKernel8u32s');
mex ./C_and_Mex/CalculateImageOfBinIndices_16s.c               -output  ./C_and_Mex/CalculateImageOfBinIndices_16s
disp('=== Step 3: completed  3 out of 18 - file CalculateImageOfBinIndices_16s');
mex ./C_and_Mex/CalculateImageOfBinIndices_32s.c               -output  ./C_and_Mex/CalculateImageOfBinIndices_32s
disp('=== Step 3: completed  4 out of 18 - file CalculateImageOfBinIndices_32s');
mex ./C_and_Mex/GCKFilterSingleStep16s_C3.c             -output  ./C_and_Mex/GCKFilterSingleStep16s_C3
disp('=== Step 3: completed  5 out of 18 - file GCKFilterSingleStep16s_C3');
mex ./C_and_Mex/GCKFilterSingleStep16s_yOnly_C3_OPTER2.c       -output  ./C_and_Mex/GCKFilterSingleStep16s_yOnly_C3_OPTER2
disp('=== Step 3: completed  6 out of 18 - file GCKFilterSingleStep16s_yOnly_C3_OPTER2');
mex ./C_and_Mex/GCKFilterSingleStep32s_C3.c             -output  ./C_and_Mex/GCKFilterSingleStep32s_C3                  
disp('=== Step 3: completed  7 out of 18 - file GCKFilterSingleStep32s_C3');
mex ./C_and_Mex/GCKFilterSingleStep32s_C3_Y_Only.c             -output  ./C_and_Mex/GCKFilterSingleStep32s_C3_Y_Only                  
disp('=== Step 3: completed  8 out of 18 - file GCKFilterSingleStep32s_C3_Y_Only');
mex ./C_and_Mex/GetAnnError_C3.c                               -output  ./C_and_Mex/GetAnnError_C3              
disp('=== Step 3: completed  9 out of 18 - file GetAnnError_C3');
mex ./C_and_Mex/GetAnnError_GrayLevel_C1.c                     -output  ./C_and_Mex/GetAnnError_GrayLevel_C1              
disp('=== Step 3: completed 10 out of 18 - file GetAnnError_GrayLevel_C1');
mex ./C_and_Mex/hash.cpp                                       -output  ./C_and_Mex/hash                              
disp('=== Step 3: completed 11 out of 18 - file hash');
mex ./C_and_Mex/MexFillTable.c                                 -output  ./C_and_Mex/MexFillTable                                 
disp('=== Step 3: completed 12 out of 18 - file MexFillTable');
mex ./C_and_Mex/GCKCodebookPropagation16s_FilterVectors.c      -output  ./C_and_Mex/GCKCodebookPropagation16s_FilterVectors                                 
disp('=== Step 3: completed 13 out of 18 - file GCKCodebookPropagation16s_FilterVectors');
mex ./C_and_Mex/GCKCodebookPropagation32s_FilterVectors.c      -output  ./C_and_Mex/GCKCodebookPropagation32s_FilterVectors                                 
disp('=== Step 3: completed 14 out of 18 - file GCKCodebookPropagation32s_FilterVectors');
mex ./C_and_Mex/GCKCodebookPropagation16s_KNN_B.c              -output  ./C_and_Mex/GCKCodebookPropagation16s_KNN_B
disp('=== Step 3: completed 15 out of 18 - file GCKCodebookPropagation16s_KNN_B');
mex ./C_and_Mex/GCKCodebookPropagation32s_KNN_B.c              -output  ./C_and_Mex/GCKCodebookPropagation32s_KNN_B
disp('=== Step 3: completed 16 out of 18 - file GCKCodebookPropagation32s_KNN_B');
mex ./C_and_Mex/GCKCodebookPropagation16s_KNN_same_image_B.c   -output  ./C_and_Mex/GCKCodebookPropagation16s_KNN_same_image_B
disp('=== Step 3: completed 17 out of 18 - file GCKCodebookPropagation16s_KNN_same_image_B');
mex ./C_and_Mex/GCKCodebookPropagation32s_KNN_same_image_B.c   -output  ./C_and_Mex/GCKCodebookPropagation32s_KNN_same_image_B
disp('=== Step 3: completed 18 out of 18 - file GCKCodebookPropagation32s_KNN_same_image_B');
warning('off','MATLAB:RMDIR:RemovedFromPath')
try
    disp('=== Step 4: Trying to compile ''TransitiveKNN_part2_new.prj'' project using Matlab Coder . . .');
    coder -build ./C_and_Mex/TransitiveKNN_part2_new.prj
catch
    disp('=== Step 4: FAILED to compile ''TransitiveKNN_part2.prj'' using Matlab Coder.');
    disp('=== Step 4: DON''T WORRY - The mex function ''TransitiveKNN_part2_mex'' is needed ONLY for the ''fast'' KNN version for large Ks');
    disp('=== Step 4: Try compiling ''TransitiveKNN_part2_mex'' directly, by first fixing directories in ''TransitiveKNN_part2_mex.mk''');
    disp('=== Step 4: and in ''TransitiveKNN_part2_mex.bat'', which are both under the ''./C_and_Mex/TransitiveKNN_part2'' directory.');    
    disp('=== Step 4: Then - double click ''TransitiveKNN_part2_mex.bat'' to generate the mex file.');            
    disp('=== Step 4: If this still doesn''t work, you can always use the MUCH SLOWER Matlab version, by changing ');            
    disp('=== Step 4: the call(s) in the code from ''TransitiveKNN_part2_mex'' to ''TransitiveKNN_part2''.');            
end

disp(' !! (These 18 (+1, hopefully) mex files should now appear under the ''./C_and_Mex/'' directory) !!');
disp('------ Completed compile_mex --------');


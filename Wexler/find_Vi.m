function Vi = find_Vi(Wi,all_patches,dist)
% find the most similar window Vi from all_patches database with respect to Wi 
% and attribute to the selected Vi the following attributes:
% - Vi.patch : contains the RGB components of each pixel of the patch Vi 
%   (reshaped to a (WindowSize^2, 3) matrix) 
% - Vi.wi : the weight of the selected patch Vi, telling how much the patch
%   is relevant
% - Vi.color : are the RGB components of Vi, namely ci 

sim_all = zeros(1,length(all_patches));
for i=1:length(all_patches)
   sim_all(i) = ComputeSim(Wi.patch,all_patches(i).patch);
end

[maxSim, index] = max(sim_all);
Vi_found = all_patches(index);
Vi.patch = Vi_found.patch;
Vi.wi = 1.3^(-dist)*maxSim;
Vi.color = Vi_found.patch(Wi.position_rel,:);
function Vi = find_Vi(Wi,all_patches,p_position)
sim_all = zeros(1,length(all_patches));
for i=1:length(all_patches)
   sim_all(i) = ComputeSim(Wi.patch,all_patches(i).patch);
end

[maxSim, index] = max(sim_all);
Vi_found = all_patches(index);
Vi.patch = Vi_found.patch;
Vi.wi = 1.3^(-norm(p_position-Vi_found.position))*maxSim;
Vi.color = Vi_found.patch(Wi.position_rel,:);
function Vi = find_Vi_Set(Wi_set,all_patches,p_position,WindowSize)
% find the most similar window Vi that belongs to the database all_patches
% for each window Wi in the Wi_set containing the pixel at p_position
% the similarity calculation is performed in find_Vi for each Wi
Vi = repmat(struct('patch',zeros(WindowSize^2,3),'wi',zeros(1),'color',zeros(3,1)),1,length(Wi_set));
parfor i = 1:length(Wi_set)
    Vi(i) = find_Vi(Wi_set(i),all_patches,p_position); 
end
function Vi_param = find_Vi_param_set(Wi_set,all_patches,p_position,WindowSize)
Vi_param = repmat(struct('wi',zeros(1),'color',zeros(3,1)),1,WindowSize^2);
parfor i = 1:length(Wi_set)
    Vi_param(i) = find_Vi(Wi_set(i),all_patches,p_position); 
end
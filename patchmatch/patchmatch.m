function Vi = PatchMatch(Wi_set,inImg,NNF,dist,WindowSize)
Vi = repmat(struct('patch',zeros(WindowSize^2,3),'wi',zeros(1),'color',zeros(3,1)),1,length(Wi_set));

parfor i = 1:length(Wi_set)
    Vi(i) = find_Vi_from_NNF(Wi_set(i),NNF,inImg,dist);
end

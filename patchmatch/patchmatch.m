function Vi = PatchMatch(Wi_set,inImg,NNF,p_position,WindowSize)
Vi = repmat(struct('patch',zeros(WindowSize^2,3),'wi',zeros(1),'color',zeros(3,1)),1,length(Wi_set));

for i = 1:length(Wi_set)
    Vi(i) = find_Vi_from_NNF(Wi_set(i),NNF,inImg,p_position);
end

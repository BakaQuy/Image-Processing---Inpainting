function Wi_set = find_Wi_Set(inImg,p_position,WindowSize) 
size_set = WindowSize^2;
Wi_set = repmat(struct('patch',zeros(size_set,3),'position_rel',zeros(1),'center',zeros(2,1)),1,size_set);
WindowHalf = floor(WindowSize/2);
i = 1;
for K = 1:WindowSize
    for L = 1:WindowSize
        Wi_set(i).patch = reshape(inImg(p_position(1)-K+1:p_position(1)-K+WindowSize,p_position(2)-L+1:p_position(2)-L+WindowSize,:),size_set,3);       
        Wi_set(i).position_rel = (L-1)*WindowSize+K;
        Wi_set(i).center = [p_position(1)-K+1+WindowHalf;p_position(2)-L+1+WindowHalf];
        i = i + 1;
    end
end
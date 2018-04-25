function Wi_set = find_Wi_Set_up(inImg,p_position,WindowSize) 
size_set = WindowSize^2;
Wi_set = repmat(struct('patch',zeros(size_set,3),'position_rel',zeros(1)),1,WindowSize);
K = WindowSize;
for L = 1:WindowSize
    Wi_set(L).patch = reshape(inImg(p_position(1)-K+1:p_position(1)-K+WindowSize,p_position(2)-L+1:p_position(2)-L+WindowSize,:),size_set,3);       
    Wi_set(L).position_rel = (L-1)*WindowSize+K;
end
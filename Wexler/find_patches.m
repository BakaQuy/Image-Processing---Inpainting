function V_all = find_patches(inImg,H,WindowSize)
% set up the database of the patches of size WindowSize V_all, 
% these are the patches that belong to the image excluding the hole H 
[m,n,~] = size(inImg);
size_set = WindowSize^2;
i = 1;
for k = 1:m-WindowSize
    for l = 1:n-WindowSize
%          if (k < H(1,1)-WindowSize || k > H(1,2) || l < H(2,1)-WindowSize || l > H(2,2)) && (k <= m-(WindowSize-1)) && (l <= n-(WindowSize-1))
         if (k <= m-(WindowSize-1)) && (l <= n-(WindowSize-1))
            V_all(i).patch = reshape(inImg(k:k+WindowSize-1,l:l+WindowSize-1,:),size_set,3);
            V_all(i).position = [k;l];
            i = i + 1;
         end
    end
end
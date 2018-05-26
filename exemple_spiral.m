M = [1 2 3 4;
    5 6 7 8;
    9 10 11 12;
    13 14 15 16];

[m,n] = size(M);
[idX, idY] = spiral_browser(M);

for i=1:m*n
    M(idX(i), idY(i))
end


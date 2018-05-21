M = [1 2 3 4 5;
     6 7 8 9 10;
     11 12 13 14 15;
     16 17 18 19 20;
     21 22 23 24 25];

[m,n] = size(M);
[IdX, IdY] = spiral_browser(M);

for i=1:m*n
    M(idX(i), idY(i))
end


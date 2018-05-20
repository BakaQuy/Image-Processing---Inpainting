function [ idX, idY ] = spiral_browser( M )
% return 2 arrays: idX and idY
% to browse the matrix M following a spiral starting from the edge,
% use a for loop as follows:
% for i = 1:m*n
%    M(idX(i), idY(i))
% end

[X,Y] = size(M);
x = 0; y = 0;
dx = 0; dy = -1;
idX = [];
idY = [];

for i=1:max([X Y])^2
    if (x > -X/2 && x <= X/2) && (y > -Y/2 && y <= Y/2)
        idX(end+1) = x + ceil(X/2);
        idY(end+1) = y + ceil(Y/2);
    end
    if (x == y) || (x < 0 && x == -y) || (x > 0 && x == 1-y)
        t = dx;
        dx = -dy;
        dy = t;
    end
    x = x + dx;
    y = y + dy;
end
idX = fliplr(idX);
idY = fliplr(idY);
end


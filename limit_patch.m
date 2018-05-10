function  [ min_x, min_y, max_x, max_y ]= limit_patch( x_now, y_now, n, m, patching_region )

    min_x=x_now-floor(patching_region/2);
    max_x=x_now+floor(patching_region/2);
    min_y=y_now-floor(patching_region/2);
    max_y=y_now+floor(patching_region/2);
    if min_x<1
        min_x=1;
        max_x=min_x+patching_region-1;
    end
    if max_x>n
        max_x=n;  
        min_x=max_x-patching_region+1;
    end
    if min_y<1
        min_y=1;
        max_y=min_y+patching_region-1;
    end
    if max_y>m
        max_y=m;  
        min_y=max_y-patching_region+1;
    end
end
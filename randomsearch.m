%randomsearch
function output=randomsearch(NNF,x,y,im_a,im_b,it,dim_wind)
x_out=NNF(x,y,1);
y_out=NNF(x,y,2);
[m, n, ~]=size(NNF);
dim=m;
 for k=1:it
    if dim*(0.5^k)>=1
        v=dim*(0.5^k);
        w=floor(v);
%         disp(w)
%         disp(x_out)
        if x_out-dim_wind>=1 && y_out-dim_wind>=1 && y_out+dim_wind<=n && x_out+dim_wind<=dim  %normal case
                val=[x_out y_out]+floor(v*[unifrnd(-1,1) unifrnd(-1,1)]);
        elseif x_out-dim_wind<1 && y_out-dim_wind>=1 && y_out+dim_wind<=n && x_out+dim_wind<=dim %left side
                val=[x_out y_out]+floor(v*[unifrnd(0,1) unifrnd(-1,1)]);
        elseif x_out-dim_wind<1 && y_out-dim_wind<1 && y_out+dim_wind<=n && x_out+dim_wind<=dim % down left
                val=[x_out y_out]+floor(v*[unifrnd(0,1) unifrnd(0,1)]);
        elseif x_out-dim_wind>=1 && y_out-dim_wind<1 && y_out+dim_wind<=n && x_out+dim_wind>dim % down right
                val=[x_out y_out]+floor(v*[unifrnd(-1,0) unifrnd(0,1)]);
        elseif x_out-dim_wind>=1 && y_out-dim_wind<1 && y_out+dim_wind<=n && x_out+dim_wind<=dim %down
                val=[x_out y_out]+floor(v*[unifrnd(-1,1) unifrnd(0,1)]);
        elseif x_out-dim_wind>=1 && y_out-dim_wind>=1 && y_out+dim_wind>n && x_out+dim_wind<=dim %up
                val=[x_out y_out]+floor(v*[unifrnd(-1,1) unifrnd(-1,0)]);
        elseif x_out-dim_wind>=1 && y_out-dim_wind>=1 && y_out+dim_wind>n && x_out+dim_wind>dim %up right
                val=[x_out y_out]+floor(v*[unifrnd(-1,0) unifrnd(-1,0)]);
        elseif x_out-dim_wind<1 && y_out-dim_wind>1 && y_out+dim_wind>n && x_out+dim_wind<=dim %up left
                val=[x_out y_out]+floor(v*[unifrnd(0,1) unifrnd(-1,0)]);
        elseif x_out-dim_wind>=1 && y_out-dim_wind>=1 && y_out+dim_wind<=n && x_out+dim_wind>dim %right
                val=[x_out y_out]+floor(v*[unifrnd(-1,0) unifrnd(-1,1)]);
        else
                val=[x_out y_out];
        end
        if val(1)-dim_wind<1
            val(1)=ceil(dim_wind/2);
        elseif val(1)+dim_wind>dim
            val(1)=dim-ceil(dim_wind/2);
        end
        if val(2)-dim_wind<1
            val(2)=ceil(dim_wind/2);
        elseif val(2)+dim_wind>n
            val(2)=n-ceil(dim_wind/2);
%         disp(val)
        end
        if compare_patch(im_a,im_b,x,y,val(1),val(2),dim_wind)<=compare_patch(im_a,im_b,x,y,x_out,y_out,dim_wind)
            x_out=val(1);
            y_out=val(2);
        end
    end
end
% disp(x_out)
% disp(y_out)
output=[x_out y_out];

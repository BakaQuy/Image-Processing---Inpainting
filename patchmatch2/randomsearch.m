%randomsearch
function output=randomsearch(NNF,x,y,dim,it)
x_out=1;
y_out=1;
coor=[inf inf];
for k=1:it
    if dim*0.5^k>=1
        if x-dim>=1 && y-dim>=1 && y+dim<=dim && x+dim<=dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(-1,1) unifrnd(-1,1)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim<1 && y-dim>=1 && y+dim<=dim && x+dim<=dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(0,1) unifrnd(-1,1)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim<1 && y-dim<1 && y+dim<=dim && x+dim<=dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(0,1) unifrnd(0,1)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim>=1 && y-dim<1 && y+dim<=dim && x+dim<=dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(-1,1) unifrnd(0,1)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim>=1 && y-dim>=1 && y+dim>dim && x+dim<=dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(-1,1) unifrnd(-1,0)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim>=1 && y-dim>=1 && y+dim>dim && x+dim>dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(-1,0) unifrnd(-1,0)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        elseif x-dim>=1 && y-dim>=1 && y+dim<=dim && x+dim>dim
        val=[x y]+floor(dim*(0.5^k)*[unifrnd(-1,0) unifrnd(-1,1)]);
        coor=[NNF(val(1),val(2),1) NNF(val(1),val(2),2)];
        end
    end
    if norm(coor-[x y])<=norm([NNF(x,y,1) NNF(x,y,2)]-[x y])
        x_out=coor(1);
        y_out=coor(2);
    else
        x_out=NNF(x,y,1);
        y_out=NNF(x,y,2);
    end
end
output=[x_out y_out];

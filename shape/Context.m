function [C] = Context(c1,c2,percent)
rfrac=0.25;
ctx1=shapecontext(c1,rfrac);
ctx2=shapecontext(c2,rfrac);

cost_new=computecostmatrix(ctx1,ctx2,0,0.5);

%Stretches the 1/4-costmatrix as this will make it easier to implement
%constraints where we need to use the diagonal.
cost_streched=zeros(200,200);
for c=1:50
    cost_streched(:,(c-1)*4+1)=cost_new(1:200,c);
end

%(Almost) 20 percent outline constraint
length_outline=100;
percent20=round(length_outline*percent);
k_size=percent20;
k_size_inv=100-k_size;

%Creation of the masks for the constraints.
%20 percent constraint for alle the points inclusive the end/start points
costmaskdiag=triu(tril(ones(size(cost_streched)),k_size),-k_size);
costmaskcorner=[[triu(ones(100,100),k_size_inv) + ...
                 tril(ones(100,100),-k_size_inv)] zeros(100,100); ...
                zeros(100,100) [triu(ones(100,100),k_size_inv) + ...
                 tril(ones(100,100),-k_size_inv)]];
costmask20=costmaskdiag+costmaskcorner;

%Right-left constraint
costmaskRL=[ones(100,100) zeros(100,100); zeros(100,100) ones(100,100)];

%Making the final mask with both the right-left constraint, and the 20
%percent constraint.
costmask=costmask20.*costmaskRL;

%Using the mask on the streched costmastrix and unstreching.
cost_streched_masked=cost_streched.*costmask+(costmask==0)*1.2;
cost_unstreched=cost_streched_masked(:,1:4:200);
cost_new(:,1:50)=cost_unstreched;

C=hungarian(cost_new);
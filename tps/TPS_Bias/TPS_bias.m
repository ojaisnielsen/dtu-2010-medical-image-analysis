load abdomen.mat
abdomen=double(abdomen);
roi=double(roi);
imagesc(abdomen);
colormap gray

k=0;
observations=[];
[x,y,button]=ginput(1);
while button~=3
    k=k+1
    observations=[observations;round(y),round(x), ...
                               abdomen(round(y),round(x))];
    [x,y,button]=ginput(1);
end
observations=double(observations);

%With lambda
Y=observations(:,3);
xin=observations(:,1:2)';
P=[ones(1,size(xin,2));xin];

N=length(Y);
K=zeros(N,N);
for i=1:N
for j=1:N
K(i,j)=TPS_eta(norm(xin(:,i)-xin(:,j)));
end
end
lambda=230000;
M=[K+lambda*eye(size(K)),P';P,zeros(3,3)];
ab=M\[Y;zeros(3,1)];

beta=ab(N+1:end);
beta_0=beta(1);
beta_1=beta(2:3);
alpha=ab(1:N);

Hs=[K P']*inv(M);
Hh=Hs(:,1:N);
dof=trace(Hh);

[gridx,gridy]=meshgrid([0:255],[0:255]);

Z=zeros(length(0:255),length(0:255));

for i=1:256
for j=1:256
Z(i,j)=TPS_f([i;j],xin,alpha,beta_0,beta_1);
end
end

figure
surfc(gridx,gridy,Z);
title(['\lambda=' num2str(lambda) ...
       '  degree of freedom=' num2str(dof)]);
   
%Z*roi
Z_new=Z.*roi;

figure
surfc(gridx,gridy,Z_new);
abdomen_new=abdomen./Z_new;
abdomen_new(abdomen_new==Inf)=0;

figure
imagesc(abdomen_new)
colormap gray
%Without lambda
% Y=[3;1;1;2];
% xin=[1,1,-1,-1;1,-1,1,-1];
% P=[ones(1,size(xin,2));xin];

% K=zeros(4,4);
% for i=1:4
% for j=1:4
% K(i,j)=TPS_eta(norm(xin(:,i)-xin(:,j)));
% end
% end

% M=[K,P';P,zeros(3,3)];
% ab=M\[Y;zeros(3,1)];

% beta=ab(5:7);
% beta_0=beta(1);
% beta_1=beta(2:3);
% alpha=ab(1:4);

% [gridx,gridy]=meshgrid([-1.5:0.1:1.5],[-1.5:0.1:1.5]);

% Z=zeros(length(-1.5:0.1:1.5),length(-1.5:0.1:1.5));

% for i=1:length(gridx)
% for j=1:length(gridx)
% Z(i,j)=TPS_f([gridx(i,j);gridy(i,j)],xin,alpha,beta_0,beta_1);
% end
% end

% surfc(gridx,gridy,Z);


%With lambda
Y=[3;1;1;2];
xin=[1,1,-1,-1;1,-1,1,-1];
P=[ones(1,size(xin,2));xin];

K=zeros(4,4);
for i=1:4
for j=1:4
K(i,j)=TPS_eta(norm(xin(:,i)-xin(:,j)));
end
end
lambda=1;
M=[K+lambda*eye(size(K)),P';P,zeros(3,3)];
ab=M\[Y;zeros(3,1)];

beta=ab(5:7);
beta_0=beta(1);
beta_1=beta(2:3);
alpha=ab(1:4);

Hs=[K P']*inv(M);
Hh=Hs(:,1:4);
dof=trace(Hh)

% [gridx,gridy]=meshgrid([-1.5:0.1:1.5],[-1.5:0.1:1.5]);

% Z=zeros(length(-1.5:0.1:1.5),length(-1.5:0.1:1.5));

% for i=1:length(gridx)
% for j=1:length(gridx)
% Z(i,j)=TPS_f([gridx(i,j);gridy(i,j)],xin,alpha,beta_0,beta_1);
% end
% end

% figure
% surfc(gridx,gridy,Z);
% title(['\lambda=' num2str(lambda) ...
       % '  degree of freedom=' num2str(dof)]);

%close all
%clear all
close all
clear all
clc

load mr.mat

figure
imagesc(mr1);
axis image
colormap gray

figure
imagesc(mr2);
axis image
colormap gray

%Calculate Gradient of mr2
[GradR1 GradR2]=gradient(mr2);

%Size of images
[R C]=size(mr1);

%Number of knots
p=3;

s=augknt(linspace(0,R,p),3);
t=augknt(linspace(0,C,p),3);


B1=spmak(s,eye(p));
B2=spmak(t,eye(p));

Q1=fnval(B1,1:R)';
Q2=fnval(B2,1:C)';

Q=kron(speye(2),kron(Q2,Q1));

[x1 x2]=ndgrid(1:R,1:C);

%Initialize w=0
w=zeros(size(Q,2),1);

stop=false;
k=0;
D_SSD_1=0;
deltaD_SSD=10^10;
while ~(stop)
%Update transformation y
y=[x1(:); x2(:)]+Q*w;

y1=reshape(y(1:end/2),R,C);
y2=reshape(y(end/2+1:end),R,C);

%Compute transformed image T(y) and its spatial derivatives gradient(T(y))
Ty=interp2(mr1,y2,y1,'linear',0);
% J=norm(Ty - mr2)^2+alpha*norm(w)^2;
[GradTy2 GradTy1]=gradient(Ty);
GradTy=[spdiags(GradTy1(:),0,180*256,180*256) spdiags(GradTy2(:),0,180*256,180*256)];

%Compute A
A=GradTy*Q;

%Solve
alpha=100;
AtA=A'*A;
delta_w=(AtA+alpha*eye(size(AtA)))\(A'*(mr2(:)-Ty(:))-alpha*w);

%Update number of iteration
k=k+1;

if k==10
    stop=true;
end
k

% D_SSD_2 = 1/2*sum(abs([GradTy1(:);GradTy2(:)]-[GradR1(:);GradR2(:)]).^2);
% deltaD_SSD_old=deltaD_SSD;
% deltaD_SSD=D_SSD_1-D_SSD_2;
% D_SSD_1=D_SSD_2;

%Update w
w=w + delta_w;
% J_new=0;
% i=0;
% first_iter=true;
% while (first_iter || J_new > J)
% w_new=w+(delta_w/2^i);
% % new objective function
% y=[x1(:); x2(:)]+Q*w_new;
% y1=reshape(y(1:end/2),R,C);
% y2=reshape(y(end/2+1:end),R,C);
% Ty_new=interp2(mr1,y2,y1,'linear',0);
% 
% J_new=norm(Ty_new - mr2)^2+alpha*norm(w_new)^2;
% first_iter=false;
% i = i+1;
% end
% w=w_new;

    
% deltaD_SSD
% if deltaD_SSD<400
%     stop=true;
% end
end

figure; imagesc(abs(mr2 - Ty));
figure; imagesc(abs(mr1 - mr2));
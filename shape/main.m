close all
clear all
clc

load meta.mat

%Task 4.1
%We define the shapes
c1=meta(:,1);
c2=meta(:,2);

%Centroid of shapes
meanc1=mean(c1);
meanc2=mean(c2);

%Centered shape
c01=c1-meanc1;
c02=c2-meanc2;

%Size of shapes
S1=norm(c01);
S2=norm(c02);

%Centered and unit sized shape
cs01=c01/S1;
cs02=c02/S2;

figure
plot(cs01)
hold on
plot(cs02)
title('Crude alignment by centering and scaling the shapes');

%Task4.2
N1=size(c1,1);
N2=size(c2,1);

a=repmat(cs01,1,N2);
b=repmat(cs02.',N1,1);

e=a-b;
A=e.*conj(e);

C=hungarian(A);

figure
plot(cs01,'b');
hold on
plot(cs02,'g');
plot([cs01(C) cs02].','r');
title('The two shapes with correpondences')

%%
%Task4.3
close all
clear all
clc

load lung.mat

c1=lung1;
c2=lung2(1:4:200);

N1=size(c1,1);
N2=size(c2,1);

a=repmat(c1,1,N2);
b=repmat(c2.',N1,1);

e=a-b;
A=e.*conj(e);

B=[A 0.5*ones(200,150)];
C=hungarian(B);

figure
plot(c1,'b');
hold on
plot(c2,'g');
plot([c1(C(1:50)) c2].','r');
title('The two shapes of the lungs with correpondences')

%%
%Task4.4
rfrac=0.25;
ctx1=shapecontext(c1,rfrac);
ctx2=shapecontext(c2,rfrac);

%Task4.5
close all
point_no=1;
figure
subplot(2,1,1)
imagesc(reshape(ctx2(point_no,:),3,8))
title(['point_no=' num2str(point_no)])
subplot(2,1,2)
imagesc(reshape(ctx1(C(point_no),:),3,8))

%%
%Task4.6
%Compute cost with 0 additional dummy-points with cost 0.5
cost=computecostmatrix(ctx1,ctx2,0,0.5);

%Task4.7a
%Computing the correspondences
C_new=hungarian(cost);

figure
plot(c1,'b');
hold on
plot(c2,'g');
plot([c1(C_new(1:50)) c2].','r');
title('The two shapes of the lungs with correpondences')

%%
%Task4.7b
cost_new=cost;
c1=lung1;
c2=lung2(1:4:200);

C_new_constraint=Context(c1,c2,0.2);

figure
plot(c1,'b');
hold on
plot(c2,'g');
plot([c1(C_new_constraint(1:50)) c2].','r');
title('The two shapes of the lungs with correpondences')

%%
%Task(4.8,4.9,4.10)
close all
c1=lung1;
c2=lung2(1:4:200);

T0=c1(C_new_constraint(1:50));
T0=[real(T0); imag(T0)];
S0=c2;
S0=[real(S0); imag(S0)];
c2_new=[];
C_new=[];
stop=0;
norm_old=100;
while ~stop
    S0_warped=tps(T0,S0);
    
    k=size(S0,1)/2;
    c2=[S0_warped(1:k) + sqrt(-1)*S0_warped(k+1:end)];
    c2_new=[c2_new c2];
    
    C=Context(c1,c2,0.2);
    C_new=[C_new C(:)];
    
    T0=c1(C(1:50));
    T0=[real(T0); imag(T0)];
    S0=c2;
    
    S0=[real(S0); imag(S0)];
    norm_new=norm(T0-S0);
    if abs(norm_new-norm_old)<0.5
        stop=1;
    end
    norm_old=norm_new;
end

%Plots the matching shapes with correspondences for each itteration.
no_plots=size(c2_new,2);
figure
for no=1:no_plots
subplot(1,no_plots,no)
plot(c1,'bx');
hold on
plot(c2_new(:,no),'gx');
plot([c1(C_new(1:50,no)) c2_new(:,no)].','r');
end

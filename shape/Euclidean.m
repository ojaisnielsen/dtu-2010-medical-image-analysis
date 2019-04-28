function C=Euclidean(c1,c2)
N1=size(c1,1);
N2=size(c2,1);

a=repmat(c1,1,N2);
b=repmat(c2.',N1,1);

e=a-b;
A=e.*conj(e);

B=[A 0.5*ones(200,150)];
C=hungarian(B);
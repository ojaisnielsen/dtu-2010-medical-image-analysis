function f=TPS_f(x,xin,alpha,beta_0,beta_1)
f=beta_0+beta_1'*x;
for i=1:length(alpha)
    f=f+alpha(i)*TPS_eta(norm(x-xin(:,i)));
end
end
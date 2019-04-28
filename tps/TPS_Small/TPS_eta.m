function eta=TPS_eta(r)
if r>0
    eta=r^2*log(r^2);
else
    eta=0;
end
end
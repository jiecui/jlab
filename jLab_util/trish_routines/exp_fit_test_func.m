function k=exp_fit_test_func(t,p)
% EXGAUSSPDF The ex-Gaussian pdf
% Syntax k=exgauss(t,p)
a=p(1);
b=p(2);
k = a*(t^b)
k(k==Inf)=zeros(length(k(k==Inf)),1);


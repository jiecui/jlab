function k=Iepanech(t)
% IEPANECH The integrated Epanechnikov kernel.
k2=(t>=sqrt(5)).*ones(size(t));
k1=(abs(t)<=sqrt(5)).*(.75.*(t/sqrt(5) - t.^3/5/sqrt(5)/3) + .5);
k=k1+k2;
function [m,ci] = robust(x)

ind = find(abs(x-mean(x))/std(x)<3);
x = x(ind);

[m,s,mc,sc] = normfit(x,0.05);
ci = (mc(2)-mc(1))/2;
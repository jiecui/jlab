function res = binscr(a,b)
% call bins, adjusting rows and columns
t = 0;
if size(a,1) > 1
    t = 1;
    a = a';
end
if size(b,1) >1
    b = b';
end
res = bins(a,b);
if t
    res = res';
end
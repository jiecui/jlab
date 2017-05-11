function dva=GREF2dva(rsasc,xrez,yrez)
% GREF2dva calculate the degr visual angle given output from eyelink in Gaze REF format takes the matrix from an asc export file from eyelink
%
% rsasc is a resampled data file matrix, where columns 6 and 8 are the x
% and y data for the left eye, and columns 7 and 9 are the x,y for the
% right eye


% First left eye
x = rsasc(:,6)./xrez;
y = rsasc(:,8)./yrez;
dva = [x y];

% now do right eye
x1 = rsasc(:,7)./xrez;
y1 = rsasc(:,9)./yrez;
dvar = [x1 y1];;

dva = [dva dvar];
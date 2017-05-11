function [dva]=HREF2dva(rsasc, enum)
% HREF2dva calculate the degr visual angle given output from eyelink in HREF format takes the matrix from an asc export file from eyelink
%
% enum: should contain the fields left_x, left_y, right_x, right_y

% angle = 57.296 * acos( (f*f + x1*x2 + y1*y2) / (sqrt( (f*f + x1*x1  + y1*y1) * (f*f + x2*x2 + y2*y2) ) )

% First left eye
% x1 = rsasc(1:end-1,2);
% y1 = rsasc(1:end-1,4);
% x2 = rsasc(2:end,2);
% y2 = rsasc(2:end,4);
f = 15000;

denom = sqrt((f*f +  rsasc(1:end-1,enum.left_x).* rsasc(1:end-1,enum.left_x) + rsasc(1:end-1,enum.left_y).*rsasc(1:end-1,enum.left_y)) .* ...
    (f*f + rsasc(2:end,enum.left_x).*rsasc(2:end,enum.left_x) + rsasc(2:end,enum.left_y).*rsasc(2:end,enum.left_y)));
numer = f*f +  rsasc(1:end-1,enum.left_x).*rsasc(2:end,enum.left_x) + rsasc(1:end-1,enum.left_y).*rsasc(2:end,enum.left_y);
% denom = sqrt((f*f + x1.*x1 + y1.*y1) .* (f*f + x2.*x2 + y2.*y2));
% numer = f*f + x1.*x2 + y1.*y2;
% this is the angle between two samples with the eye as vertix.
angle = 180/pi * real(acos(numer./denom));
clear numer denom

% now break it down into x,y components
% tan(a) = (rsasc(2:end,2)- rsasc(1:end-1,2))/(rsasc(2:end,4)-rsasc(1:end-1,4)); angle*sine(a); angle*cos(a);

% this is the angle betwen each two samples inside the HREF plane.
% a = atan2(rsasc(2:end,2)- rsasc(1:end-1,2),rsasc(2:end,4)-rsasc(1:end-1,4));
clear x1 y1 x2 y2
% dva = [angle.*sin(a) angle.*cos(a)];
dvaL = [angle.*sin(atan2(rsasc(2:end,enum.left_x)- rsasc(1:end-1,enum.left_x),rsasc(2:end,enum.left_y)-rsasc(1:end-1,enum.left_y)))....
    angle.*cos(atan2(rsasc(2:end,enum.left_x)- rsasc(1:end-1,enum.left_x),rsasc(2:end,enum.left_y)-rsasc(1:end-1,enum.left_y)))];
dvaL(isnan(dvaL))=0;
dvaL = cumsum(dvaL);
clear a angle

% now do right eye
% x1 = rsasc(1:end-1,3);
% y1 = rsasc(1:end-1,5);
% x2 = rsasc(2:end,3);
% y2 = rsasc(2:end,5);
denom = sqrt((f*f + rsasc(1:end-1,enum.right_x).*rsasc(1:end-1,enum.right_x) + rsasc(1:end-1,enum.right_y).*rsasc(1:end-1,enum.right_y)) .*...
    (f*f + rsasc(2:end,enum.right_x).*rsasc(2:end,enum.right_x) + rsasc(2:end,enum.right_y).*rsasc(2:end,enum.right_y)));
numer = f*f + rsasc(1:end-1,enum.right_x).*rsasc(2:end,enum.right_x) + rsasc(1:end-1,enum.right_y).*rsasc(2:end,enum.right_y);
angle = 180/pi * real(acos(numer./denom));
clear numer denom

% a = atan2(rsasc(2:end,3)-rsasc(1:end-1,3),rsasc(2:end,5)-rsasc(1:end-1,5));
clear x1 y1 x2 y2
% dvar = [angle.*sin(a) angle.*cos(a)];
dvaR = [angle.*sin(atan2(rsasc(2:end,enum.right_x)-rsasc(1:end-1,enum.right_x),rsasc(2:end,enum.right_y)-rsasc(1:end-1,enum.right_y)))...
    angle.*cos(atan2(rsasc(2:end,enum.right_x)-rsasc(1:end-1,enum.right_x),rsasc(2:end,enum.right_y)-rsasc(1:end-1,enum.right_y)))];
dvaR(isnan(dvaR))=0;
dvaR = cumsum(dvaR);
clear a angle
dva = [dvaL dvaR];

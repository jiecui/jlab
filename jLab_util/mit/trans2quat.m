function [quat] = trans2quat(trans)

v = [(-(trans(3,2) - trans(2,3))/2) ((trans(3,1) - trans(1,3))/2) (-(trans(2,1) - trans(1,2))/2)];
sa = sqrt(sum(v.^2));
ca = (trans(1,1) + trans(2,2) + trans(3,3) -1)/2;
if sa > 0.00001,
   v = v*(1.0/sa);
else
   v = [1 0 0];
end;
a = atan2(sa, ca);
quat = [a v];

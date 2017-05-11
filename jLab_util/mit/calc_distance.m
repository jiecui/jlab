function [dis] = calc_distance(tr1, tr2, w1, w2)
% this function calculates the orientation and/or distance error between
% two sensor readings...
trans = tr2;
trans = inverttrans(trans);
trans = multtrans(tr1,trans);
quat = trans2quat(trans);

% mix position and orientation differences
res = w1 * sqrt(sum((tr1(4,1:3) - tr2(4,1:3)).^2)) + w2 * abs(quat(1));
if res == 0,
   res = .001;
end

dis = res;
function mat = vec2mat3(vec, track)
% given two 3d vectors, will return a matrix for which x-axis is perfectly aligned to
% first vector, and z axis is as closely aligned to the second as possible
x = vec./norm(vec);
track2 = track./norm(track);
dotprod = x*track2;
if abs(dotprod)==1
   track = [track(2:3) track(1)];
end
y = cross(track, vec);
y = y./norm(y);
z = cross(x,y);
%x(1) = -x(1);
%y(1) = -y(1);
%z(1) = -z(1);
mat = [x;y;z]';

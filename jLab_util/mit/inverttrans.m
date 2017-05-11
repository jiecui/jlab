function[mat] = inverttrans(t)
% computation helper for opengl mats
t(1:3, 1:3) = t(1:3,1:3)';

% invert translation
tr(1) = t(1,1)*t(4,1)+t(2,1)*t(4,2)+t(3,1)*t(4,3);
tr(2) = t(1,2)*t(4,1)+t(2,2)*t(4,2)+t(3,2)*t(4,3);
tr(3) = t(1,3)*t(4,1)+t(2,3)*t(4,2)+t(3,3)*t(4,3);
   
% assign new translation
t(4,1) = -tr(1);
t(4,2) = -tr(2);
t(4,3) = -tr(3);

mat = t;
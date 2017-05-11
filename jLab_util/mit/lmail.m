function [orientations] = lmail(pulse)
global s1data s4data
blendsens1 = [0 0 reshape(s1data',1,12)];
blendsens4 = [0 0 reshape(s4data',1,12)];

% s4 will be the target
gl4 = pol2gl(blendsens4);
gl1 = pol2gl(blendsens1);
% do left mail rotations...
gl4(1:3,4,1) = gl4(1:3,4,1) + gl4(1:3,1,1).*(ones(1,3)*8.75)';
gl4(:,:,1) = gl4(:,:,1) * rotz(-pi/2);
gl4(:,:,1) = gl4(:,:,1) * roty(pi/2);
% compare sens2 to sens3
ordiffs = findeuler123(gl4, gl1);
% need to give regular eulers
s1euler = C2Euler123(gl1(:,:,1))'/pi*180;
s4euler = C2Euler123(gl4(:,:,1))'/pi*180;

% collect orientation measures
orientations = [ordiffs s1euler s4euler];
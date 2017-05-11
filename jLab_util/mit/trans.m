function [tr] = pol2gl(polh)
% translate a polhemus input to a 4x4 opengl matrix
t = ones(4);
t(1,:) = [polh(6:8) 0];
t(2,:) = [polh(9:11) 0];
t(3,:) = [polh(12:14) 0];
t(4,:) = [polh(3:5) 0];

tr = t;
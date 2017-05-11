function [tr] = newpol2gl(polh)
% translate the spatial data of a polhemus input to a 4x4 opengl matrix
t = zeros(size(polh,1), 16);
t(:,1:3) = polh(:,6:8);
t(:,5:7) = polh(:,9:11);
t(:,9:11) = polh(:,12:14);
t(:,13:15) = polh(:,3:5);
t(:,16) = 1;
tr = permute(reshape(t',[4 4 size(t,1)]), [2 1 3]);
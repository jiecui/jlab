function [tr] = pol2gl(polh)
% translate the spatial data of a polhemus input to a 4x4 opengl matrix
%t = ones(4,4,size(polh,1));
%t(1,:) = [polh(:, 6:8) zeros(size(polh(1),1))];
%t(2,:) = [polh(9:11) 0];
%t(3,:) = [polh(12:14) 0];
%t(4,:) = [polh(3:5) 1];

%tr = t;
zs = zeros(size(polh,1),1);
polh = [polh(:, 7) polh(:, 6) -polh(:, 8) zs ...
         polh(:, 10) polh(:, 9) -polh(:, 11) zs ...
         polh(:, 13) polh(:, 12) -polh(:, 14) zs ...
         polh(:, 4) polh(:, 3) -polh(:, 5) ones(size(polh,1),1)];
tr = reshape(polh', 4, 4, size(polh, 1));
for i=1:size(tr,3)
	tr(:,:,i) = tr(:,:,i)*rotx(pi);
end
   
   
   
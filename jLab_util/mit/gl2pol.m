function [polh] = gl2pol(tr)
% converts back to a polhemus-style matrix from an opengl mat

for i=1:size(tr,3)
  tr(:,:,i) = tr(:,:,i)*rotx(-pi);
end
polh = reshape(tr, 16, size(tr,3));
polh = polh';
polh= [zeros(size(polh,1),2) polh(:, 14) polh(:, 13) -polh(:, 15)  ...
         polh(:, 2) polh(:, 1) -polh(:, 3) ...
         polh(:, 6) polh(:, 5) -polh(:, 7)  ...
         polh(:, 10) polh(:, 9) -polh(:, 11) ];
   
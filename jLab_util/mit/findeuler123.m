function [euler] = findeuler( t1, t2, method )
if nargin<3
   method = 'A';
end

switch method
case 'A'
   for i=1:size(t1,3),
   	for j=1:size(t2,3),
      	m1 = C2EP(t1(:,:,i)');
      	m2 = C2EP(t2(:,:,j)');
      	angs=subEP(m2,m1);
      	euler(i,:) = EP2Euler231(angs)'/pi*180;
      end
   end
case 'B'
   for i=1:size(t1,3),
   	for j=1:size(t2,3),
      	m1 = C2Euler231(t1(:,:,i)');
      	m2 = C2Euler231(t2(:,:,j)');
      	angs = subEuler231(m1,m2);
      	% re-order to get y-p-r, and convert to angles
      	euler(i,:) = [angs(2);angs(1);angs(3)]'/pi*180;
      end
   end
otherwise
   disp(strcat('Unsupported findeuler option: ',method));
   return
end


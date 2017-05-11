function dis = gldist(tra, trb)

% gives the euclidean distance between 2 transforms
% if the first argument is an array of transforms, dis will be an array of distances
% if the second argument is also an array of transforms, 

for i=1:size(tra,3),
   for j=1:size(trb,3),
      dis(i) = sqrt(sum((tra(1:3,4,i)-trb(1:3,4,j)).^2));
   end;
end;

     
   
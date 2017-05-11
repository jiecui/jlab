function contrib = find_projection(start,finish,trg)

%start = [1;1;1];
%trg = [2;6;10];
%trunk_max = [1;2;3];
%find_projection =  2.2235
contrib = [];
start_trg = trg-start;
mvt = finish-(ones(size(finish,1),1)*start);

% trunk_contrib = dot(start_trg,trunk_mvt)/(len(start_trg))
for i=1:size(mvt,1)
   contrib=[contrib;sum(start_trg.*mvt(i,:))/norm(start_trg.^2)];
end


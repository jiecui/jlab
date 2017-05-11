% do a repeated anova
cube = crunchcube(crunch, '2 4:10');
% limit the measures to those interesting ones
meas = [1:9 16:23];
cube = cube(:,meas,:,:);
meas_labels = crunch.measures(meas);
meas_labels(6) = cellstr('Average Velocity');
tl = crunch.subjects(2).slice_labels;
time_labels = [tl(length(tl)) tl(1:length(tl)-1) cellstr('All')];

% cube is cond x meas x time x subject

% open file
filename = 'uhh.csv';
fid = fopen(filename,'w');

if fid == -1
   disp('Unable to open file.');
   return
end

% print headers
% now loop through and give tblappend more casenames
for i=1:size(cube,1)
    for j=meas
        for k=1:size(cube,3)
            
        cnames = sprintf('%s, ', char(crunch.conditions(i)));
        
   

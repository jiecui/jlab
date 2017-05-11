% do a repeated anova
cube = crunchcube(crunch, '2 4:10');
% limit the measures to those interesting ones
meas = [1:9 16:23];
cube = cube(:,meas,:,:);
meas_labels = crunch.measures(meas);
meas_labels(6) = cellstr('Average Velocity');
tl = crunch.subjects(2).slice_labels;
time_labels = [tl(length(tl)) tl(1:length(tl)-1) cellstr('All')];
figure;


pvals = [];
pvalsrows = [];
pvalscols = [];
goodrows = [1 2 3 5 6 7];
goodcols = [1 2 3];
% cube is cond x meas x time x subj
for j=1:size(cube,2),
    for i=1:size(cube,1),      
        pvals(i,j) = repanova1miss(squeeze(cube(i,j,[1 4:size(cube,3)],:))','off');
        dat = squeeze(cube(i,j,[1 4:size(cube,3)],:))';
        datr = dat(goodrows,:);
        datc = dat(:,goodcols);
        pvalsrows(i,j) = repanova1(datr,'off');
        pvalscols(i,j) = repanova1(datc,'off');
    end
end

tblwrite(pvals,char(meas_labels),char(crunch.conditions),'pvals_repeated_missing.csv',',');
tblwrite(pvalsrows,char(meas_labels),char(crunch.conditions),'pvals_repeated_drop_subjects.csv',',');
tblwrite(pvalscols,char(meas_labels),char(crunch.conditions),'pvals_repeated_drop_repeats.csv',',');
function [ps,ps2,ps3,ps4] = DanaNormsanova(crunch)
% returns the 2-way data table
if ~isfield(crunch, 'subject_names')
   disp('Uninitialized crunchStruct! Must at least have subject_names field');
   return;
end

% know this is subject 1
norms = crunch.subjects(1);
data = norms.data.avg(:,:,2:17);
% 3d dim of data is the normal subject


% start slow, just L/R for each measure
% presized matrix of conditions x measures
% fvals = zeros(size(data(:,:,1)));
ps = zeros(size(data(:,:,1)));
groups = [1 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0];
ls = find(groups==0);
rs = find(groups==1);
for i=1:size(ps,1)
    for j=1:size(ps,2)
        mcdata = [squeeze(data(i,j,ls)) squeeze(data(i,j,rs))];
        ps(i,j) = anova1(mcdata, {'left', 'right'}, 'off');
    end
end

% tblwrite
tblwrite(ps,char(crunch.measures),char(crunch.conditions),'norm_l_vs_r.csv',',');

% tblwrite these?
ps2 = zeros(size(data(:,:,1:3)));
group = {{'right' 'left'   'left'  'right' 'right'  'left'   'right' 'left'  'right'  'left'   'right' 'left'  'right' 'left' 'right'  'left'};...
        {'female' 'female' 'male'  'male'  'female' 'female' 'male'  'male'  'female' 'female' 'male'  'male'  'male'  'male' 'female' 'female'};...
        {'young'  'young'  'young' 'young' 'old'    'old'    'young' 'young' 'old'    'old'    'young' 'young' 'old'   'old'  'old'    'old'}};

for i=1:size(ps,1)
    for j=1:size(ps,2)
        ps2(i,j,:) = anovan(squeeze(data(i,j,:)),group, 'linear', 3, {'LeftRight';'Sex';'Age'}, 'off');
    end
end

% tblwrite
tblwrite(ps2(:,:,1),char(crunch.measures),char(crunch.conditions),'norm_nway_l_vs_r.csv',',');
tblwrite(ps2(:,:,2),char(crunch.measures),char(crunch.conditions),'norm_nway_sex.csv',',');
tblwrite(ps2(:,:,3),char(crunch.measures),char(crunch.conditions),'norm_nway_age.csv',',');

% now see if it is any different for the unbalanced 2-way, separate for left and right
% first do the lefts, female young then old, male young then old
lset = [2 3 6 8 10 12 14 16];
lgrp = {group{2}(lset);group{3}(lset)};
ps3 = zeros(size(data(:,:,1:2)));
for i=1:size(ps,1)
    for j=1:size(ps,2)
        ps3(i,j,:) = anovan(squeeze(data(i,j,lset)), lgrp, 'linear', 3, {'Sex';'Age'}, 'off');
    end
end

% tblwrite
tblwrite(ps3(:,:,1),char(crunch.measures),char(crunch.conditions),'norm_nway_leftonly_sex.csv',',');
tblwrite(ps3(:,:,2),char(crunch.measures),char(crunch.conditions),'norm_nway_leftonly_age.csv',',');

% now the rights
rset = strmatch('right', group{1});
rgrp = {group{2}(rset);group{3}(rset)};
ps4 = zeros(size(data(:,:,1:2)));
for i=1:size(ps,1)
    for j=1:size(ps,2)
        ps4(i,j,:) = anovan(squeeze(data(i,j,rset)), rgrp, 'linear', 3, {'Sex';'Age'}, 'off');
    end
end

% tblwrite
tblwrite(ps4(:,:,1),char(crunch.measures),char(crunch.conditions),'norm_nway_rightonly_sex.csv',',');
tblwrite(ps4(:,:,2),char(crunch.measures),char(crunch.conditions),'norm_nway_rightonly_age.csv',',');


% 'NRFY901'
%     'NLFY901'
%     'NLMY902'
%     'NRMY903'
%     'NRFO904'
%     'NLFO904'
%     'NRMY905'
%     'NLMY905'
%     'NRFO907'  
%     'NLFO907'
%     'NRMY908'
%     'NLMY908'
%     'NRMO909'
%     'NLMO909'
%     'NRFO910'
%     'NLFO910'

function [results, project_files, comments, labels, measure_names, condition_names] = s102Lcalc()

global output_dir;

comments = {};
project_files = {};
% add as we go along
comments = [comments, {'Pre1 SC lft. inv'}];
project_files = [project_files {'Pre1_102L_1plus2.prj'}];
comments = [comments, {'Pre2 SC lft. inv'}];
project_files = [project_files {'Pre2_102L_3.prj'}];
comments = [comments, {'Post10Rx SC lft. inv.'}];
project_files = [project_files {'Post10_102L_16.prj'}];
%comments = [comments, {'Post20Rx-1 DP rt. inv. immed s/p 20Rx'}];
%project_files = [project_files {'Post20aR_inv101_26.prj'}];
%comments = [comments, {'Post20Rx-2 DP rt. inv. 1wk s/p 20 Rx'}];
%project_files = [project_files {'Post20bR_inv101_27.prj'}];
%comments = [comments, {'Post30Rx DP rt. inv immed s/p 30 Rx'}];
%project_files = [project_files {'Post30R_inv101_38.prj'}];

% labels will go into crunch plot for group labels -- will be one of:
% Pre1, Pre2, Post10, Post20a, Post20b, Post30
labels = [{'Pre1'} {'Pre2'} {'Post10'}];


%need to check delays for each file and also number of trials
delay_cells = {};
delay_cells{3} = [];
%set values below to be same as number of trials for each session
%1st session in this list
delays = ones(75,1)*3.0;
delay_cells{1} = delays;
%2nd session in this list
delays = ones(70,1)*3.0;
delay_cells{2} = delays;
% 3d session in this list
delays = ones(75,1)*3.0;
delay_cells{3} = delays;
% 4th session in this list
%delays = ones(70,1) *3.0;
%delay_cells{3} = delays;
% 5th session in this list
%delays = ones(70,1) *3.0;
%delay_cells{4} = delays;
% 6th session in this list
%delays = ones(70,1) *3.0;
%delay_cells{5} = delays;

target_cells = {};
target_cells{3} = [];
% 1st session in this list
targets = ones(75,3)*3.0;
target_cells{1} = targets;
% 2d session in this list
targets = ones(70,3)*3.0;
target_cells{2} = targets;
% 3d session in this list
targets = ones(75,3)*3.0;
target_cells{3} = targets;
% 4th session in this list
%targets = ones(70,3) *3.0;
%target_cells{3} = targets;
% 5th session in this list
%targets = ones(70,3) *3.0;
%target_cells{4} = targets;
% 6th session in this list
%targets = ones(70,3) *3.0;
%target_cells{5} = targets;

ppfilename = 'S102L_PrePost.csv';
[results, measure_names, condition_names] = dana_calc_sessions('S102L_TrCnd.csv', ppfilename, project_files, comments, delay_cells, target_cells);

try
   copyfile(ppfilename , strcat(output_dir,'\',ppfilename));
catch
   return
end
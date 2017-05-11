function [results, c_res, column_names, row_names] = proj_calculate(project, delays, stats_flags, conditions_cells, sensor_no)
% calculates all the statistics
% project has a cell array of conditions n by 2, cond scene
% stats is a bunch of flags, so I may need to first convert
% those that are 1 to a cell array of strings listing the currently
% turned on stats calcs
% 
p = project;
ps = project.session_info;
cc = p.conditions_cells;
% main steps are:
% 1. calculate for each trial

% ok, need to parse out the trials indices
%trial_strings = char(project.trial_list);
trial_indices = [];
for i=1:length(p.trials_list),
   % first check if it is associated with a condition
   nm = ps.scene_names(sscanf(char(project.trials_list(i)), '%d', 1));
   if sum(strcmp(nm, char(cc(:, 2)))),
      trial_indices = [trial_indices sscanf(char(project.trials_list(i)), '%d', 1)];
   end;
end;

% set up conditions_indices
% first sort local copy cc
[srtd, cci] = sort(cc(:,1));
cc = cc([cci],:);
for i=1:size(cc, 1),
   [c, b, conditions_indices{i}] = intersect(find(strcmp(char(cc(i, 2)),...
      ps.scene_names)), trial_indices);
end;
conditions_indices;
trial_indices;

% make stats cell
if nargin > 2,
   sf = stats_flags;
else
   if isfield(p, 'stats_flags')
      sf = p.stats_flags;
   end
end;

if nargin > 2,
   delays = delays([trial_indices]);
end;

column_names = {};
results = [];
% put in cond name, scene name, trial #
column_names = [column_names {'Condition,Scene Name,Trial #'}];
results = [results trial_indices'];

ts = p.ii([trial_indices]);
te = p.iif([trial_indices]);
spillsess = ps;
spillsess.trial_start = ts;
spillsess.trial_end = te;

column_names = [column_names {'Path Length Hand'}];
column_names = [column_names {'Path Length Trunk'}];
if nargin < 2,
   results = [results pathlength(spillsess, 1, 1)];
   results = [results pathlength(spillsess, 3, 1)];
else,
   results = [results pathlength(spillsess, 1, 1, delays)];
   results = [results pathlength(spillsess, 3, 1, delays)];
end;

% now spills
%copy session info
% omit the last argument (bottom_held_cup_diam )to spill_stats if you don't want to adjust for the cup "flange" angle
sr = spill_stats(spillsess, 10.395, 8.5, 10.495, 7.0, 6.2);
results = [results sr.spill_time sr.pour_time sr.pour_x_mn sr.pour_y_mn sr.pour_z_mn ...
      sr.pour_x_std sr.pour_y_std sr.pour_z_std sr.pour_std_volume sr.pour_enclose_volume];
column_names = [column_names {'Spill Time'}];
column_names = [column_names {'Pour Time'}];
column_names = [column_names {'Pour X Mean'}];
column_names = [column_names {'Pour Y Mean'}];
column_names = [column_names {'Pour Z Mean'}];
column_names = [column_names {'Pour X Std'}];
column_names = [column_names {'Pour Y Std'}];
column_names = [column_names {'Pour Z Std'}];
column_names = [column_names {'Pour Std Volume'}];
column_names = [column_names {'Pour Enclose Volume'}];

% now movement_time
if nargin < 2,
   results = [results movement_time(spillsess)];
else,
   results = [results movement_time(spillsess, delays)];
end;
column_names = [column_names {'Response Time (sec)'}];

% how about velocity peaks
results = [results velocity_peaks(spillsess, 11, 3, 1)];
column_names = [column_names {'# Velocity Peaks'}];
   

% overall trials
overall_avg = mean(results);
overall_std = std(results);

% add more conditions with more stats_flags!!
% now work on the dconditions-level stuff
%OK, now we have the results, want to go through each condition_cell, use conditions_indices to get the
% results sub-array for that condition, and do some stats!!
cond_results = {};
cond_avg = [];
cond_std = [];
%for ci=conditions_indices,
for i=1:length(conditions_indices),
   subresults = results([conditions_indices{i}],:);
   nzmn = [];
   nzstd = [];
   fi = find(subresults(:,5));
   %if (isempty(fi)),
      
   for j=1:length(column_names),
      % determine trials to be ignored, and/or condition is to be ignored
    	if (j > 3 & j < 14),
         % hacky way to ignore zeros on spill trials
         nzmn = [nzmn mean(subresults([fi],j))];
         nzstd = [nzstd std(subresults([fi],j))];
      else
         nzmn = [nzmn mean(subresults(:,j))];
         nzstd = [nzstd std(subresults(:,j))];
      end;
   end;
   cond_results = [cond_results {subresults}];
   cond_avg = [cond_avg; nzmn];
   cond_std = [cond_std; nzstd];
end;

% put into condition-level struct
c_res.results = cond_results;
c_res.avg = cond_avg;
c_res.std = cond_std;

% make row_names and add overall stats
c_res.names = {};
row_names = cell(length(trial_indices),1);
for i=1:length(conditions_indices),
   row_names([conditions_indices{i}]) = cellstr(sprintf('%s,%s', cc{i,1}, cc{i,2}));
   c_res.names = [c_res.names {sprintf('%s,%s', cc{i,1}, cc{i,2})}];
end;
[srtd, rni] = sort(row_names);
row_names = srtd;
results = results([rni],:);
row_names = [row_names; cellstr('Overall Mean,')];
row_names = [row_names; cellstr('Overall Std,')];
results = [results;overall_avg;overall_std];
  
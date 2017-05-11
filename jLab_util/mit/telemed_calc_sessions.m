function [cond_results, measure_names, condition_names] = telemed_calc_sessions(trial_data_filename, measure_data_filename, project_files, comments)
% this script will crunch mult. sessions' data!
% set up cell arrays of strings for each project file and comments
% loop over these and keep writing out to a csv file
%
% then loop over each measure, for each patient...

cond_results = {};
% open file for write
fid = fopen(trial_data_filename, 'w');
for i=1:length(project_files),
    cp = load(char(project_files(i)), '-MAT');
    cp = cp.current_proj;
    % tr stands for 'temporary results'
    tr.results = [];
    if isfield(cp.session_info, 'delays')
        [tr.results, tr.cond_res, tr.colnames, tr.rownames] = telemed_proj_calculate(cp,cp.session_info.delays);
    else
        [tr.results, tr.cond_res, tr.colnames, tr.rownames] = telemed_proj_calculate(cp,ones(200,1)*3.0);
    end
    %check for error
    if ~isempty(tr.results),
        cond_results = [cond_results tr.cond_res];
        % write out comment header
        fwrite(fid, sprintf('%s\n', char(comments(i))), 'uchar');
        mycsvwrite(fid, tr.rownames, tr.colnames, tr.results);
        % now go for condition-level stuff
        fwrite(fid, sprintf('\n\n%s\n', 'Condition Means'), 'uchar');
        fwrite(fid, sprintf('%s\n', char(comments(i))), 'uchar');
        mycsvwrite(fid, tr.cond_res.names, tr.colnames, tr.cond_res.avg);
        fwrite(fid, sprintf('\n\n%s\n', 'Condition Standard Deviations'), 'uchar');
        fwrite(fid, sprintf('%s\n', char(comments(i))), 'uchar');
        mycsvwrite(fid, tr.cond_res.names, tr.colnames, tr.cond_res.std);
        if (i < length(project_files)),
            fwrite(fid, sprintf('\n\n'), 'uchar');
        end;
    end;
end;
fclose(fid);

% next major section is for statistics-level stuff
% for each statistic, we grab the condition-level
% mean, std for each project file. Some of those project
% files may be split, so we have to "cat" two of them

% TO DO: [X] put in sensor 3 Path length
%        [X] put in overall averages
%        [X] sort everything
%
% Now  we have all results, and sub-results, and averages sorted by condition


% open file for write
fid = fopen(measure_data_filename, 'w');

% write out a little header here?

mnstr = 'Mean';
stdstr = 'Std. Dev.';
for i=2:length(tr.colnames),
   % write out header mentioning Measure Name
   fwrite(fid, sprintf('Statistics for %s\n\n', char(tr.colnames(i))), 'uchar');
   h1 = {','};
   h2 = {'Condition,Scene Name'};
   cond_data = [];
   for j=1:length(cond_results),
      % write out the project filename and comments for each session
      ch1 = sprintf('%s,%s', char(project_files(j)), char(comments(j)));
      % add 'Mean','Stand Dev'
      ch2m = sprintf('%s', mnstr);
      ch2s = sprintf('%s', stdstr);
      %if (j < length(project_files))
      %   ch1 = strcat(ch1, ',');
      %   ch2s = strcat(ch2s, ',');
      %end
      h1 = [h1 {ch1}];
      % fugly hack to handle correct number of column names for mycsvwrite
      if (j == 1),
         h2 = [h2 {strcat(ch2m, ',', ch2s)}];
      else
         h2 = [h2 {ch2m ch2s}];
      end;
      
      % build mean and std data matrix
      cond_data = [cond_data cond_results(j).avg(:,i)];
      cond_data = [cond_data cond_results(j).std(:,i)];
   end;
   % write out header listing in loop, fugly
   for k=1:length(h1),
      fwrite(fid, char(h1(k)), 'uchar');
      if (k < length(h1))
         fwrite(fid, sprintf(','), 'uchar');
      end;
   end;
   fwrite(fid, sprintf('\n'), 'uchar');
   % add mean and std
   rn = [cond_results(1).names {'Overall Mean,' 'Overall Std,'}];
   % will have to go col-by-col here
   cdm = [];
   cdst = [];
   for m=1:size(cond_data,2),
      non_nan= cond_data([find(~isnan(cond_data(:,m)))],m);
      non_zero = non_nan([find(non_nan)]);
      cdm = [cdm mean(non_zero)];
      cdst =[cdst std(non_zero)];
	end;
   cond_data = [cond_data;cdm;cdst];
   mycsvwrite(fid, rn, h2, cond_data);
   if (i < length(tr.colnames))
      fwrite(fid, sprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n\n'), 'uchar');
   end;
end;
fclose (fid);

% set up return args
measure_names = tr.colnames;
condition_names = tr.cond_res.names;
% know that first two column_names are bogus
% [tr.results, tr.cond_res, tr.colnames, tr.rownames]




function [results, c_res, column_names, row_names] = telemed_proj_calculate(project, delays)
% calculates all the statistics
% project has a cell array of conditions n by 2, cond scene
% stats is a bunch of flags, so I may need to first convert
% those that are 1 to a cell array of strings listing the currently
% turned on stats calcs
% 
results = [];
c_res = [];
column_names = [];
row_names = [];

p = project;
ps = project.session_info;
cc = p.conditions_cells;
if isempty(cc),
   warning(sprintf('No conditions specified for this project named %s, no calculations will be performed for this project.', p.name));
   return;
end;

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

% set up conditions_indices, which is a cell array of arrays, each element tells which
% trials are associated with a particular condition

% first sort local copy cc based on alphabet -- now conditions will be reported in alphabetical order
[srtd, cci] = sort(lower(cc(:,1)));
cc = cc([cci],:);
for i=1:size(cc, 1),
   [c, b, conditions_indices{i}] = intersect(find(strcmp(char(cc(i, 2)),...
      ps.scene_names)), trial_indices);
end;

% find non-empty conditions, which is the case when there are no trials for a particular condition
nepc = [];
for curcond = 1:size(conditions_indices,2),
   if isempty(conditions_indices{curcond}),
      disp(sprintf('Warning: In project: %s%s', p.pathname, p.filename));
      disp(sprintf('No trials are associated with condition: %s\n\n', char(cc(curcond,1))));
   end;
end;
%cc = cc([nepc],:);

% make stats cell
if nargin > 3,
   sf = stats_flags;
else
   if isfield(p, 'stats_flags')
      sf = p.stats_flags;
   end
end;


if nargin > 2,
   targets = targets([trial_indices],:);
end;


if nargin > 1,
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
spillsess.scene_names = spillsess.scene_names([trial_indices]);
spillsess.kepttrials = trial_indices;

% hack to get bad_sensor_2 stuff working. This var should be in the session from the beginning!
if isfield(p,'bad_sensor_2_trials')
    spillsess.bad_sensor_2_trials = p.bad_sensor_2_trials;
end

column_names = [column_names {'Path Length Hand'}];
column_names = [column_names {'Path Length Trunk'}];
if nargin < 2,
   results = [results pathlength(spillsess, 1, 1)];
   results = [results pathlength(spillsess, 3, 1)];
else,
   results = [results pathlength(spillsess, 1, 1, delays)];
   results = [results pathlength(spillsess, 3, 1, delays)];
end;

% remember hand path for speed calculation later
hand_path_index = size(results,2)-1;

% now spatial error and arm extension -- side-effect will be that spatial errors and indices
% are now stored in the .trialstats.spatial_error and .trunk_error members of session, for
% later extraction by the arm measures, and phase plotting routines
spillsess = dana_targets(spillsess);
[spillsess, sp_err, corrected_sp_err] = dana_spatial_error(spillsess);
results = [results sp_err corrected_sp_err];
column_names = [column_names {'Spatial Error (cm)'}];
%corrected_sp_error = dana_spatial_error(spillsess, targets, 1, 1);
%results = [results corrected_sp_error];
column_names = [column_names {'Trunk-Corrected Spatial Error (cm)'}];


% now movement_time
if nargin < 2,
   results = [results movement_time(spillsess)];
else,
   results = [results movement_time(spillsess, delays)];
end;
column_names = [column_names {'Response Time (sec)'}];

% speed
results = [results results(:,hand_path_index)./results(:,size(results,2))];
column_names = [column_names {'Average Velocity (cm/sec)'}];


% how about velocity peaks
results = [results velocity_peaks(spillsess, 11, 3, 1)];
column_names = [column_names {'# Velocity Peaks'}];

% now maximum velocity peak value and time of peak 
[peak_val, time_at_peak] = find_high_peak_velocity(spillsess, 11, 3, 1);
results = [results peak_val time_at_peak];
column_names = [column_names {'Peak Velocity'}];
column_names = [column_names {'% Movement at Peak Velocity'}];

% orientation error
[spillsess, orient_error, orient_angles, orient_at_best_dist, dist_at_best_orient] = dana_orient_error(spillsess);
results = [results orient_error orient_angles];
column_names = [column_names {'Orientation Error'}];
column_names = [column_names {'Yaw Error'}];
column_names = [column_names {'Pitch Error'}];
column_names = [column_names {'Roll Error'}];

% distance error at best orientation error
% orientation error at best distance error
results = [results dist_at_best_orient orient_at_best_dist];
column_names = [column_names {'Distance Error at Best Orientation Error'}];
column_names = [column_names {'Orientation Error at Best Distance Error'}];

% calculate the max supination, max elbow flexion
%spillsess = dana_calc_arm(spillsess);
% recalc arm data
spillsess = dana_calc_arm(spillsess);
[maxsup, minflex, supminflex, flexmaxsup, flexdist, distflex, supdist, distsup] = dana_arm_error(spillsess);
results = [results maxsup minflex supminflex flexmaxsup flexdist distflex supdist distsup];
column_names = [column_names {'Max Supination'}];
column_names = [column_names {'Min Elbow Flexion'}];
column_names = [column_names {'Supination at Min Elbow Flexion'}];
column_names = [column_names {'Elbow Flexion at Max Supination'}];
column_names = [column_names {'Elbow Flexion at Best Distance Error'}];
column_names = [column_names {'Distance Error at Min Elbow Flexion'}];
column_names = [column_names {'Supination at Best Distance Error'}];
column_names = [column_names {'Distance Error at Max Supination'}];

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
   for j=1:length(column_names),
      % determine trials to be ignored, and/or condition is to be ignored
      if isempty(subresults(:,j)),
         nzmn =  [nzmn NaN];
         nzstd = [nzstd NaN];
      else,
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
  
   
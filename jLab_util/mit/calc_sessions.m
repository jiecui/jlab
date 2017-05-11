function calc_sessions(trial_data_filename, measure_data_filename, project_files, comments, delay_cells, target_cells)
% this script will crunch mult. sessions' data!
% set up cell arrays of strings for each project file and comments
% loop over these and keep writing out to a csv file
%
% then loop over each measure, for each patient...

if nargin > 4,
   use_delays = 1;
else
   use_delays = 0;
end;

if nargin > 5,
   use_targets = 1;
else
   use_targets = 0;
end;

cond_results = {};
% open file for write
fid = fopen(trial_data_filename, 'w');
for i=1:length(project_files),
   cp = load(char(project_files(i)), '-MAT');
   cp = cp.current_proj;
   % tr stands for 'temporary results'
   if (use_targets & ~isempty(target_cells{i}))
      [tr.results, tr.cond_res, tr.colnames, tr.rownames] = proj_calculate(cp,delay_cells{i},target_cells{i});
   else if (use_delays & ~isempty(delay_cells{i}))
		[tr.results, tr.cond_res, tr.colnames, tr.rownames] = proj_calculate(cp,delay_cells{i});
	else
      [tr.results, tr.cond_res, tr.colnames, tr.rownames] = proj_calculate(cp);
   end
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
   for j=1:length(project_files),
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

% know that first two column_names are bogus
% [tr.results, tr.cond_res, tr.colnames, tr.rownames]


   
function[num, scenes, session_info] = load_scene_data(fname, data, trial_start, tch_start)
% load_scene_data reads the scene info (.VR filenames for now) from a raw data file
% and associates trial and teacher start locations in the data matrix to them
% need to work out how this will integrate with the GUI.

num_scenes = 0; % number of scenes so far
num_trials = 0; % number of trials so far
new_scene = 0;  % flag that scene has just been added
fp = fopen(fname, 'r');
if( fp == -1 ),
   return;
end;
scene_string = ' ';
while ~feof(fp),
   line = fgets(fp);
   scn = sscanf( line, '%s', 2 );
   result = findstr(scn, '%SCENE');
   if( result ),
      scn = scn(:,7:length(scn));
      current_scene = scn;
      if( num_scenes > 0 ),
         scene_string = strcat( scene_string, sprintf('%d |', num_trials));
      end;
      num_scenes = num_scenes + 1;
      scene_string = strcat(scene_string, sprintf('%d: %s,', num_scenes,scn));
      new_scene = 1;
      block(num_scenes).ntrial = 0;
      block(num_scenes).nstart = 0;
      block(num_scenes).nend = 0;
     	block(num_scenes).tch_ndata = 0;
      block(num_scenes).tch_originaltime = 0;
   end;
   % check for teacher
   result = findstr(scn, '%TEACHER');
   if( result ),
   	tch = data(tch_start(num_scenes),:)';
   	block(num_scenes).tch_ndata = tch(2);
      block(num_scenes).tch_originaltime = tch(3);
   end;
   % check for trial
   result = findstr(scn, '%TRIAL');
   if( result ),
      % increment number of trials
      num_trials = num_trials + 1;
      % assign variable to tell which block this trial is in
      trial_assignments(num_trials) = num_scenes;
      % increment block variables 
      block(num_scenes).ntrial = block(num_scenes).ntrial + 1;
      block(num_scenes).nend = num_trials;
		% read in trial-specific settings
      curtrial = block(num_scenes).ntrial; % local for readability
      trl = data(trial_start(num_trials), :)';
      block(num_scenes).restrict(curtrial) = trl(2);
		block(num_scenes).from(curtrial)= trl(3);
		block(num_scenes).to(curtrial) = trl(4);
		block(num_scenes).speed(curtrial) = trl(5);
		block(num_scenes).ndata(curtrial) = trl(7);
      block(num_scenes).originaltime(curtrial) = trl(8);
      block(num_scenes).ndatabase(curtrial) = trl(10);
      % record the scene name for this trial
      scene_names{num_trials} = current_scene;

		if( new_scene ),
         % assign block variable the trial number where this scene starts
         block(num_scenes).nstart = num_trials;
         % indicate the first trial number for the scene and reset the new_scene flag
         scene_string = strcat( scene_string, sprintf('   Trials:  %d-', num_trials) );
         new_scene = 0;
      end;
   end;
end;
% done processing the file, so we write the last trial number to the scene_string
scene_string = strcat( scene_string, num2str(num_trials) );
num = num_scenes;
scenes = scene_string;
session_info.blocks = block;
session_info.trial_in_block = trial_assignments';
session_info.scene_names = scene_names;
fclose(fp);
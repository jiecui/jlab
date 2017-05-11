function [sessname, imported_data] = import_edfs( handles , tag, prefix, dlg_options, directory, files, session_name)
% [sessname, imported_data, trial_length] = import_edfs( handles , tag, prefix [,directory, files, session_name ])
%
% Read EDF files and import the data into matlab vars
% Imput:
%	handles :		gui data
%	tag :			tag of the session that is being created
%	prefix :		prefix for the session name
%	dlg_options(1) :use button 2 to define trials
%	dlg_options(2) :ask for trial length
%	dlg_options(3) :ask for invalid trials
%	directory :     directory of the files
%	files :			list of files to import
%	session_name :	name of the session
% Output :
%	sessname:
%	imported_data.edf_samples(:,1)	= Eyelink raw data (HREF, nans and blinks) [timestamps, left_x, right_x, left_y, right_y, left_pupil, right_pupil];
%	imported_data.samples(:,1)		= [timestamps, left_x, left_y, right_x, right_y, left_pupil, right_pupil];
%	imported_data.blinkYesNo		= blinkYesNo(1:end-1);
%	imported_data.blinks			= timestamps and data for blinks
%	imported_data.events			= timestamps and data for events
%	imported_data.saccades			= timestamps and data for saccades
%	imported_data.nsamples			= number of samples that have been imported
%	imported_data.trial_length		= lenght of the trials in the experiment
%	imported_data.samplerate		= sample rate of the data

BLINKS_GAP			= 100;	% samples

sessname		= [];
imported_data	= [];

%% -- Get the filenames to import from the dialog
trial_length	= 30;
invalid_trials	= [];
type_of_data	= 'href';
use_button2		= 1;
flipH			= 0;
flipV			= 1;
sort_by_timestamp = 0;
if ( ~exist( 'directory', 'var' ) )
	if ( dlg_options(2) )
		S.Trial_Length		= { 30 '* (s)' [0 300] };
	end
	if ( dlg_options(3) )
		S.Invalid_Trials	= {''};
	end
	if ( dlg_options(1) )
		S.Use_button2		= { {'0', '{1}'}};
	end
	S.Flip_Horizontal	= { {'{0}'  , '1'}};
	S.Flip_Vertical		= { {'0'    , '{1}'}};
	S.Sort_by_timestamp = { {'{0}'  , '1'}};

	[filenames, getpathname, sessname, S] = import_files_dialog( prefix, tag, 'EDF', S );
	if ( isempty( filenames ) )
		return
	end
	if ( dlg_options(2) )
		trial_length	= S.Trial_Length;
	end
	if ( dlg_options(3) )
		numbers = regexp( S.Invalid_Trials, '(\d+)', 'tokens' );
		for i =1:length(numbers)
			number=numbers{i};
			invalid_trials(end+1) = str2int(char(number));
		end
	end
	if ( dlg_options(1) )
		use_button2	= S.Use_button2;
	end
	flipH				= S.Flip_Horizontal;
	flipV				= S.Flip_Vertical;
	sort_by_timestamp	= S.Sort_by_timestamp;
else
	sessname		= session_name;
	filenames		= files;
	getpathname		= directory;
end

%% -- Import the files into matlab variables
try
	msg = [];
	%% -- Read the files to matlab variables
	hwait = waitbar(0,'Please wait while EDF Files are read...');
	for j=1:length(filenames)
		[dat(j).samples, dat(j).blinks, dat(j).buttons, dat(j).saccades, msg_file, warnings, dat(j).samplerate] = edf_read_file3( fullfile( getpathname, char(filenames(j)) ) );
		dat(j).name = char(filenames(j));
		msg = [msg char(filenames(j)) ' : ' msg_file ' \n\r'];
		
		waitbar( j/length(filenames), hwait);
	end
	close(hwait);
catch
	close(hwait);
	rethrow(lasterror);
end

SAMPLERATE = unique( struct2array(dat,'samplerate') );
if ( length(SAMPLERATE) > 1 )
	errordlg( 'It is not possible to combine files with different samplerate');
end

%% -- sort by timestamp
if ( sort_by_timestamp )
	for j=1:length(dat)
		if ~isempty(dat(j).samples),
			ts(j) = dat(j).samples(1,1);
		elseif ~isempty(dat(j).buttons)
			ts(j) =  dat(j).buttons(1,1);
		else
			ts(j) = -Inf;
		end
	end
	[ts,i] = sort(ts);
	dat = dat(i);
end

%% -- fix timestamps
for j=1:length(dat)-1
	
	% check that the number of recording on and off is the same
	b11 = find(dat(j).buttons(:,2)==1 & dat(j).buttons(:,3)==1);
	b10 = find(dat(j).buttons(:,2)==1 & dat(j).buttons(:,3)==0);
	b21 = find(dat(j).buttons(:,2)==2 & dat(j).buttons(:,3)==1);
	b20 = find(dat(j).buttons(:,2)==2 & dat(j).buttons(:,3)==0);
	b31 = find(dat(j).buttons(:,2)==3 & dat(j).buttons(:,3)==1);
	b30 = find(dat(j).buttons(:,2)==3 & dat(j).buttons(:,3)==0);
	if( strcmp(char(filenames{j}),'JOM7H03C.EDF') )
		dat(j).buttons([ b11(1) b10(1:2)' b21(1) b20(1:2)' b31(1) b30(1:2)' ],:) = [];
	end
	
	% find first and last timestamp
	lasttimestamp	= max( [dat(j).samples(end,1) dat(j).buttons(end,1)] );
	firsttimestamp	= min( [dat(j+1).samples(1,1) dat(j+1).buttons(1,1)] );
	% 	diff = lasttimestamp - firsttimestamp + 100; % small gap
	diff = lasttimestamp - firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
	% redo sample timestamps
	dat(j+1).samples(:,1) = dat(j+1).samples(:,1) + diff;
	% redo blinks
	dat(j+1).blinks(:,1:2) = dat(j+1).blinks(:,1:2) + diff;
	% redo buttons
	dat(j+1).buttons(:,1) = dat(j+1).buttons(:,1) + diff;
	% saccades
	dat(j+1).saccades(:,1:2) = dat(j+1).saccades(:,1:2) + diff;
end

%% -- concatenate files
compdat = [];
compdat.samples = [];compdat.buttons = [];compdat.blinks = [];compdat.saccades = [];
for i=1:length(dat);
	compdat= vertcatstruct(compdat,dat(1),{'samples' 'buttons' 'blinks' 'saccades'});
    dat(1) = [];
end
clear dat;


%% -- Pre-process eye data --------------------------------------

% -- Interpolate blinks in the data
[samples blinkYesNo] = interpolate_blinks(compdat.samples, compdat.blinks, BLINKS_GAP);

% -- Flip necessary components
if ( flipH )
	samples(:,2) = -samples(:,2);
	samples(:,3) = -samples(:,3);
end
if ( flipV )
	samples(:,4) = -samples(:,4);
	samples(:,5) = -samples(:,5);
end

% -- Convert to DVA ( Degrees of the Visual Angle )
isgaze = 0;
if ( length(warnings) > 1 )
	if ( ~isempty(cell2mat(strfind(warnings, 'preferred sample type HREF not available: using GAZE data' ))))
		msgbox('WARNING: Preferred sample type HREF not available: using GAZE data');
		isgaze = 1;
	end
end
if ( ~isgaze)
	dva = HREF2dva(samples);
else
	dva = GAZE2dva(samples);
end

%% correction for 080703A.EDF
if ( sum(strcmp(filenames, '070803A.EDF' ) ))
	% first switch eyes
	dva = dva(:,[3 4 1 2]);
	% scale X axes
	dva(:,3) = 2.5*dva(:,3)-8;
	% scale Y axes
	dva(:,4) = 3.5*dva(:,4)+15;
	% cut last chunk of data
	dva(80000:end,:) = [];
	blinkYesNo(80001:end,:) = [];
end

%% -- commit final variables
imported_data.edf_samples	= compdat.samples;
compdat = rmfield(compdat, 'samples');
samples(end,:) = [];
samples(:,2:5) = dva;
imported_data.samples = samples;
% imported_data.samples(:,1)	= samples(1:end-1, 1);
% imported_data.samples(:,2:5)= dva;
% imported_data.samples(:,6:7)= samples(1:end-1, 6:7);

imported_data.blinkYesNo	= blinkYesNo(1:end-1);
imported_data.blinks		= compdat.blinks;
imported_data.events		= compdat.buttons;
imported_data.saccades		= compdat.saccades;


imported_data.nsamples		= length(dva);
imported_data.trial_length	= trial_length;
imported_data.samplerate	= SAMPLERATE;

improted_data.msg			= msg;
imported_data.invalid_trials = invalid_trials;

imported_data.info.samplerate           = SAMPLERATE;
imported_data.info.import.folder        = getpathname;
imported_data.info.import.filenames     = filenames;
imported_data.info.import.use_button2	= use_button2;
imported_data.info.import.date          = datestr(now);

% --------------------------------------------------------------------
function structcat = vertcatstruct(struct1,struct2,fldnames)
for fdn = fldnames
	structcat.(char(fdn)) = [struct1.(char(fdn));struct2.(char(fdn))];
end

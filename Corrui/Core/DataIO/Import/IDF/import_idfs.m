function [sessname, imported_data] = import_idfs( this, dlg_options, directory, files, session_name)
% [sessname, imported_data, trial_length] = import_idfs( tag, prefix [,directory, files, session_name ])
%
% Read IDF files and import the data into matlab vars
% Imput:
%	tag :			tag of the session that is being created
%   db :            CorruiDB object
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

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 1.7 $  $Date: Tue 09/03/2013 10:10:14.838 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

tag = class(this);
% db = this.db;
prefix = this.prefix;

BLINKS_GAP			= 100;	% samples
SAMPLERATE          = 500;
sessname		= [];
imported_data	= [];

%% -- Get the filenames to import from the dialog
trial_length	= 30;
invalid_trials	= [];
type_of_data	= 'href';
S = [];
if ( ~exist( 'directory', 'var' ) )
	if ( dlg_options(2) )
		S.Trial_Length		= { 30 '* (s)' [0 300] };
	end
	if ( dlg_options(3) )
		S.Invalid_Trials	= {''};
    end

	[filenames, getpathname, sessname, S] = import_files_dialog( prefix, tag, 'IDF', S );
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
else
	sessname		= session_name;
	filenames		= files;
	getpathname		= directory;
end

%% -- Import the files into matlab variables
try
	msg = [];
	%% -- Read the files to matlab variables
	hwait = waitbar(0,'Please wait while IDF Files are read...');
    for j=1:length(filenames)
        filename = fullfile( getpathname, char(filenames(j)) );
        txtfilename = [filename(1:end-4) ' Samples.txt'];
        eval(['!IDFConverter.exe ' filename ]);

        perl1(['-n -i.orig -e "print if !/\s*#.* /" "' txtfilename '"']);
        perl1(['-n -i.orig -e "print if !/\s*T.* /" "' txtfilename '"']);
        perl1(['-n -i.orig -pe s/[a-zA-Z]//g "' txtfilename '"'])

        data = load(txtfilename);
        %%
        dat(j).samples = data(:,[1 15 16 17 18 7 9]);
        dat(j).samples(:,1) = round(dat(j).samples(:,1)/1000);
        dat(j).samplerate = 500;
        dat(j).buttons = [];
        dat(j).idf_samples = data;
        
        
        
        eval(['!IDFEventDetector.exe ' filename ]);
        txtfilename = [filename(1:end-4) ' Events.txt'];
        perl1(['-n -i.orig -e "print if /Blink.* /" "' txtfilename '"']);
        perl1(['-n -i.orig -pe s/L/1/g "' txtfilename '"'])
        perl1(['-n -i.orig -pe s/R/2/g "' txtfilename '"'])
        perl1(['-n -i.orig -pe s/[a-zA-Z]//g "' txtfilename '"'])
        data = load(txtfilename);
        
        dat(j).blinks = data(:,[4 5 1]);
        dat(j).blinks(:,[1 2]) = round(dat(j).blinks(:,[1 2])/1000);
        
        
        dat(j).saccades = [];
		dat(j).name = char(filenames(j));
		
		waitbar( j/length(filenames), hwait);
	end
	close(hwait);
catch
	close(hwait);
	rethrow(lasterror);
end


%% -- sort by timestamp
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


%% -- fix timestamps
for j=1:length(dat)-1
	
	% find first and last timestamp
	lasttimestamp	= max( [dat(j).samples(end,1) dat(j).buttons(end,1)] );
	firsttimestamp	= min( [dat(j+1).samples(1,1) dat(j+1).buttons(1,1)] );
	% 	diff = lasttimestamp - firsttimestamp + 100; % small gap
	diff1 = lasttimestamp - firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
	% redo sample timestamps
	dat(j+1).samples(:,1) = dat(j+1).samples(:,1) + diff1;
	% redo sample timestamps
	dat(j+1).idf_samples(:,1) = dat(j+1).idf_samples(:,1) + diff1;
	% redo blinks
	dat(j+1).blinks(:,1:2) = dat(j+1).blinks(:,1:2) + diff1;
	% redo buttons
	dat(j+1).buttons(:,1) = dat(j+1).buttons(:,1) + diff1;
	% saccades
	dat(j+1).saccades(:,1:2) = dat(j+1).saccades(:,1:2) + diff1;
end

%% -- concatenate files
compdat = [];
compdat.samples = [];compdat.idf_samples = [];compdat.buttons = [];compdat.blinks = [];compdat.saccades = [];
for i=1:length(dat);
	compdat= vertcatstruct(compdat,dat(1),{'samples' 'buttons' 'blinks' 'saccades' 'idf_samples'});
    dat(1) = [];
end
clear dat;


%% -- Pre-process eye data --------------------------------------
if (0 )
    if ( mean(compdat.samples(:,6)) > 10 && mean(compdat.samples(:,6)) < 50 ) % if data is diameter
        d = diff(compdat.samples(:,6));
        if ( min(d(d>0)) == 1 )
            blinks = abs(diff(min(compdat.samples(:,6),compdat.samples(:,7))))>5;
        else
            %% redetect blinks
            blinks = (newboxcar((abs(diff(min(compdat.samples(:,6),compdat.samples(:,7))))>.8),100)> .01);
        end
        b1 = find(diff([0;blinks])>0);
        b2 = find(diff([blinks;0])<0);
        compdat.blinks = [compdat.samples(b1,1) compdat.samples(b2,1) ones(size(b1))];
    end
end
% -- Interpolate blinks in the data
[samples blinkYesNo] = interpolate_blinks(compdat.samples, compdat.blinks, BLINKS_GAP);

% -- Convert to DVA ( Degrees of the Visual Angle )
dva = zeros(length(samples), 4);
dva(:,[1 3]) = atan((samples(:,[2 4])*41/1280-20.5)/60)*180/pi;
dva(:,[2 4]) = atan((samples(:,[3 5])*-31/1024+15.5)/60)*180/pi;

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
imported_data.idf_samples	= compdat.idf_samples;
compdat = rmfield(compdat, 'idf_samples');
samples(end,:) = [];
samples(:,2:5) = dva(1:end-1,:);
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
imported_data.info.import.date          = datestr(now);

% --------------------------------------------------------------------
function structcat = vertcatstruct(struct1,struct2,fldnames)
for fdn = fldnames
	structcat.(char(fdn)) = [struct1.(char(fdn));struct2.(char(fdn))];
end

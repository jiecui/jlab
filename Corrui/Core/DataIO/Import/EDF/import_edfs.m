function [sessname, imported_data, options] = import_edfs( tag, db, prefix, directory, filenames, sessname, options)
% [sessname, imported_data] = import_edfs( tag, prefix [,directory, files, sessname ])
%
% Read EDF files and import the data into matlab vars
% Imput:
%	tag :			tag of the session that is being created
%   db :            CorruiDB object
%	prefix :		prefix for the session name
%	directory :     directory of the files
%	files :			list of files to import
%	sessname :      name of the session
%   options:        options for the import
% 
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

% Revised by Richard J. Cui.
% $Revision: 0.1 $  $Date: Fri 03/08/2013  9:30:59.689 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


% -- Defaults

if ( ~exist('sessname','var') )
    sessname = [];
end
imported_data = [];
if ( ~exist( 'options', 'var') )
    options.Flip_Horizontal     = 0;
    options.Flip_Vertical		= 1;
    options.Gaze_Data           = 1;
    options.Blinks_Gap          = 200;   %ms
    options.semiblink_th        = -50;
end

%create enum for samples and edf_samples
imported_data.enum.samples.timestamps = 1;
imported_data.enum.samples.left_x = 2;
imported_data.enum.samples.left_y = 3;
imported_data.enum.samples.right_x = 4;
imported_data.enum.samples.right_y = 5;

imported_data.enum.edf_samples.timestamps = 1;
imported_data.enum.edf_samples.left_x = 2;
imported_data.enum.edf_samples.left_y = 3;
imported_data.enum.edf_samples.right_x = 4;
imported_data.enum.edf_samples.right_y = 5;

imported_data.enum.edf_gaze_samples.timestamps = 1;
imported_data.enum.edf_gaze_samples.left_x = 2;
imported_data.enum.edf_gaze_samples.left_y = 3;
imported_data.enum.edf_gaze_samples.right_x = 4;
imported_data.enum.edf_gaze_samples.right_y = 5;

imported_data.enum.pupil_samples.left_pupil_size = 1;
imported_data.enum.pupil_samples.right_pupil_size = 2;

enum = imported_data.enum;

% -- Prompt the user with a dialog to select the files to be imported
if ( ~exist( 'directory', 'var' ) ) % not a batch process
    options.Flip_Horizontal     = { {'{0}'  , '1'}};
    options.Flip_Vertical		= { {'0'    , '{1}'}};
    options.Gaze_Data           = { {'{0}'  , '1'}};
    options.Blinks_Gap          = { 200 '* (ms)' [0 500]};
    [filenames, directory, sessname, options] = import_files_dialog( prefix, tag, 'EDF', options );
    if ( isempty( filenames ) )
        return
    end
    if iscell(sessname) && length(sessname) == 1
        sessname = sessname{1};
    end % if
end

% make sure the prefix is correct in the session
if ( ~isequal(prefix, sessname(1:length(prefix))) )
    sessname = [prefix sessname];
end

% -- Do not import files that are too small, they will give errors (they don't have data)
goodfiles = zeros(length(filenames),1);
for j=1:length(filenames)
    d = dir(fullfile( directory, char(filenames(j))));
    goodfiles(j) = d.bytes > 1024;
end
filenames = filenames(goodfiles==1);

%% -- Import the files into matlab variables
try
    hwait = waitbar(0,'Please wait while EDF Files are read...');
    
    isFileGaze = zeros(sum(goodfiles));
    for j=1:length(filenames)
        [dat(j), warnings] =  edf2mat( fullfile( directory, char(filenames(j)) ) , options.Gaze_Data );
        isFileGaze(j) = ~isempty(cell2mat(strfind(warnings, 'preferred sample type HREF not available: using GAZE data' )));
        waitbar( j/length(filenames), hwait);
    end
    close(hwait);
catch ex
    close(hwait);
    rethrow(ex);
end


%% -- fix timestamps for concatenated files so they are always increasing
% timestamps that correspond with the beginning and the end of each file
file_timestamps = zeros(length(dat), 2);
file_timestamps(1,:) = [dat(1).edf_samples(1,enum.edf_samples.timestamps) dat(1).edf_samples(end,enum.edf_samples.timestamps)];
for j=2:length(dat)
    
    % find first and last timestamp
    if ( ~isempty(dat(j).buttons) )
        lasttimestamp	= max( [dat(j-1).edf_samples(end,enum.edf_samples.timestamps) dat(j-1).buttons(end,1)] );
        firsttimestamp = min( [dat(j).edf_samples(1,enum.edf_samples.timestamps) dat(j).buttons(1,1)] );
    else
        lasttimestamp	= max( dat(j-1).edf_samples(end,enum.edf_samples.timestamps) );
        firsttimestamp	= min( dat(j).edf_samples(1,enum.edf_samples.timestamps) );
    end
    diffe = lasttimestamp -  firsttimestamp + 400000; % small gap to match time at breaks - xgt oct 23, 2006
    
    dat(j).edf_samples(:,enum.edf_samples.timestamps) = dat(j).edf_samples(:,enum.edf_samples.timestamps) + diffe;
    if ( ~isempty(dat(j).edf_gaze_samples))
        dat(j).edf_gaze_samples(:,enum.edf_gaze_samples.timestamps) = dat(j).edf_samples(:,enum.edf_samples.timestamps);
    end
    if ( ~isempty(dat(j).blinks))
        dat(j).blinks(:,1:2) = dat(j).blinks(:,1:2) + double(diffe);
    end
    if ( ~isempty(dat(j).buttons))
        dat(j).buttons(:,1) = dat(j).buttons(:,1) + double(diffe);
    end
    if ( ~isempty(dat(j).saccades))
        dat(j).saccades(:,1:2) = dat(j).saccades(:,1:2) + double(diffe);
    end
    if ( ~isempty(dat(j).msg) )
        dat(j).msg.time = dat(j).msg.time + double(diffe);
    end
    
    file_timestamps(j,:) = [dat(j).edf_samples(1,enum.edf_samples.timestamps) dat(j).edf_samples(end,enum.edf_samples.timestamps)];
end
samplerate = unique( struct2array(dat,'samplerate') );
if ( length(samplerate) > 1 )
    errordlg( 'It is not possible to combine files with different samplerate');
end

%% -- concatenate files
% first calculate how much space we need
fldnames = {'edf_samples' 'buttons' 'blinks' 'saccades'};
if options.Gaze_Data
    fldnames{end+1} = 'edf_gaze_samples';
end
for ifdn = 1:length(fldnames)
    fdn = fldnames{ifdn};
    size.(fdn) = 0;
    START = 1;
    for i = 1:length(dat)
        if ~isempty(dat(i).(fdn))
            size.(fdn) = length(dat(i).(fdn)(:,1)) + size.(fdn);
            start.(fdn)(i) = START;
            stop.(fdn)(i) = START + length(dat(i).(fdn)(:,1))-1;
            START = START + length(dat(i).(fdn)(:,1));
        end
    end
end
imported_data.edf_samples = zeros(size.edf_samples,7);
imported_data.buttons = zeros(size.buttons,3);
imported_data.blinks = zeros(size.blinks,3);
imported_data.saccades = zeros(size.saccades,3);
imported_data.session_start = start.edf_samples; %index of where each session begins and ends
imported_data.session_end = stop.edf_samples;
if options.Gaze_Data
    imported_data.edf_gaze_samples = zeros(size.edf_gaze_samples,5);
end

msg.n = 0;
msg.time = [];
msg.text = [];
lengthFiles =[1];
for i=1:length(dat);
    for fdn = fldnames
        if ~isempty(dat(i).(char(fdn)))
            imported_data.(char(fdn))(start.(char(fdn))(i):stop.(char(fdn))(i),:) =  dat(i).(char(fdn));
        else
            imported_data.(char(fdn)) =  [];
        end
    end
    msg.n = msg.n + dat(i).msg.n;
    msg.time  = [msg.time ;dat(i).msg.time];
    msg.text  = cat(2,msg.text, dat(i).msg.text);
    lengthFiles(end+1) = length(imported_data.edf_samples);
end
imported_data.msgs = msg;

clear dat msg;

if options.Gaze_Data
    if ( ~isempty( db ) )
        db.add( sessname, imported_data,{'edf_gaze_samples' } );
        imported_data = rmfield(imported_data,{'edf_gaze_samples' });
    end
end



%% -- Pre-process eye data --------------------------------------


% -- Interpolate blinks in the data
[imported_data.samples imported_data.blinkYesNo] = interpolate_blinks2(imported_data.edf_samples, imported_data.blinks, options.Blinks_Gap*samplerate/1000, enum.samples);
imported_data.blinkYesNo(end) = [];
imported_data.pupil_samples = imported_data.samples(1:end-1,[6 7]);
imported_data.samples = imported_data.samples(:,enum.samples.timestamps:enum.samples.right_y);
if ( ~isempty( db ) )
    db.add( sessname, imported_data, {'edf_samples' 'blinkYesNo' 'pupil_samples'} );
    imported_data = rmfield(imported_data, {'edf_samples' 'blinkYesNo' 'pupil_samples'} );
    imported_data.info.import.variables = {'edf_samples' 'blinkYesNo' 'pupil_samples' 'edf_gaze_samples' };
end

% -- Flip necessary components
if ( options.Flip_Horizontal  )
    imported_data.samples(:,enum.samples.left_x) = -imported_data.samples(:,enum.samples.left_x);
    imported_data.samples(:,enum.samples.right_x) = -imported_data.samples(:,enum.samples.right_x);
end
if ( options.Flip_Vertical  )
    imported_data.samples(:,enum.samples.left_y) = -imported_data.samples(:,enum.samples.left_y);
    imported_data.samples(:,enum.samples.right_y) = -imported_data.samples(:,enum.samples.right_y);
end

% -- Convert to DVA ( Degrees of the Visual Angle )
[dva] = HREF2dva(imported_data.samples, enum.samples);

if ( sum(isFileGaze) > 0 )
    % if some file had only GAZE data we need to use another conversion
    lengthFiles(end) = lengthFiles(end)-1;
    msgbox('Some files have only GAZE data');
    dvaGaze = GAZE2dva(imported_data.samples, enum.samples);
    for i=1:length(isFileGaze)
        % replace "chunks" of data from HREF to GAZE
        if (isFileGaze(i) && (lengthFiles(i+1) - lengthFiles(i)>1))
            dva(lengthFiles(i):lengthFiles(i+1),:) = [dvaGaze(lengthFiles(i)+1,:);dvaGaze(lengthFiles(i)+1:lengthFiles(i+1)-1,:);dvaGaze(lengthFiles(i+1)-1,:)];
        end
    end
end

%% -- commit final variables
imported_data.samples(end,:) = [];
imported_data.session_end(end) = imported_data.session_end(end) - 1;
imported_data.samples(:,enum.samples.left_x:enum.samples.right_y)= dva;

imported_data.samplerate = samplerate;

imported_data.info.samplerate = samplerate;
imported_data.info.import.folder = directory;
imported_data.info.import.filenames = filenames;
imported_data.info.import.date = datestr(now);
imported_data.info.import.file_timestamps = file_timestamps;
imported_data.info.import.options = options;



%% edf2mat
function [dat, warnings] = edf2mat(edffile, gaze)

% Check for EDF2ASC.EXE
path = fileparts(mfilename('fullpath'));
path =strrep(path,'\','\\');
EDF2ASC = [path '\\Edftools\\edf2asc'] ; % EyeLink Parser File, change or add path if necessary
[s,w] = system(EDF2ASC) ;
if (s==0) || (strcmpi(w,'Bad command or file name')==1),
    error(['EDF2ASC not found in (' EDF2ASC ')']) ;
end

% Check if the EDF file exists
if ~exist(edffile,'file'),
    error(['The EyeLink file "' edffile '" does not exist !!!'])
end


%% -- Read the HREF sample data
% Build the command string
commandstr = [EDF2ASC ' %s %s.asc -sp -miss 9999 -sh -s -y'] ; % 9999 for missing data
file = strrep(upper(edffile),'.EDF','');
disp(['EDF DATA -> MAT for file "' edffile '". Please be patient ...']);
if exist([file '.asc'],'file')
    system(['del ' file '.asc']);
end
[s, w] = dos(sprintf(commandstr,edffile,file)) ;
perl1(['-n -i.orig -e "print unless /^\ \ /" ' file '.asc']); % delete the first line
perl1(['-pi.orig -e "s/\t[\.I]//" ' file '.asc']); % delete "." and "I" in the last column
X = load([file '.asc']) ;
X(X==9999) = NaN ;
system(['del ' file '.asc']) ;
system(['del ' file '.asc.orig']) ;
if ( size( X, 2) == 7 )
    edf_samples = X(:,[1 2 3 5 6 4 7]);
elseif( size(X, 2) == 4 )
    edf_samples = X(:,[1 2 2 3 3 4 4]); % if only one eye is present replicate it
end
samplerate = 1000/round(median(diff(edf_samples(:,1))));

warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
warnings = warns;

%% -- Read the GAZE sample data
if ( gaze)
    % Build the command string
    commandstr = [EDF2ASC ' %s %s.asc  -miss 9999 -g -s'] ;% 9999 for missing data
    file = strrep(upper(edffile),'.EDF','');
    disp(['EDF GAZE DATA -> MAT for file "' edffile '". Please be patient ...']);
    if exist([file '.asc'],'file')
        system(['del ' file '.asc']);
    end
    [s, w] = dos(sprintf(commandstr,edffile,file)) ;
    perl1(['-n -i.orig -e "print unless /^\ \ /" ' file '.asc']); % delete the first line
    perl1(['-pi.orig -e "s/\t[\.I]//" ' file '.asc']); % delete "." and "I" in the last column
    X = load([file '.asc']) ;
    X(X==9999) = NaN ;
    system(['del ' file '.asc']) ;
    system(['del ' file '.asc.orig']) ;
    edf_gaze_samples = X(:,[1 2 3 5 6]);
    
    warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
    warnings = {warnings{:} warns{:} };
else
    edf_gaze_samples = [];
end



%% -- Read the event data
commandstr = [EDF2ASC ' %s %s.asc -miss 9999 -e'] ;

disp(['EDF EVENTS -> MAT for file "' upper(edffile) '". Please be patient ...'])
if exist([file '.asc'],'file')
    system(['del ' file '.asc']);
end
[s,w] = system(sprintf(commandstr,edffile,file)) ;
warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
warnings = {warnings{:} warns{:} };

if s == -1,
    evt = ParseEvents([file '.asc']) ;
else
    error('Reading the event data from the EDF file') ;
end

blinks = [];
buttons = [];
saccades = [];
msg = [];
if evt.blink.n
    blinks = [evt.blink.Tstart evt.blink.Tend evt.blink.eye];
end
if evt.button.n
    buttons = [evt.button.T evt.button.number evt.button.press];
end
if evt.sac.n
    saccades = [evt.sac.Tstart evt.sac.Tend evt.sac.eye];
end
if evt.msg.n
    msg = evt.msg;
end

dat.edf_samples = edf_samples;
dat.edf_gaze_samples = edf_gaze_samples;
dat.blinks = blinks;
dat.buttons = buttons;
dat.saccades = saccades;
dat.msg = msg;
dat.samplerate = samplerate;



%% ParseEvents
function D = ParseEvents (file)

% Parse the lines in the ascii file for relevant events

fid=fopen(file);
if fid==0,
    error(['Could not open ' file ' for input!'])
end
F=fread(fid);
fclose(fid);

D.Nbytes = length(F(:));
D.file = file ;
F=F';

q = F == 10 ; %  change CR/LF to CR. (DOS problem)
F = F(~q);
if sum(F==13) == length(F),
    error('Empty file');
end

% file should start and end without empty lines
while F(1)==13,
    F = F(2:end) ;
end
while F(end)==13,
    F = F(1:end-1) ;
end
F = [F 13];


q=F==13;
nl=find(q); % alle line breaks
D.Nlines = length(nl);

p0 = [1 nl(1:length(nl)-1)+1] ; % indices of line starts
p1 = nl -1 ; % indices of line ends
L1 = lower(char(F(p0))) ; % first character of the lines
L2 = lower(char(F(p0+1))); % second character of the line

% L1/L2 provide us with a selection mechanism for the type of event
% Parse each type of event separately

% HEADER LINES
% Format : *%s
q = (L1 == '*') ; % header lines starts
D.header = char(F(min(p0(q)):max(p1(q))));

% MESSAGES
% Format: msg %i %s
fprintf('[messages ...') ;
q = (L1 == 'm') & (L2 == 's') ;
D.msg.n = sum(q) ;
if D.msg.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    D.msg.time = zeros(D.msg.n,1) ;
    D.msg.text = [];
    for i = 1:D.msg.n,
        s = char(F(x0(i):x1(i))) ;
        [t dum1 dum2, in] = sscanf(lower(s),'msg %f',1) ;
        s=s(min(in+1,length(s)):length(s));
        D.msg.text{i} = s ;
        D.msg.time(i) = t ;
    end
end
fprintf('%c%c%c(%i), ',8,8,8,D.msg.n) ;

% SACCADES
% Format: esacc %i ...
fprintf('saccades ...') ;
q = (L1 == 'e') & (L2 == 's') ;
D.sac.n = sum(q) ;
if D.sac.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    X = repmat(NaN, D.sac.n, 12) ;
    for i = 1:D.sac.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'esacc %c %f %f %f %f %f %f %f %f %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    D.sac.eye = ones(D.sac.n,1) ;
    D.sac.eye(X(:,1) == double('r')) = 2 ;
    D.sac.Tstart = X(:,2) ;
    D.sac.Tend = X(:,3) ;
    D.sac.dur = X(:,4) ;
    D.sac.Hstart = X(:,5) ;
    D.sac.Vstart = X(:,6) ;
    D.sac.Hend = X(:,7) ;
    D.sac.Vend = X(:,8) ;
    D.sac.amp = X(:,9) ;
    D.sac.pv = X(:,10) ;
    D.sac.xr = X(:,11) ;
    D.sac.yr = X(:,12) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.sac.n) ;

% FIXATIONS
% Format: efix %i ...
fprintf('fixations ...') ;
q = (L1 == 'e') & (L2 == 'f') ;
D.fix.n = sum(q) ;
if D.fix.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    X = repmat(NaN, D.fix.n, 9) ;
    for i = 1:D.fix.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'efix %c %f %f %f %f %f %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    D.fix.eye = ones(D.fix.n,1) ;
    D.fix.eye(X(:,1) == double('r')) = 2 ;
    D.fix.Tstart = X(:,2) ;
    D.fix.Tend = X(:,3) ;
    D.fix.dur = X(:,4) ;
    D.fix.H = X(:,5) ;
    D.fix.V = X(:,6) ;
    D.fix.pup = X(:,7) ;
    D.fix.xr = X(:,8) ;
    D.fix.yr = X(:,9) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.fix.n) ;

% BLINKS
% Format: eblink %i ...
fprintf('blinks ...') ;
q = ((L1 == double('e')) & (L2 == double('b'))) ;
D.blink.n = sum(q) ;
if D.blink.n>0,
    x0 = p0(q);
    x1 = p1(q) ;
    X = repmat(NaN, D.blink.n, 4) ;
    for i = 1:D.blink.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'eblink %c %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    D.blink.eye = ones(D.blink.n,1) ;
    D.blink.eye(X(:,1) == double('r')) == 2 ;
    D.blink.Tstart = X(:,2) ;
    D.blink.Tend = X(:,3) ;
    D.blink.dur = X(:,4) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.blink.n) ;

% BUTTONS
% Format: button %f %f %f
fprintf('blinks ...') ;
q = (L1 == 'b') & (L2 == 'u') ;
D.button.n = sum(q) ;
if D.button.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    X = repmat(NaN, D.button.n, 3) ;
    for i = 1:D.button.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'button %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    D.button.T = X(:,1) ;
    D.button.number = X(:,2) ;
    D.button.press = X(:,3) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.button.n) ;

% RECORDING BLOCKS
% Format: start %f ...
% Format: end %f ...
fprintf('blocks ...') ;
q1 = (L1 == 's') & (L2 == 't') ;
D.block.n = sum(q1) ;

q2 = (L1 == 'e') & (L2 == 'n') ;
n2 = sum(q2) ;

if D.block.n > 0,
    x0 = p0(q1);
    x1 = p1(q1) ;
    X = repmat(NaN, D.block.n,1) ;
    for i = 1:D.block.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        X(i) = sscanf(s,'start %f');
    end
    X(X==9999) = NaN ;
    D.block.Tstart = X ;
    x0 = p0(q2);
    x1 = p1(q2) ;
    X = repmat(NaN, n2,1) ;
    for i = 1:n2,
        s = lower(char(F(x0(i):x1(i)))) ;
        X(i) = sscanf(s,'end %f');
    end
    X(X==9999) = NaN ;
    D.block.Tend = X ;
    % Occasionally, the number of END events is one less than the number of
    % start events. Warn for this and fill in the time of the last event
    if n2 ~= D.block.n,
        warning ('The number of START and END events do not match');
        if n2 == D.block.n-1,
            [dum D.block.Tend(end+1)] = strread(num2str(F(p0(end):p1(end))),'%s %f',1) ;
        end
    end
end
fprintf('%c%c%c(%i)]\n',8,8,8,D.block.n) ;

%%


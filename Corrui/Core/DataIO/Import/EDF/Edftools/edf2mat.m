function [dat, warnings] = edf2mat(edffile, options)
% EDF2MAT converts EDF infomation into Mastlab vars
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 03/14/2013 10:45:59.587 PM
% $Revision: 0.1 $  $Date: 03/14/2013 10:45:59.587 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% check files
% =========================================================================
% Check if the EDF file exists
% ----------------------------
if ~exist(edffile,'file'),
    error(['The EyeLink file "' edffile '" does not exist !!!'])
end

% Check for EDF2ASC.EXE
% ----------------------
% path = fileparts(mfilename('fullpath'));
% path =strrep(path,'\','\\');
% EDF2ASC = [path '\\Edftools\\edf2asc'] ; % EyeLink Parser File, change or add path if necessary
EDF2ASC = which('EDF2ASC.EXE');
% [s,w] = system(EDF2ASC) ;
% if (s==0) || (strcmpi(w,'Bad command or file name')==1),
%     error(['EDF2ASC not found in (' EDF2ASC ')']) ;
% end
if isempty(EDF2ASC)
    error('EDF2ASC.EXE is not found in Matlab path directories')
end % if
EDF2ASC = strrep(EDF2ASC, '\', '\\');

% =========================================================================
% Read the HREF sample data
% =========================================================================
% Build the command string
commandstr = [EDF2ASC ' %s %s.asc -sp -miss 9999 -sh -s -y'] ; % 9999 for missing data
file = strrep(upper(edffile),'.EDF','');
disp(['EDF DATA -> MAT for file "' edffile '". Please be patient ...']);
if exist([file '.asc'],'file')
    system(['del ' file '.asc']);
end
[s, w] = dos(sprintf(commandstr,edffile,file)) ;
if s ~= -1
    error(w)
end % if
perl1(['-n -i.orig -e "print unless /^\ \ /" ' file '.asc']); % delete the first line
perl1(['-pi.orig -e "s/\t[\.I]//" ' file '.asc']); % delete "." and "I" in the last column
X = load([file '.asc']) ;
X(X==9999) = NaN ;
system(['del ' file '.asc']) ;
system(['del ' file '.asc.orig']) ;
if ( size( X, 2) == 7 )     % binocular
    edf_samples = X(:,[1 2 3 5 6 4 7]);
elseif( size(X, 2) == 4 )   % monocular
    edf_samples = X(:,[1 2 2 3 3 4 4]); % if only one eye is present replicate it
end
samplerate = 1000/round(median(diff(edf_samples(:,1))));

warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
warnings = warns;

% =========================================================================
% Read the GAZE sample data
% =========================================================================
if ( options.gaze )
    % Build the command string
    cstr0 = [EDF2ASC ' %s %s.asc  -miss 9999 -s'];  % 9999 for missing data
    if options.gazemap
        commandstr = [cstr0, ' -g'];
    end
    
    % commandstr = [EDF2ASC ' %s %s.asc  -miss 9999 -g -s'];  % 9999 for missing data
    file = strrep(upper(edffile),'.EDF','');
    disp(['EDF GAZE DATA -> MAT for file "' edffile '". Please be patient ...']);
    if exist([file '.asc'],'file')
        system(['del ' file '.asc']);
    end
    [s, w] = dos(sprintf(commandstr,edffile,file)) ;
    if s ~= -1
        error(w)
    end % if
    perl1(['-n -i.orig -e "print unless /^\ \ /" ' file '.asc']); % delete the first line
    perl1(['-pi.orig -e "s/\t[\.I]//" ' file '.asc']); % delete "." and "I" in the last column
    X = load([file '.asc']) ;
    X(X==9999) = NaN ;
    system(['del ' file '.asc']) ;
    system(['del ' file '.asc.orig']) ;
    edf_gaze_samples = X(:,[1 2 3 5 6]);
    
    warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
    % warnings = { warnings{:} warns{:} };
    warnings = cat(2, warnings, warns);
else
    edf_gaze_samples = [];
end

% =========================================================================
% Read EVENT data
% =========================================================================
cstr0 = [EDF2ASC ' %s %s.asc -miss 9999 -e'];
if options.frames
    commandstr = [cstr0, ' -i'];
end

disp(['EDF EVENTS -> MAT for file "' upper(edffile) '". Please be patient ...'])
if exist([file '.asc'],'file')
    system(['del ' file '.asc']);
end
[s,w] = system(sprintf(commandstr, edffile, file)) ;
if s ~= -1
    error(w)
end % if
warns = unique(regexp(w, 'WARNING[^\n\r]*(?=[\r\n])', 'match'));
% warnings = {warnings{:} warns{:} };
warnings = cat(2, warnings, warns);
if s == -1,
    evt = ParseEvents([file '.asc']) ;
else
    error('Reading the event data from the EDF file') ;
end

fixations = [];
saccades = [];
blinks = [];
msg = [];
buttons = [];
blocks = [];
if evt.fix.n > 0
    fixations = [evt.fix.Tstart evt.fix.Tend evt.fix.eye];
end

if evt.sac.n > 0
    saccades = [evt.sac.Tstart evt.sac.Tend evt.sac.eye];
end

if evt.blink.n > 0
    blinks = [evt.blink.Tstart evt.blink.Tend evt.blink.eye];
end

if evt.msg.n > 0
    msg = evt.msg;
end

if evt.button.n > 0
    buttons = [evt.button.T evt.button.number evt.button.press];
end

if evt.block.n > 0
    blocks = [evt.block.Tstart, evt.block.Tend];
end % end

dat.edf_samples         = edf_samples;
dat.edf_gaze_samples    = edf_gaze_samples;
dat.fixations           = fixations;
dat.saccades            = saccades;
dat.blinks              = blinks;
dat.buttons             = buttons;
dat.msg                 = msg;
dat.blocks              = blocks;
dat.samplerate          = samplerate;

end % function edf2mat

function D = ParseEvents(file)
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
% L1/L2 provide us with a selection mechanism for the type of event
L1 = lower(char(F(p0))) ; % first character of the lines
L2 = lower(char(F(p0+1))); % second character of the line

% Parse each type of event separately
% -----------------------------------
% =============
% HEADER LINES
% =============
% Format : *%s
q = (L1 == '*') ; % header lines starts
D.header = char(F(min(p0(q)):max(p1(q))));

% =========
% MESSAGES
% =========
% Format: msg %i %s
fprintf('[messages ...') ;
q = (L1 == 'm') & (L2 == 's');
D.msg.n = sum(q);
if D.msg.n > 0,
    x0 = p0(q);
    x1 = p1(q);
    D.msg.time = zeros(D.msg.n, 1);
    D.msg.text = [];
    for i = 1:D.msg.n,
        s = char(F(x0(i):x1(i))) ;
        [t , ~, ~, in] = sscanf(lower(s),'msg %f',1) ;
        s=s(min(in+1,length(s)):length(s));
        
        D.msg.text{i} = s ;
        D.msg.time(i) = t ;
    end
end
fprintf('%c%c%c(%i), ',8,8,8,D.msg.n) ;

% =========
% SACCADES
% =========
% Format: esacc %i ...
fprintf('saccades ...') ;
q = (L1 == 'e') & (L2 == 's') ;
D.sac.n = sum(q) ;
if D.sac.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    % X = repmat(NaN, D.sac.n, 12) ;
    X = NaN(D.sac.n, 12);
    for i = 1:D.sac.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'esacc %c %f %f %f %f %f %f %f %f %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    
    D.sac.eye                           = ones(D.sac.n,1) ;
    D.sac.eye(X(:,1) == double('r'))    = 2 ;
    D.sac.Tstart    = X(:,2) ;
    D.sac.Tend      = X(:,3) ;
    D.sac.dur       = X(:,4) ;
    D.sac.Hstart    = X(:,5) ;
    D.sac.Vstart    = X(:,6) ;
    D.sac.Hend      = X(:,7) ;
    D.sac.Vend      = X(:,8) ;
    D.sac.amp       = X(:,9) ;
    D.sac.pv        = X(:,10) ;
    D.sac.xr        = X(:,11) ;
    D.sac.yr        = X(:,12) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.sac.n) ;

% ==========
% FIXATIONS
% ==========
% Format: efix %i ...
fprintf('fixations ...') ;
q = (L1 == 'e') & (L2 == 'f') ;
D.fix.n = sum(q) ;
if D.fix.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    % X = repmat(NaN, D.fix.n, 9) ;
    X = NaN(D.fix.n, 9);
    for i = 1:D.fix.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'efix %c %f %f %f %f %f %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    
    D.fix.eye                           = ones(D.fix.n,1) ;
    D.fix.eye(X(:,1) == double('r'))    = 2 ;
    D.fix.Tstart    = X(:,2) ;
    D.fix.Tend      = X(:,3) ;
    D.fix.dur       = X(:,4) ;
    D.fix.H         = X(:,5) ;
    D.fix.V         = X(:,6) ;
    D.fix.pup       = X(:,7) ;
    D.fix.xr        = X(:,8) ;
    D.fix.yr        = X(:,9) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.fix.n) ;

% =======
% BLINKS
% =======
% Format: eblink %i ...
fprintf('blinks ...') ;
q = ((L1 == double('e')) & (L2 == double('b'))) ;
D.blink.n = sum(q) ;
if D.blink.n>0,
    x0 = p0(q);
    x1 = p1(q) ;
    % X = repmat(NaN, D.blink.n, 4) ;
    X = NaN(D.blink.n,4);
    for i = 1:D.blink.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'eblink %c %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    
    D.blink.eye                         = ones(D.blink.n,1) ;
    D.blink.eye(X(:,1) == double('r'))  = 2 ;
    D.blink.Tstart                      = X(:,2) ;
    D.blink.Tend                        = X(:,3) ;
    D.blink.dur                         = X(:,4) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.blink.n) ;

% ========
% BUTTONS
% ========
% Format: button %f %f %f
fprintf('buttons ...') ;
q = (L1 == 'b') & (L2 == 'u') ;
D.button.n = sum(q) ;
if D.button.n > 0,
    x0 = p0(q);
    x1 = p1(q) ;
    % X = repmat(NaN, D.button.n, 3) ;
    X = NaN(D.button.n, 3);
    for i = 1:D.button.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        [tt, tn] = sscanf(s,'button %f %f %f');
        X(i,1:tn) = tt(:)' ;
    end
    X(X==9999) = NaN ;
    
    D.button.T          = X(:,1) ;
    D.button.number     = X(:,2) ;
    D.button.press      = X(:,3) ;
end
fprintf('%c%c%c(%i), ',8,8,8,D.button.n) ;

% =================
% RECORDING BLOCKS
% =================
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
    % X = repmat(NaN, D.block.n,1) ;
    X = NaN(D.block.n, 1);
    for i = 1:D.block.n,
        s = lower(char(F(x0(i):x1(i)))) ;
        X(i) = sscanf(s,'start %f');
    end
    X(X==9999) = NaN ;
    D.block.Tstart = X ;
    x0 = p0(q2);
    x1 = p1(q2) ;
    % X = repmat(NaN, n2,1) ;
    X = NaN(n2, 1);
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
            % [dum D.block.Tend(end+1)] = strread(num2str(F(p0(end):p1(end))),'%s %f',1) ;
            [~, D.block.Tend(end+1)] = textscan(num2str(F(p0(end):p1(end))),'%s %f',1) ;
        end
    end
end
fprintf('%c%c%c(%i)]\n',8,8,8,D.block.n) ;

end

% [EOF]

function [ samples, blinks, buttons, saccades, msg, firstmsg, warnings, samplerate] = edf_read_file3(fname,gaze_data)
%edf_read_file2(fname)
%   [samples,blinks,buttons,saccades] = edf_read_file2(fname, type_of_data)
% Returns arrays of sample data, buttons blinks given a
% name of an .EDF file. Uses intermediate asc conversion utility
% edf2asc.exe -- needs to be on path!!

if nargin == 1
    gaze_data = 0;
end

blinks = [];
buttons = [];
saccades = [];
msg = [];
% 
% switch (type_of_data)
% 	case 'href'
% 		[smp, warnings] = hdat2mat(fname); % both eyes used
% 	case 'gaze'
% 		[smp,warnings] = dat2mat(fname); % both eyes used
% end
% smp = hdat2mat(fname,2); % right eye used
% smp = hdat2mat(fname,1); % left eye used

[smp,warnings] = edf2mat(fname,gaze_data); % both eyes used

evt = evt2mat(fname);
% 

% samples always filled or completely empty
if (~isfield(smp,'L') || isempty(smp.L) || isempty(smp.L.T))
	warning('No data for the left eye');
	smp.L = smp.R;
end
if (~isfield(smp,'R') || isempty(smp.R) || isempty(smp.R.T))
	warning('No data for the right eye');
	smp.R = smp.L;
end

% % samples always filled or completely empty
% if (~isfield(smp,'L') || isempty(smp.L) || isempty(smp.L.T))
% 	warning('No data for the left eye');
% 	smp.L.T = smp.R.T;
% 	smp.L.H = nan(size(smp.R.H));
% 	smp.L.V = nan(size(smp.R.V));
% 	smp.L.pup = nan(size(smp.R.pup));
% end
% if (~isfield(smp,'R') || isempty(smp.R) || isempty(smp.R.T))
% 	warning('No data for the right eye');
% 	smp.R.T = smp.L.T;
% 	smp.R.H = nan(size(smp.L.H));
% 	smp.R.V = nan(size(smp.L.V));
% 	smp.R.pup = nan(size(smp.L.pup));
% end
samples = [smp.L.T smp.L.H smp.R.H smp.L.V smp.R.V smp.L.pup smp.R.pup];

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

firstmsg = evt.msg.text{end};

samplerate = regexp(evt.msg.text{1}, ['(?<=RECCFG\s+.*P\s+)' '\d+' '(?=\s+)'], 'match');
samplerate = Str2int(char(samplerate));
if ( isempty(samplerate) )
    if ( isfield(smp, 'L'))
        samplerate = 1000/round(median(diff(smp.L.T)));
    else
        samplerate = 1000/round(medial(diff(smp.L.T)));
    end
end
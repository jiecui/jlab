function dat = detect_spike_events( this, sname, ~, import_variables )
% BLANKCTRL.DETECT_SPIKE_EVENTS (summary)
%
% Syntax:
%   dat = detect_spike_events( this, sname, S, import_variables )
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/25/2012  2:46:40.541 PM
% $Revision: 0.1 $  $Date: 10/25/2012  2:46:40.541 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%==========================================================================
%% Get Data ===============================================================
%==========================================================================
if ~exist('import_variables', 'var')
    import_variables = { 'spiketimes' 'isInTrialSequence' 'isInTrialCond' 'isInCycle'...
                         'isInTrialStage' 'enum'};
end % if
dat_in = this.db.getsessvars( sname, import_variables );

enum = get_enums(dat_in.enum);
spkt = dat_in.spiketimes;
isInTrialSequence = dat_in.isInTrialSequence;
isInTrialCond = dat_in.isInTrialCond;

%==========================================================================
%% process spike times=====================================================
%==========================================================================
N = size(spkt, 1);    % number of spikes
M = length(fields(enum.spiketimes));
spiketimes = zeros(N, M);

timeindex = spkt(:, enum.spiketimes.timeindex);
spiketimes(:, enum.spiketimes.timestamps) = spkt(:, enum.spiketimes.timestamps);
spiketimes(:, enum.spiketimes.timeindex) = timeindex;
spiketimes(:, enum.spiketimes.trial_seq) = isInTrialSequence(timeindex);
spiketimes(:, enum.spiketimes.trial_condition) = isInTrialCond(timeindex);

%==========================================================================
%% commit =================================================================
%==========================================================================
dat.enum = enum;
dat.spiketimes = spiketimes;

end % function detect_spike_events

% =========================================================================
% subroutines
% =========================================================================
function enum = get_enums(enum)

enum.spiketimes.timestamps      = 1;
enum.spiketimes.timeindex       = 2;
enum.spiketimes.trial_seq       = 3;
enum.spiketimes.trial_condition = 4;

end % function

% [EOF]

function dat = detect_spike_events( this, sname, S, import_variables )
% SPIKE.DETECT_SPIKE_EVENTS detect spike events
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

% Copyright 2014 Richard J. Cui. Created: Sun 05/26/2013  3:40:33.733 PM
% $Revision: 0.2 $  $Date: Sun 03/23/2014 10:31:06.523 AM $
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
% dat_in = this.db.getsessvars( sname, import_variables );
dat_in = CorruiDB.Getsessvars( sname, import_variables );

% enum = get_enums(dat_in.enum);
enum = this.getSpkEnum(dat_in.enum);
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
% function enum = get_enums(enum)
% 
% enum.spiketimes.timestamps      = 1;
% enum.spiketimes.timeindex       = 2;
% enum.spiketimes.trial_seq       = 3;
% enum.spiketimes.trial_condition = 4;
% 
% end % function

% [EOF]

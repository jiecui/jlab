function dat = detect_spike_events(this, sname, S, import_variables)
% DETECT_SPIKE_EVENTS (summary)
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

% Copyright 2012-2016 Richard J. Cui. Created: 10/25/2012  2:46:40.541 PM
% $Revision: 0.3 $  $Date: Fri 08/05/2016 12:50:51.643 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

cprintf('Text', 'Detecting spike events...\n')

%==========================================================================
%% Get Data ===============================================================
%==========================================================================
if ~exist('import_variables', 'var')
    import_variables = { 'spiketimes' 'isInTrialNumber' 'isInTrialCond' 'isInCycle'...
                         'isInTrialStage' };
end % if
dat_in = this.db.getsessvars( sname, import_variables );

enum = get_enums(this.enum);

spkt = dat_in.spiketimes;
if ~isempty(spkt)
    spkt(isnan(spkt(:, enum.spiketimes.timeindex)), :) = [];   % get rid of the repeated spiketimes
    isInTrialNumber = dat_in.isInTrialNumber;
    isInTrialCond = dat_in.isInTrialCond;
    isInCycle = dat_in.isInCycle;
    isInTrialStage = dat_in.isInTrialStage;
    
    %======================================================================
    % process spike times==================================================
    %======================================================================
    N = size(spkt, 1);    % number of spikes
    M = length(fields(enum.spiketimes));
    spiketimes = zeros(N, M);
    
    timeindex = spkt(:, enum.spiketimes.timeindex);
    spiketimes(:, enum.spiketimes.timestamps) = spkt(:, enum.spiketimes.timestamps);
    spiketimes(:, enum.spiketimes.timeindex) = timeindex;
    spiketimes(:, enum.spiketimes.trial_number) = isInTrialNumber(timeindex);
    spiketimes(:, enum.spiketimes.trial_condition) = isInTrialCond(timeindex);
    spiketimes(:, enum.spiketimes.cycle_index) = isInCycle(timeindex);
    spiketimes(:, enum.spiketimes.trial_stage) = isInTrialStage(timeindex);
else
    spiketimes = [];
end

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
enum.spiketimes.trial_number    = 3;
enum.spiketimes.trial_condition = 4;
enum.spiketimes.cycle_index     = 5;
enum.spiketimes.trial_stage     = 6;

end % function

% [EOF]

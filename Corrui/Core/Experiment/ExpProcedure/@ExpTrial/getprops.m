function trial_props = getprops( this, trialMatrix, samplerate, left_fixation_props, right_fixation_props, enum_input )
% EXPTRIAL.GETPROPS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/31/2014 11:47:26.288 AM
% $Revision: 0.1 $  $Date: 03/31/2014 11:47:26.288 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

enum = this.getEnum();
enum = mergestructs(enum_input, enum);

N = size(trialMatrix, 2);   % total number of trials
trial_starts = trialMatrix(enum.trialMatrix.trialStartIndex, :)';
trial_ends  = trialMatrix(enum.trialMatrix.trialStopIndex, :)';

trial_props = zeros( N, this.trial_props_size);
trial_props(:,enum.start_index) = trial_starts;
trial_props(:,enum.end_index)   = trial_ends;
trial_props(:,enum.duration)    = (trial_ends - trial_starts + 1)/samplerate*1000;
for i = 1:N
    if ( ~isempty( left_fixation_props ) )
        trial_props(i,enum.left_fixtime) = sum( left_fixation_props(left_fixation_props(:,enum.fixation_props.ntrial)==i, enum.fixation_props.duration) );
    else
        trial_props(i,enum.left_fixtime) = NaN;
    end
    if ( ~isempty( right_fixation_props ) )
        trial_props(i,enum.right_fixtime) = sum( right_fixation_props(right_fixation_props(:,enum.fixation_props.ntrial)==i, enum.fixation_props.duration) );
    else
        trial_props(i,enum.right_fixtime) = NaN;
    end
end
trial_props(:,enum.ntrial)      = (1:N)';
trial_props(:,enum.condition)   = trialMatrix(enum.trialMatrix.trialCondIndex, :)';
trial_props(:,enum.cycle)       = trialMatrix(enum.trialMatrix.trialCycleIndex, :)';

end % function getprops

% [EOF]

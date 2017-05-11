function fixation_props = getprops( blinkYesNo, saccadeYesNo, isInTrial, isInTrialSequence, isInTrialCond, samplerate, usacc_props, enum_usacc_props )
% MLDFIXATION.GETPROPS (summary)
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

% Copyright 2013 Richard J. Cui. Created: 05/06/2013 11:09:50.923 AM
% $Revision: 0.1 $  $Date: 05/06/2013 11:09:50.939 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

enum = MLDFixation.getEnum();

% a fixation is a period of time that happens between saccades and blinks
% with no intertrial in between.

fixation_starts = find( diff([0;~(blinkYesNo | saccadeYesNo) & isInTrial])>0);
fixation_ends  = find( diff([~(blinkYesNo | saccadeYesNo) & isInTrial;0])<0);

fixation_props = zeros(length(fixation_starts), MLDFixation.fixation_props_size);

% -- Filter bad fixations --------------------------------------------
%-- remove fixations with intertrials in the middle

if ( ~isempty( fixation_starts ) )
    is_good = false(size(fixation_starts,1),1);
    for i=1:length(is_good)
        is_good(i) = sum( ~isInTrial( fixation_starts(i):fixation_ends(i)) ) == false;
    end
    
    % fixation_starts = fixation_starts( find( is_good ), :);
    % fixation_ends = fixation_ends( find( is_good ), :);
    fixation_starts = fixation_starts( is_good, :);
    fixation_ends = fixation_ends( is_good, :);

end

fixation_props(:,enum.start_index)  = fixation_starts;
fixation_props(:,enum.end_index)    = fixation_ends;
fixation_props(:,enum.duration)     = (fixation_ends-fixation_starts)/samplerate*1000;
fixation_props(:,enum.trial_seq)    = double(isInTrialSequence(fixation_props(:,enum.start_index)));
fixation_props(:,enum.condition)    = double(isInTrialCond(fixation_props(:,enum.start_index)));

% number of usaccs in the trial
for i=1:size(fixation_props,1)
    % find the microsaccade with indexes inside the period
    usacc_included = find( ...
        ( fixation_props(i,enum.start_index) < usacc_props(:,enum_usacc_props.start_index) ) & ...
        ( fixation_props(i,enum.end_index) > usacc_props(:,enum_usacc_props.start_index) ) );
    if ( usacc_included > 0 )
        fixation_props(i,enum.nusaccs) = length(usacc_included);
        fixation_props(i,enum.usacc_delay) =   ( usacc_props(usacc_included(1),enum_usacc_props.start_index) - fixation_props(i,enum.start_index) )/samplerate*1000;
    else
        fixation_props(i,enum.nusaccs)       = 0;
        fixation_props(i,enum.usacc_delay)   =  NaN;
    end
end

end % function getprops

% [EOF]

function saccade_props = getprops( eyedat, sac , samplerate, isInTrialSequence, isInTrialCond, sc_events, enum_event )
% MLDSACC.GETPROPS (summary)
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

enum = MLDSacc.getEnum();

saccade_props = zeros( size(sac,1), MLDSacc.saccade_props_size );

saccade_props(:,enum.start_index) = sac(:,enum.start_index);
saccade_props(:,enum.end_index)   = sac(:,enum.end_index);
saccade_props(:,enum.duration)    = MLDSacc.getduration( sac , samplerate );
saccade_props(:,enum.magnitude)   = MLDSacc.getmagnitude( eyedat, sac );
saccade_props(:,enum.magnitude2)  = MLDSacc.getmagnitude2( eyedat, sac );
saccade_props(:,enum.pkvel)       = MLDSacc.getpkvel( eyedat, sac );
saccade_props(:,enum.mnvel)       = MLDSacc.getmnvel( eyedat, sac );
saccade_props(:,enum.direction)   = MLDSacc.getdirection( eyedat, sac );
saccade_props(:,enum.trial_seq)   = double(isInTrialSequence(saccade_props(:,enum.start_index)));
saccade_props(:,enum.condition)   = double(isInTrialCond(saccade_props(:,enum.start_index)));

for i=1:size(sc_events,1)
    if ( sc_events(i,2) == enum_event.SACC )
        if (i > 1)
            saccade_props(sc_events(i,1),enum.pre_time)          = (sc_events(i,3)-sc_events(i-1,3))/samplerate*1000;
            saccade_props(sc_events(i,1),enum.pre_time_end)      = (sc_events(i,3)-sc_events(i-1,4))/samplerate*1000;
            saccade_props(sc_events(i,1),enum.pre_event)         = sc_events(i-1,2);
            saccade_props(sc_events(i,1),enum.pre_event_index)   = sc_events(i-1,1);
        end
        if(i < length(sc_events))
            saccade_props(sc_events(i,1),enum.post_time)         = (sc_events(i+1,3)-sc_events(i,3))/samplerate*1000;
            saccade_props(sc_events(i,1),enum.post_time_end)     = (sc_events(i+1,3)-sc_events(i,4))/samplerate*1000;
            saccade_props(sc_events(i,1),enum.post_event)        = sc_events(i+1,2);
            saccade_props(sc_events(i,1),enum.post_event_index)  = sc_events(i+1,1);
        end
    end
end

end % function getprops

% [EOF]

function usacc_props = getprops( eyedat, usac , samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
% MLDUsacc.GETPROPS (summary)
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

enum = MLDUsacc.getEnum();

usacc_props = zeros( size(usac,1), MLDUsacc.usacc_props_size );

usacc_props(:,enum.start_index) = usac(:,enum.start_index);
usacc_props(:,enum.end_index)   = usac(:,enum.end_index);
usacc_props(:,enum.duration)    = MLDUsacc.getduration( usac , samplerate );
usacc_props(:,enum.magnitude)   = MLDUsacc.getmagnitude( eyedat, usac );
usacc_props(:,enum.magnitude2)  = MLDUsacc.getmagnitude2( eyedat, usac );
usacc_props(:,enum.pkvel)       = MLDUsacc.getpkvel( eyedat, usac );
usacc_props(:,enum.mnvel)       = MLDUsacc.getmnvel( eyedat, usac );
usacc_props(:,enum.direction)   = MLDUsacc.getdirection( eyedat, usac );
usacc_props(:,enum.trial_seq)   = double(isInTrialSequence(usacc_props(:,enum.start_index)));
usacc_props(:,enum.condition)   = double(isInTrialCond(usacc_props(:,enum.start_index)));

for i=1:size(em_events,1)
    if ( em_events(i,2) == enum_event.USACC )
        if (i > 1)
            usacc_props(em_events(i,1),enum.pre_time)          = (em_events(i,3)-em_events(i-1,3))/samplerate*1000;
            usacc_props(em_events(i,1),enum.pre_time_end)      = (em_events(i,3)-em_events(i-1,4))/samplerate*1000;
            usacc_props(em_events(i,1),enum.pre_event)         = em_events(i-1,2);
            usacc_props(em_events(i,1),enum.pre_event_index)   = em_events(i-1,1);
        end
        if(i < length(em_events))
            usacc_props(em_events(i,1),enum.post_time)         = (em_events(i+1,3)-em_events(i,3))/samplerate*1000;
            usacc_props(em_events(i,1),enum.post_time_end)     = (em_events(i+1,3)-em_events(i,4))/samplerate*1000;
            usacc_props(em_events(i,1),enum.post_event)        = em_events(i+1,2);
            usacc_props(em_events(i,1),enum.post_event_index)  = em_events(i+1,1);
        end
    end
end

end % function getprops

% [EOF]

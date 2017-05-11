function blink_props = getprops( blinkYesNo, samplerate, isInTrialSequence, isInTrialCond, em_events, enum_event )
% BCTBLINK.GETPROPS (summary)
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

enum = BCTBlink.getEnum();

blink_starts = find( diff([0;blinkYesNo])>0 );
blink_ends  = find( diff([blinkYesNo;0])<0 );

blink_props = zeros( length(blink_starts), BCTBlink.blink_props_size );

blink_props(:,enum.start_index) = blink_starts;
blink_props(:,enum.end_index)   = blink_ends;
blink_props(:,enum.duration)    = (blink_ends-blink_starts)/samplerate*1000;
blink_props(:,enum.trial_seq)   = double(isInTrialSequence(blink_props(:,enum.start_index)));
blink_props(:,enum.condition)   = double(isInTrialCond(blink_props(:,enum.start_index)));

for i=1:size(em_events,1)
    if ( em_events(i,2) == enum_event.BLINK )
        if (i > 1)
            blink_props(em_events(i,1),enum.pre_time)          = (em_events(i,3)-em_events(i-1,3))/samplerate*1000;
            blink_props(em_events(i,1),enum.pre_time_end)      = (em_events(i,3)-em_events(i-1,4))/samplerate*1000;
            blink_props(em_events(i,1),enum.pre_event)         = em_events(i-1,2);
            blink_props(em_events(i,1),enum.pre_event_index)   = em_events(i-1,1);
        end
        if(i < length(em_events))
            blink_props(em_events(i,1),enum.post_time)         = (em_events(i+1,3)-em_events(i,3))/samplerate*1000;
            blink_props(em_events(i,1),enum.post_time_end)     = (em_events(i+1,3)-em_events(i,4))/samplerate*1000;
            blink_props(em_events(i,1),enum.post_event)        = em_events(i+1,2);
            blink_props(em_events(i,1),enum.post_event_index)  = em_events(i+1,1);
        end
    end
end

end % function getprops

% [EOF]

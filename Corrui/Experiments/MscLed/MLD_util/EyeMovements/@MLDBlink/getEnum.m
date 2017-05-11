function blink_props_enum = getEnum()
% MLDBLINK.GETENUM (summary)
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

% Copyright 2013 Richard J. Cui. Created: 05/06/2013 11:05:27.443 AM
% $Revision: 0.1 $  $Date: 05/06/2013 11:05:27.443 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

enum.start_index        = 1;
enum.end_index          = 2;
enum.duration           = 3;
enum.trial_seq          = 4;
enum.condition          = 5;
enum.pre_time           = 6;
enum.pre_event          = 7;
enum.post_time          = 8;
enum.post_event         = 9;
enum.pre_time_end       = 10;
enum.post_time_end      = 11;
enum.pre_event_index    = 12;
enum.post_event_index   = 13;

blink_props_enum = enum;

end % function getEnum

% [EOF]

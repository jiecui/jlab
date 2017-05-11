function usacc_props_enum = getEnum()
% BCTUSACC.GETENUM (summary)
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
enum.magnitude          = 4;
enum.magnitude2         = 5;
enum.pkvel              = 6;
enum.mnvel              = 7;
enum.direction          = 8;
enum.trial_seq          = 9;
enum.condition          = 10;
enum.pre_time           = 11;
enum.pre_event          = 12;
enum.post_time          = 13;
enum.post_event         = 14;
enum.pre_time_end       = 15;
enum.post_time_end      = 16;
enum.pre_event_index    = 17;
enum.post_event_index   = 18;

usacc_props_enum = enum;

end % function getEnum

% [EOF]

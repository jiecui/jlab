function fixation_props_enum = getEnum()
% BCTFIXATION.GETENUM (summary)
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
enum.nusaccs            = 6;
enum.usacc_delay        = 7;
enum.nusaccsbin         = 8;
enum.usaccbin_delay     = 9;
enum.magnitude          = 10;
enum.direction          = 11;
enum.x_mean_location    = 12;
enum.y_mean_location    = 13;

fixation_props_enum = enum;

end % function getEnum

% [EOF]

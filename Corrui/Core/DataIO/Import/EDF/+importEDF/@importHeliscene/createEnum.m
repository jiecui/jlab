function enum = createEnum(this)
% CREATEENUM creates enums for data importing and analysis
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

% Copyright 2013 Richard J. Cui. Created: 03/14/2013 10:02:08.143 PM
% $Revision: 0.1 $  $Date: 03/14/2013 10:02:08.143 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% samples
% --------
samples.timestamps     = 1;
samples.left_x         = 2;
samples.left_y         = 3;
samples.right_x        = 4;
samples.right_y        = 5;

% edf samples
% -----------
edf_samples.timestamps  = 1;
edf_samples.left_x      = 2;
edf_samples.left_y      = 3;
edf_samples.right_x     = 4;
edf_samples.right_y     = 5;

% edf gaze samples
% -----------------
edf_gaze_samples.timestamps  = 1;
edf_gaze_samples.left_x      = 2;
edf_gaze_samples.left_y      = 3;
edf_gaze_samples.right_x     = 4;
edf_gaze_samples.right_y     = 5;

% pupil samples
% --------------
pupil_samples.left_pupil_size   = 1;
pupil_samples.right_pupil_size  = 2;


enum.samples = samples;
enum.edf_samples = edf_samples;
enum.edf_gaze_samples = edf_gaze_samples;
enum.pupil_samples = pupil_samples;

this.enum = enum;

end % function createEnum

% [EOF]

function tp_size = trial_props_size(this)
% EXPTRIAL.TRIAL_PROPS_SIZE (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/31/2014 11:42:54.841 AM
% $Revision: 0.1 $  $Date: 03/31/2014 11:42:54.856 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

trial_props_enum = this.getEnum();
fnames = fieldnames(trial_props_enum);
tp_size = length(fnames);

end % function trial_props_size

% [EOF]

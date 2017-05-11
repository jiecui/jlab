function fp_size = fixation_props_size()
% FIXATION_PROPS_SIZE (summary)
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

% Copyright 2013 Richard J. Cui. Created: 05/06/2013 10:37:14.712 PM
% $Revision: 0.1 $  $Date: 05/06/2013 10:37:14.715 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

fixation_props_enum = MLDFixation.getEnum();
fnames = fieldnames(fixation_props_enum);
fp_size = length(fnames);

end % function fixation_props_size

% [EOF]

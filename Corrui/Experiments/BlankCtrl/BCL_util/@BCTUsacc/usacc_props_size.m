function up_size = usacc_props_size()
% USACC_PROP_SIZE (summary)
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

% Copyright 2013 Richard J. Cui. Created: 05/06/2013  9:20:00.104 PM
% $Revision: 0.1 $  $Date: 05/06/2013  9:20:00.107 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

usacc_props_enum = BCTUsacc.getEnum;
fdnames = fieldnames(usacc_props_enum);
up_size = length(fdnames);

end % function usacc_prop_size

% [EOF]

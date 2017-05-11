function bp_size = blink_props_size()
% BCTBlink.BLINK_PROP_SIZE (summary)
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

blink_props_enum = BCTBlink.getEnum;
fdnames = fieldnames(blink_props_enum);
bp_size = length(fdnames);

end % function usacc_prop_size

% [EOF]

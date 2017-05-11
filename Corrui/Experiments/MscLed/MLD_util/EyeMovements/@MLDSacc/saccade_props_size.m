function sp_size = saccade_props_size()
% SACCADE_PROPS_SIZE (summary)
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

% Copyright 2013-2014 Richard J. Cui. Created: 05/06/2013  9:20:00.104 PM
% $Revision: 0.2 $  $Date: Wed 07/16/2014  3:35:55.765 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

sacc_props_enum = MLDSacc.getEnum;
fdnames = fieldnames(sacc_props_enum);
sp_size = length(fdnames);

end % function usacc_prop_size

% [EOF]

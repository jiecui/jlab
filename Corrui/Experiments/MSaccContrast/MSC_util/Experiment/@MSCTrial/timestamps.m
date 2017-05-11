function ts = timestamps(this)
% TIMESTAMPS gets the timestamps of this session
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

% Copyright 2013 Richard J. Cui. Created: 05/20/2013  9:23:49.586 PM
% $Revision: 0.1 $  $Date: 05/20/2013  9:23:49.590 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

sname = this.sname;
vars = { 'timestamps' };

dat = CorruiDB.Getsessvars(sname, vars);
ts = dat.timestamps;

end % function timestamps

% [EOF]

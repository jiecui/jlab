function dname = SesName2DatName(this, sname)
% DATAIO.SESNAME2DATNAME find data file name from session name
% 
% Note:
%   DataIO class method
%
% Syntax:
%       dname = SesName2DatName(sname)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 06/05/2013 11:39:52.604 AM
% $Revision: 0.2 $  $Date: Sat 07/06/2013  9:09:13.071 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

vars = { 'internalTag' };
dat = CorruiDB.Getsessvars(sname, vars);
iTag = dat.internalTag;
id_iTag = iTag(end-4:end);
prefix = this.prefix;  % length of prefix

% check if the session is an aggregated session or not
if strcmp(id_iTag, '_Avg')
    head = sprintf('%s', [prefix, 'ag']);
else
    head = prefix;
end % if
[~, headend] = regexp(sname, head);
dname = sname(headend + 1:end);

end % function SesName2DatName

% [EOF]

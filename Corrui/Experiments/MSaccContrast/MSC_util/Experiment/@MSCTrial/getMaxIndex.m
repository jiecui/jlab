function maxIndex = getMaxIndex(this)
% GETMAXINDEX get the maximum index / length of timestamps
%
% Syntax:
%   maxIndex = getMaxIndex(sname)
% 
% Input(s):
%   sname       - session name
% 
% Output(s):
%   maxIndex    - max index or length of timestamps
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 04/25/2013 11:03:31.793 AM
% $Revision: 0.1 $  $Date: 04/25/2013 11:03:31.793 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

dat = this.db.Getsessvars(this.sname, {'timestamps'});
timestamps = dat.timestamps;

maxIndex = length(timestamps);

this.maxIndex = maxIndex;

end % function getMaxIndex

% [EOF]

function num_cond = getNumberCondition(this)
% GETNUMBERCONDITION (summary)
%
% Syntax:
%
% Input(s):
%   this        - MLDTrial object
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/07/2013  3:54:59.406 PM
% $Revision: 0.1 $  $Date: 05/07/2013  3:54:59.406 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

dat = CorruiDB.Getsessvars(this.sname, {'NumberCondition'});
num_cond = dat.NumberCondition;
this.num_conditions = num_cond;

end % function getNumberCondition

% [EOF]

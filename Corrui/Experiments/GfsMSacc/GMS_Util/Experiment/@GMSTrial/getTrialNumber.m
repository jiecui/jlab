function ntrl = getTrialNumber(this)
% GETTRIALNUMBER (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%   ntrl        - number of trials
%                 .SubjDisp
%                 .SubjNoDisp
%                 .PhysDisp
% 
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 08/13/2016  7:28:48.284 AM
% $Revision: 0.1 $  $Date: Sat 08/13/2016  7:28:48.301 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

lfp = this.db.Getsessvar(this.sname, 'LFP');

if isfield(lfp, 'SubjDisp')
    ntrl_subjdisp = size(lfp.SubjDisp, 3);
else
    ntrl_subjdisp = [];
end % if

if isfield(lfp, 'SubjNoDisp')
    ntrl_subjnodisp = size(lfp.SubjNoDisp, 3);
else
    ntrl_subjnodisp = [];
end % if

if isfield(lfp, 'PhysDisp')
    ntrl_physdisp = size(lfp.PhysDisp, 3);
else
    ntrl_physdisp = [];
end % if

this.SubjDispTrialNumber    = ntrl_subjdisp;
this.SubjNoDispTrialNumber  = ntrl_subjnodisp;
this.PhysDispTrialNumber    = ntrl_physdisp;

if nargout > 0
    ntrl.SubjDispTrialNumber    = ntrl_subjdisp;
    ntrl.SubjNoDispTrialNumber  = ntrl_subjnodisp;
    ntrl.PhysDispTrialNumber    = ntrl_physdisp;
end % if

end % function getTrialNumber

% [EOF]

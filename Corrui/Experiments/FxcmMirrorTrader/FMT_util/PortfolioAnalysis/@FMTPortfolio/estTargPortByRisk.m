function [tport, trsk, tret] = estTargPortByRisk(this, mon_targrsk)
% FMTPORTFOLIO.ESTTARGPORTBYRISK (summary)
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

% Copyright 2015 Richard J. Cui. Created: Thu 01/01/2015 12:23:27.216 PM
% $Revision: 0.1 $  $Date: Thu 01/01/2015 12:23:27.218 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% first find the range of return and risk and check the targets
limrsk = estimatePortMoments(this, estimateFrontierLimits( this ));

if mon_targrsk < min(limrsk) || mon_targrsk > max(limrsk)
    cprintf('Error', 'Target risk is out of range\n' )
    tport = [];
    trsk = [];
    tret = [];
    return
end % if

% Obtain portfolios with targeted return and risk
tport = estimateFrontierByRisk(this, mon_targrsk);
[trsk, tret] = estimatePortMoments(this, tport);

end % function estTargPortbyReturn

% [EOF]

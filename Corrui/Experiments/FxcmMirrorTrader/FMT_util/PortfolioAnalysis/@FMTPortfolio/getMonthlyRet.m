function mon_return = getMonthlyRet( this, monret_all, conct_vars )
% FMTPORTFOLIO.GETMONTHLYRET gets the structure of monthly return
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

% Copyright 2015 Richard J. Cui. Created: Thu 01/01/2015 10:30:24.658 AM
% $Revision: 0.1 $  $Date: Thu 01/01/2015 10:30:24.660 AM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

num_asset = numel(this.Property);
AssetInfo = this.AssetInfo;

mon_return = {};
for k = 1:num_asset
    idx_k = conct_vars.MonthlyReturn.sessionflag == AssetInfo.AssetIdx(k);
    monret_k = monret_all(idx_k, :);
    asse_k = AssetInfo.AssetName{k};    % cell --> char
    
    mon_return.(asse_k) = monret_k;
end % for

end % function getMonthlyRet

% [EOF]

function this = setMonthlyReturnFts(this, date_start, date_end)
% PORTMEANVAR.SETMONTHLYRETURNFTS construct a fints object of monthly return
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

% Copyright 2014 Richard J. Cui. Created: Tue 12/23/2014  1:18:47.203 PM
% $Revision: 0.1 $  $Date: Tue 12/23/2014  1:18:47.211 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

asset_info = this.AssetInfo;
mon_return = this.MonthlyReturn;

num_asset = height(asset_info);
asset_name = asset_info.AssetName;

d = (datenum(date_start):datenum(date_end))';
monret_fts = fints(d, zeros(numel(d), num_asset), asset_name);
monret_fts = tomonthly(monret_fts);

num_month = size(monret_fts, 1);
for m = 1:num_month
    date_m = monret_fts.dates(m);   % datenum
    
    for s = 1:num_asset
        startdate_s = mon_return.(asset_name{s}).StartDate;
        enddate_s   = mon_return.(asset_name{s}).EndDate;
        
        idx_s = date_m >= datenum(startdate_s) & date_m <= datenum(enddate_s);
        if sum(idx_s) == 1
            monret_fts.(asset_name{s})(m) = mon_return.(asset_name{s}).Pips(idx_s);
        end %if
        
    end % for
end % for

this.MonRetFts = monret_fts;

end % function setMonthlyReturnFts

% [EOF]

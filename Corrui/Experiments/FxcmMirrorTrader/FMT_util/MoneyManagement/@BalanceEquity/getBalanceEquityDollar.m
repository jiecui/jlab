function bed = getBalanceEquityDollar(this, int_openclose, open_trades)
% BALANCEEQUITY.GETBALANCEEQUITYDOLLAR get balance/equity in dollars
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 01/15/2016 11:43:13.725 AM
% $Revision: 0.4 $  $Date: Sun 01/24/2016 11:05:22.776 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

[bal, gain, dd, unrel_gain, unrel_dd] = this.calBalanceEquityDollar(int_openclose, open_trades);
rel_bed = this.BETable(bal, gain, dd, int_openclose);

bed.Realized = rel_bed;
bed.UnRealized.CumHigh = unrel_gain;
bed.UnRealized.CumLow = unrel_dd;

end % function getBalanceEquityDollar

% [EOF]

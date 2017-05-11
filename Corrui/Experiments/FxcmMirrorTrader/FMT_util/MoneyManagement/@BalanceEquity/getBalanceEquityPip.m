function bep = getBalanceEquityPip(this, int_openclose, open_trades)
% BALANCEEQUITY.GETBALANCEEQUITYPIP get balance/equity in pips
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

% Copyright 2016 Richard J. Cui. Created: Fri 01/15/2016 11:40:53.829 AM
% $Revision: 0.4 $  $Date: Sun 01/24/2016 11:05:22.776 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

[bal, gain, dd, unrel_gain, unrel_dd] = this.calBalGainDrawdown(int_openclose, open_trades);
rel_bep = BETable(this, bal, gain, dd, int_openclose);

bep.Realized = rel_bep;
bep.UnRealized.CumHigh = unrel_gain;
bep.UnRealized.CumLow = unrel_dd;

end % function getBalanceEquityPip

% [EOF]

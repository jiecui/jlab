function [imported_data, stage0_data] = stage0process(this, sname, options)
% FXCMMIRRORTRADER.STAGE0PROCESS PreProcess trial infomation in Stage 0
%
% Syntax:
%
% Input(s):
%   sname       - get session name
%   opt         - stage 0 options
% 
% Output:
%   imported_data   - imported data for Stage 0 processing
%   stage0_data     - new data produced by state 0 processing
% 
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: Sat 11/15/2014  7:27:33.848 PM
% $Revision: 0.5 $  $Date: Sat 01/16/2016  9:34:53.395 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Convert pixels to visual angle
% =========================================================================

% get the variables from the imported data
% ---------------------------------------------
vars = {'info', 'Property', 'History'};
imported_data = this.db.Getsessvars( sname, vars );

% -- process trial infomation: trial starts and stops,
% conditions, trial number
stage0_data = processTrial( imported_data );

end % function stage0process

% =========================================================================
% Subroutines
% =========================================================================
function out_data = processTrial( in_data )

strat_prop = in_data.Property;
num_trades = 0;

fmt_history = FMTHistory(num_trades, strat_prop);
fmt_history.TradeHistory = in_data.History;

trade_openclose = fmt_history.setTradeOpenClose;
[pl_pip, pl_dollar] = fmt_history.setMonthlyProfitLoss;

out_data.TradeOpenClose = trade_openclose;
out_data.MonthlyPnL.Pip = pl_pip;
out_data.MonthlyPnL.Dollar = pl_dollar;

end % funciton
% [EOF]

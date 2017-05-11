function [fitobj, gof] = fitBalanceCurve( this )
% FITBALANCECURVE fits Balance curve in an interval
%
% Syntax:
%
% Input(s):
%   this        - BalanceEquity object
% 
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Mon 11/24/2014 12:00:45.695 PM
% $Revision: 0.1 $  $Date: Mon 11/24/2014 12:00:45.702 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

bep = this.BalanceEquityPips;
dates = datenum(bep.EventDate);
accbal = bep.ProfitLoss;
fittype = this.FitType;
[fitobj, gof] = fit(dates, accbal, fittype, 'Normalize', 'on');

end % function calBalanceCurve

% [EOF]

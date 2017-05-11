function be = BETable(this, bal, gain, dd, int_openclose)
% BALANCEEQUITY.BETABLE construct balance/equity table
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

% Copyright 2016 Richard J. Cui. Created: Fri 01/15/2016 11:45:36.257 AM
% $Revision: 0.1 $  $Date: Fri 01/15/2016 11:45:36.264 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

t = table(bal, gain, dd);
be = [int_openclose(:, { 'EventDate' }), t];
be.Properties.VariableNames = this.BEVariableNames;

end % function BETable

% [EOF]

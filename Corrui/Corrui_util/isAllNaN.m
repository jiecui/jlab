function is = isAllNaN( v )
% ISALLNAN (summary)
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

% Copyright 2016 Richard J. Cui. Created: Fri 08/05/2016  8:24:29.404 PM
% $Revision: 0.1 $  $Date: Fri 08/05/2016  8:24:29.515 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

is = sum(isnan(v)) == length(v);

end % function isAllNaN

% [EOF]

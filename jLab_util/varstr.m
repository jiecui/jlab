function vstrs = varstr(varargin)
% VARNAME get the name string of the input variables
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

% Copyright 2016 Richard J. Cui. Created: Fri 06/10/2016 12:43:00.690 PM
% $Revision: 0.1 $  $Date: Fri 06/10/2016 12:43:00.714 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if nargin == 0
    vstrs = '';
elseif nargin == 1;
    vstrs = inputname(nargin);
else
    vstrs = cell(nargin, 1);
    for n = 1:nargin
        vstrs{n} = inputname(n);
    end % for
end % if

end % function varname

% [EOF]

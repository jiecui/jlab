function mc = Michelson(l_min, l_max)
% MICHELSON cal Michelson contrast
%
% Syntax:
%   mc = Michelson(l_min, l_max)
% 
% Input(s):
%   l_min   - minimum luminance
%   l_max   - maximum luminance
% 
% Output(s):
%   mc      - Michelson contrast in percentage
% 
% Example:
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 01/20/2012  6:19:19.092 PM
% $Revision: 0.1 $  $Date: 01/20/2012  6:19:19.092 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

mc = round((l_max - l_min) / (l_max + l_min) * 100);

end % function Michelson

% [EOF]

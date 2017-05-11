function numCond = Cont2Condnum(this, cont1, cont2)
% CONT2CONDNUM gets condition sequence number from a pair of contrasts
%
% Syntax:
%   numCond = Cont2Condnum(cont1, cont2)
% 
% Input(s):
%   cont1       - contrast one (0%, 10%, ..., 100%)
%   cont2       - contrast two
% 
% Output(s):
%   numCond     - condition sequence, 1,2,...121
% 
% Example:
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 01/24/2012 10:23:51.389 AM
% $Revision: 0.1 $  $Date: 01/24/2012 10:23:53.155 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

nlevel = length(this.ContrastLevel);
numCond = cont1 / 10 * nlevel + cont2 / 10 + 1;

end % function Cont2Condnum

% [EOF]

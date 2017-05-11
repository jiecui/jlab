function [cont1, cont2] = Condnum2Cont(this, numCond)
% CONDNUM2CONT get contrast pair from condition number
%
% Syntax:
%   [cont1, cont2] = Condnum2Cont(numCond)
% 
% Input(s):
%   numCond     - condition sequence, 1,2,...121
%
% Output(s):
%   cont1       - contrast one (0%, 10%, ..., 100%)
%   cont2       - contrast two
%
% Example:
%
% See also .

% Copyright 2011 Richard J. Cui. Created: 01/24/2012 10:42:30.347 AM
% $Revision: 0.1 $  $Date: 01/24/2012 10:42:30.347 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if numCond < 1 || numCond > 121
    error('Condnum2Cont:argChk', 'Condition number must be between 1 and 121')
end % if

num = numCond - 1;
cont1 = 10 * floor(num / 11);
cont2 = 10 * mod(num, 11);

end % function Condnum2Cont

% [EOF]

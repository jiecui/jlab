function params = initChronuxMTM( this ) 
% LOCALFIELDPOTENTIAL.INITCHRONUXMTM (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2015 Richard J. Cui. Created: Thu 02/05/2015 12:46:38.676 PM
% $Revision: 0.1 $  $Date: Thu 02/05/2015 12:46:38.679 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

params.tapers   = [3, 5];
params.pad      = 0;
params.Fs       = 1;
params.fpass    = [0, params.Fs/2];
params.err      = 0;
params.trialave = 0;

this.ChronuxMTMParams = params;

end % function initChronuxMTM

% [EOF]

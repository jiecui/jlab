function [pxx, f] = ChronuxMTMSpec(this, lfp)
% LOCALFIELDPOTENTIAL.CHRONUXMTMSPEC Chronux MTM spectrum
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

% Copyright 2015 Richard J. Cui. Created: Thu 02/05/2015  5:03:33.336 PM
% $Revision: 0.1 $  $Date: Thu 02/05/2015  5:03:33.411 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

params = this.ChronuxMTMParams;

[pxx, f] = mtspectrumc(lfp, params);

end % function ChronuxMTMSpec

% [EOF]

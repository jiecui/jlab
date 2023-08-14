function [S, t, f] = ChronuxMTMSpecgram(this, X)
% LOCALFIELDPOTENTIAL.CHRONUXMTMSPECGRAM Chronux MTM spectrogram
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

% Copyright 2015 Richard J. Cui. Created:Sun 03/01/2015  9:58:27.724 AM
% $Revision: 0.1 $  $Date: Sun 03/01/2015  9:58:27.724 AM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

movingwin = this.ChronuxMovingWin;
params = this.ChronuxMTMParams;

[S, t, f] = mtspecgramc(X, movingwin, params);

end % function ChronuxMTMSpec

% [EOF]

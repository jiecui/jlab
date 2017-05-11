function [this, efport, efrsk, efret] = estEffFrontPortMV(this, num_port_frontier)
% FMTPORTFOLIO.ESTEFFFRONTPORTMV (summary)
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

% Copyright 2015 Richard J. Cui. Created: Thu 01/01/2015 12:12:22.631 PM
% $Revision: 0.1 $  $Date: Thu 01/01/2015 12:12:22.634 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

this = setDefaultConstraints(this);
efport = estimateFrontier(this, num_port_frontier);
[efrsk, efret] = estimatePortMoments(this, efport);

end % function estEffFrontPortMV

% [EOF]

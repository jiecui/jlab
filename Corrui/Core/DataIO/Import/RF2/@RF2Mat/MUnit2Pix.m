function Y = MUnit2Pix(this,X)
% MUNIT2PIX change eye signals unit from machine unit to pixels
%
% Syntax:
%   Y = MUnit2Pix(this,X)
% 
% Input(s):
%   this    - RF2Mat object
%   X       - N x 2 coordinates in machine unit
% 
% Output(s):
%   Y       - N x 2 coordinates in arcmin
% 
% Output(s):
%
% Example:
%
% See also .

% Copyright 2010 Richard J. Cui. Created: 02/11/2011  1:40:58.185 PM
% $Revision: 0.1 $  $Date: 02/11/2011  1:40:58.200 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% parameters
maxr = this.MaxRes;
pmr = this.ParaDisp.PixMaxRes;

% output
Y = pmr/maxr*X;

end % function MUnit2Pix

% [EOF]

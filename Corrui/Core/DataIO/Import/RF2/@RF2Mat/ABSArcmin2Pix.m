function Y = ABSArcmin2Pix(this,X)
% ABSARCMIN2PIX converts arcmin to pixels
%
% Syntax:
%
% Input(s):
%   X       - N x 2 coordinates in min arc
% 
% Output(s):
%   Y       - N x 2 coordinates in pixels
% 
% Example:
%
% See also .

% Copyright 2010 Richard J. Cui. Created: 03/11/2010  4:12:11.298 PM
% $Revision: 0.1 $  $Date: 03/11/2010  4:12:11.314 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%   B           - convert pixels --> arcmin
%                 B(1) = x-axis factor
%                 B(2) = y-axis factor
para = this.ParaDisp;
a = para.HorAngle;
b = para.VerAngle;
c = para.HorWidth;
d = para.VerWidth;
B = [a/c,b/d]*60;
Y = [B(1),0; 0,B(2)]^-1*X'; 
Y = round(Y');

end % function ABSPix2Arcmin

% [EOF]

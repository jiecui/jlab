function [stimulus,poly_vert] = renderStim(this)
% RENDERSTIM renders the image of the stimulus
%
% Syntax
%   stimulus = renderStim(this)
% 
% Input(s):
%   this            - object of the RF2Mat class
% 
% Output(s):
%   stimulus        - rendered image
%   poly_vert       - vertices of polygons
% 
% Example:
%
% See also .

% Copyright 2010-2011 Richard J. Cui. Created: 02/26/2010 11:17:24.247 AM
% $Revision: 0.3 $  $Date: Wed 04/06/2011  4:17:34 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

stim_type = this.Stimulus.type;

if isempty(stim_type)
    stim_type = this.getStimType;
end % if

data = this.Stimulus.data;
switch upper(stim_type)
    case 'DIAG'
        stim_imag = this.renderDiag(data);
    case 'CORNERS'
        [stim_imag,vert] = this.renderCorners(data);
    otherwise
        error('Unknown/unprocessed stimulus type.')
end % switch

% output
this.Stimulus.image = stim_imag;
this.Stimulus.poly_vert = vert;
stimulus = stim_imag;
poly_vert = vert;

end % function renderStim

% [EOF]

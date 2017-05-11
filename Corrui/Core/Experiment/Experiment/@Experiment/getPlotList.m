function plotList = getPlotList( this )
% GETPLOTLIST (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/17/2014  9:04:00.859 AM
% $Revision: 0.1 $  $Date: 03/17/2014  9:04:00.859 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

methods = this.getStaticMethodNames( [class(this) 'Plots'] );
plotList = fliplr(methods);

end % function getPlotList

% [EOF]

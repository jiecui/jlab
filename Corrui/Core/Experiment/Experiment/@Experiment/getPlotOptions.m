function opt = getPlotOptions( this )
% GETPLOTOPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/24/2014 10:18:07.299 PM
% $Revision: 0.1 $  $Date: 03/24/2014 10:18:07.302 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

optExp = this.getPlotExperimentOptions();
optGen = this.getPlotGeneralOptions();

opt = mergestructs( optGen, optExp );

end % function getPlotOptions

% [EOF]

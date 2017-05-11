function opt = getAggregateOptions( this )
% GETAGGREGATEOPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/25/2014  9:48:57.523 AM
% $Revision: 0.1 $  $Date: 03/25/2014  9:48:57.523 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com


optGen = this.getAggregateGeneralOptions();

optExp = this.getAggregateExperimentOptions();

opt = mergestructs(optGen, optExp);

end % function getAggregateOptions

% [EOF]

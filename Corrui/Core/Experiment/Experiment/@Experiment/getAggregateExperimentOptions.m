function opt = getAggregateExperimentOptions( this )
% GETAGGREGATEEXPERIMENTOPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/25/2014  9:59:15.530 AM
% $Revision: 0.1 $  $Date: 03/25/2014  9:59:15.530 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

opt = [];
aggregateList = this.getAggregateList(  );

for i=1:length(aggregateList)
    % opt.(aggregateList{i}) = { {'0','{1}'} };
    % try
    options = this.aggregateClass.(aggregateList{i})('get_options');
    if ( ~isempty(options) )
        opt.(aggregateList{i}) = options;
    end
    % end
end

end % function getAggregateExperimentOptions

% [EOF]

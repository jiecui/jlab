function opt = getAggregateGeneralOptions( this )
% GETAGGREGATEGENERALOPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/25/2014  9:51:23.534 AM
% $Revision: 0.1 $  $Date: 03/25/2014  9:51:23.549 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

opt.Name_of_New_Aggregated_Session = '';
opt.Filters_To_Use = CorrGui.filter_conditions( 'get_plot_options', class(this) );
fnames = fieldnames(opt.Filters_To_Use);
for i = 1:length(fnames)
    fname = fnames{i};
    opt.Filters_To_Use.(fname) = { {'0', '{1}' } };
end

end % function getAggregateGeneralOptions

% [EOF]

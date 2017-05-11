function opt = getPlotExperimentOptions( this )
% GETPLOTEXPERIMENTOPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/24/2014 10:29:29.740 PM
% $Revision: 0.1 $  $Date: 03/24/2014 10:29:29.744 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

plotList = this.getPlotList(  );

for i=1:length(plotList)
    opt.(plotList{i}) = { {'{0}','1'} };
    try
        options = this.plotClass.(plotList{i})('get_options');
        if ( ~isempty(options) )
            opt.([plotList{i} '_options']) = options;
        end
    catch err
        fprintf('Cannot get options in plot function %s\n', plotList{i})
        rethrow(err)
    end
end

end % function getPlotExperimentOptions

% [EOF]

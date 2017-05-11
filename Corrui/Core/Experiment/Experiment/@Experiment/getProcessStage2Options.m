function opt = getProcessStage2Options( this )
% GETPROCESSSTAGE2OPTIONS (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/16/2014  9:26:28.344 PM
% $Revision: 0.1 $  $Date: 03/16/2014  9:26:28.347 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

opt = [];

% first gets the analysis list (Static Methods of the
% ExperimentAnalysis class) and the options corresponding to
% each analysis
analysisList = this.getProcessAnalysisList( );
for i=1:length(analysisList)
    opt.(analysisList{i}) = { {'{0}','1'} };
    options = this.analysisClass.(analysisList{i})( 'get_options' );
    if ( ~isempty(options) )
        opt.([analysisList{i} '_options']) = options;
    end
end

% then gets the global options from all the get_options
% functions of the ExperimentAnalysis class and parents
analysis_options = [];
myclass = meta.class.fromName(class(this));
while( ~isempty( myclass.SuperClasses ) )
    analysis_class = [myclass.Name 'Analysis'];
    p = which(analysis_class);
    if ~isempty(p)  % this class exists
        if ( ismethod( eval(analysis_class), 'get_options') )
            % analysis_options = mergestructs( feval([myclass.Name 'Analysis.get_options']), analysis_options);
            analysis_options = mergestructs( feval([analysis_class '.get_options']), analysis_options);
        end
    end % if
    myclass = myclass.SuperClasses{1};
end
% add always the Trial Category at the end
analysis_options.Trial_Category = CorrGui.filter_conditions('get_plot_options',class(this));

% select the most used analysis
opt = mergestructs( opt, analysis_options);


end % function getProcessStage2Options

% [EOF]

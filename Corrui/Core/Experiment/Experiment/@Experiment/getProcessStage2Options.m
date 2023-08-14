function opt = getProcessStage2Options( this )
% EXPERIMENT.GETPROCESSSTAGE2OPTIONS get options of stage 2 analysis
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

% Copyright 2014-2020 Richard J. Cui. Created: 03/16/2014  9:26:28.344 PM
% $Revision: 0.2 $  $Date: Sat 05/02/2020  9:29:21.591 AM $
%
% Multimodal Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

% 1st gets the global options from all the get_options
% functions of the ExperimentAnalysis class and parents
% -----------------------------------------------------
analysis_options = [];
myclass = meta.class.fromName(class(this));
while( ~isempty( myclass.SuperClasses ) )
    analysis_class = [myclass.Name 'Analysis'];
    p = which(analysis_class);
    if ~isempty(p)  % this class exists
        if ( ismethod( eval(analysis_class), 'get_options') )
            analysis_options = mergestructs( feval([analysis_class,...
                '.get_options']), analysis_options);
        end
    end % if
    myclass = myclass.SuperClasses{1};
end


% 2nd gets the analysis list (Static Methods of the
% ExperimentAnalysis class) and the options corresponding to
% each analysis
opt = [];
analysisList = this.getProcessAnalysisList( );
for i=1:length(analysisList)
    opt.(analysisList{i}) = { {'{0}','1'} };
    options = this.analysisClass.(analysisList{i})( 'get_options' );
    if ( ~isempty(options) )
        opt.([analysisList{i} '_options']) = options;
    end
end

% 3rd adds the Trial Category at the end
% ----------------------------------------
opt.Trial_Category = CorrGui.filter_conditions('get_plot_options',class(this));

% select the most used analysis
opt = mergestructs( analysis_options, opt);


end % function getProcessStage2Options

% [EOF]

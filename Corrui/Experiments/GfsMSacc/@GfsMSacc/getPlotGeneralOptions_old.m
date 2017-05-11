function opt = getPlotGeneralOptions( this )
% GFSMSACC.GETPLOTGENERALOPTIONS (summary)
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

% Copyright 2014-2016 Richard J. Cui. Created: Sun 07/10/2016 12:37:50.974 PM
% $Revision: 0.1 $  $Date: Sun 07/10/2016 12:37:50.974 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

S.Which_Eyes_To_Use = { '{Left}|Right' };

% Correlation options
S.Correlation_Smoothing_Window_Width    = { 151 '* (ms)' [1 10000] };
S.Correlation_Type_of_Data              = { {'{Raw}', '% increase', 'Z-scores'} };
S.Type_of_error                         = { {'{None}','Lines','Shadow'} };
S.Plot_Peak_Interval                    = {{'{0}' '1'}};
S.Plot_Reaction_Time                    = {{'{0}' '1'}};
S.Correlation_X_limit                   = [-4000,2000];

S.Trial_Categories = CorrGui.filter_conditions('get_plot_options', class(this));
S.Microsaccade_Categories = this.get_usacc_properties( 'get_categories' );
S.Saccade_Categories = CorrGui.get_saccade_properties( 'get_categories' );
S.Drift_Categories  = CorrGui.get_drift_properties( 'get_categories' );

S.Plot_Grouping = { {'{subj-trial-data}', 'trial-subj-data', 'data-trial-subj',  'data-subj-trial',  'trial-data-subj' 'trial-subj,data'   'data-trial,subj' 'data-subj,trial'}};

S.Save_Plot         = {{'{0}' '1'}};
S.Saved_Plot_Name   = '';

opt =S;

end % function getPlotGeneralOptions

% [EOF]

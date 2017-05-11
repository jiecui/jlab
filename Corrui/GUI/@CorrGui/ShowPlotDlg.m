function opt = ShowPlotDlg( curr_exp )
% CORRGUI.SHOWPLOTDLG show the dialog for choosing plot options
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Thu 11/03/2016  3:11:22.653 PM
% $Revision: 0.1 $  $Date: Thu 11/03/2016  3:11:22.666 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.cui@utoronto.ca

curr_exp = CorrGui.CheckTag( curr_exp ); % in case curr_exp is a tag

% get the plot options for the dialog
opt = CorrGui.GetPlotOptions( curr_exp );

% select the most used plots and leave the others in other_plots
[opt1, opt2] = CorrGui.SelectFrequentPlots( curr_exp, opt);
opt = opt1;
if ~isempty( opt2 )
    opt.OTHER_PLOTS = opt2;
end

% get the options used the last time
lastOptions = getpref('corrui', 'plot_options' , []);
lastOptions.Save_Plot = 0;
lastOptions.Saved_Plot_Name = '';


% show struct dialog to the user
opt = StructDlg( opt, 'Select Plots to Make', lastOptions, CorrGui.get_default_dlg_pos() );
if isempty(opt)
    return
end

% save the options used now for the next time
setpref( 'corrui', 'plot_options', opt );

% add the OTHER PLOTS to the normal plots structure
if ( isfield( opt, 'OTHER_PLOTS' ) )
    opt = mergestructs(opt, opt.OTHER_PLOTS);
    opt = rmfield(opt, 'OTHER_PLOTS');
end

% update the counts of most used plots
CorrGui.UpdateFrequentPlots( curr_exp, opt );

% if ( ~isfield(opt,'Which_Eyes_To_Use'))
%     opt.Which_Eyes_To_Use = 'Unique';
% end

end % function ShowPlotDlg

% [EOF]

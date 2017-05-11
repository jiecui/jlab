function result_dat = Scroll_Plot(current_tag, sname, S)
% MSACCCONTRASTPLOTS.SCROLL_PLOT eye movement explorer for MSaccContrast exp
%
% Syntax:
%   result_dat = Scroll_Plot(current_tag, sname, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Tue 12/06/2016  5:22:14.758 PM
% $ Revision: 0.2 $  $ Date: Thu 12/08/2016 10:02:43.246 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    % options.Envelope = { {'{0}','1'} };
    
    % get general options
    gen_opt = EyeMovementExpPlots.Scroll_Plot(current_tag);
    
    % get experiment-specific options
    
    result_dat = gen_opt;
    return
end % if

% =========================================================================
% Get options and parameters
% =========================================================================


% =========================================================================
% Get data
% =========================================================================


% =========================================================================
% Plot
% =========================================================================
% Scroll_Plot returns figure handles
result_dat = Scroll_Plot@EyeMovementExpPlots(current_tag, sname, S); 

% additional plots for MSC experiments
% ------------------------------------
% msc_scroll_up(result_dat, S)

end % function Scroll_Plot

% =========================================================================
% Subroutines
% =========================================================================
% function msc_scroll_up(figs, S)
% % add additional plots in scroll up for msc experiment
% 
% end % function

% [EOF]

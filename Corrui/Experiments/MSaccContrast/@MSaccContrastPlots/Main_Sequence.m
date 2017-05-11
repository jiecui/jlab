function result_dat = Main_Sequence(current_tag, sname, S)
% MSACCCONTRASTPLOTS.MAIN_SEQUENCE plots main sequence for MSC experiment
%
% Syntax:
%   result_dat = Main_Sequence(current_tag, sname, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 09/02/2016  1:31:23.629 PM
% $ Revision: 0.2 $  $ Date: Fri 09/09/2016  3:29:59.898 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag, 'get_options')
	% opt.example = {2, 'AR order', [1 Inf]};
    
    % get general options
    gen_opt = EyeMovementExpPlots.Main_Sequence(current_tag);
    
    % get experiment-specific options
    
    result_dat = gen_opt;
	return
end % if

% =========================================================================
% Get options and parameters
% =========================================================================
% example = S.([mfilename, '_options']).example;

% =========================================================================
% Get data
% =========================================================================
% dat_var = { 'example_dat' }
% dat = CorruiDB.Getsessvars(sname, dat_var);
% example_dat = dat.example_dat

% =========================================================================
% Plot
% =========================================================================
result_dat = Main_Sequence@EyeMovementExpPlots(current_tag, sname, S);

% additional plots for MSC experiments
% ------------------------------------
msc_main_seq(result_dat, S)

end % function Main_Sequence

% =========================================================================
% Subroutines
% =========================================================================
function msc_main_seq(figs, S)
% add additional plots in main sequence for msc experiment

opts = S.(sprintf('%s_options', mfilename));

% magnitude ceritarion between micro-/macro-saccade
% -------------------------------------------------
mag_criterion = 2; % in dva
nfig = numel(figs);
for k = 1:nfig
    hax_k = figs(k).haxes;
    set(hax_k, 'NextPlot', 'Add')
    if strcmpi(opts.x_var, 'Magnitude')
        plot(hax_k, [1 1] * mag_criterion, ylim, 'Color', [1 .84, 0],'LineStyle', '-.', 'LineWidth', 2)
    elseif strcmpi(opts.y_var, 'Magnitude')
        plot(hax_k, xlim, [1 1] * mag_criterion, 'Color', [1 .84, 0],'LineStyle', '-.', 'LineWidth', 2)
    end % if
end % for

end % function

% [EOF]

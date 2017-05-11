function result_dat = Scroll_Plot(current_tag, sname, S)
% GFSMSACCPLOTS.SCROLL_PLOT eye movement explorer for GfsMsacc exp
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

% Copyright 2016 Richard J. Cui. Created: Thu 08/11/2016  2:49:34.252 PM
% $ Revision: 0.4 $  $ Date: Mon 11/28/2016  9:54:36.273 PM $
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
    
    options = [];
    result_dat = options;
    return
end % if

% =========================================================================
% Get options and parameters
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
this = curr_exp.plotClass; % GfsMSaccPlots objects
this.curr_exp = curr_exp;

if isfield(S, sprintf('%s_options', mfilename))
    this.Options = S.([mfilename, '_options']);
else
    this.Options = [];
end % if

Trial_Categories = S.Trial_Categories;

% =========================================================================
% Get data
% =========================================================================
switch S.Which_Eyes_To_Use
    case 'Left'
        dat_var = {'left_eyedat', 'left_eyeflags', 'samplerate'};        
    case 'Right'
        dat_var = {'right_eyedat', 'right_eyeflags', 'samplerate'};
    case 'Both'
        dat_var = {'left_eyedat', 'right_eyedat', 'left_eyeflags', 'right_eyeflags', 'samplerate'};
end % switch

% =========================================================================
% Plot
% =========================================================================
% check filter of trials
% ----------------------
filter_names = fieldnames(Trial_Categories);
num_filters = numel(filter_names);
f = false(1, num_filters);
for k = 1:num_filters
    f(k) = Trial_Categories.(filter_names{k});
end
if sum(f) == 0
    filter = 'All';
    
elseif sum(f) == 1
    filter = filter_names{find(f > 0, 1)};
    
elseif sum(f) > 1
    filter = filter_names{find(f > 0, 1)};
    cprintf('SystemCommands',...
        'Warning: Can only plot one type of trial category at a time. Will use the first selected one - %s.\n', filter)
end

% show plot
% ---------
[hshow, hplot] = gms_show_plots(this, curr_exp, sname, dat_var, filter,...
    @this.prep_scrollup_data, @this.show_scrollup, @this.update_scrollup_data);
if isempty(hplot)
    delete(hshow)
end % if

end % function Scroll_Plot

% =========================================================================
% Subroutines
% =========================================================================

% [EOF]

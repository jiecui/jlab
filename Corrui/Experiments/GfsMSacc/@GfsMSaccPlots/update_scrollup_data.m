function update_scrollup_data(this, fig_object, eventdata, fig_handles, cond_str, trl_str)
% GFSMSACCPLOTS.UPDATE_PLOT_DATA (summary)
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

% Copyright 2016 Richard J. Cui. Created: Fri 08/12/2016  4:23:57.702 PM
% $Revision: 0.1 $  $Date: Wed 08/17/2016  1:02:07.825 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

sname = fig_handles.sname;
dat_var = fig_handles.dat_var;
filter = fig_handles.filter;

h_explorer = fig_handles.hplot.Explorer;
expl_handles = guidata(h_explorer);

scrollup_dat = this.prep_scrollup_data(sname, dat_var, cond_str, trl_str, filter);
if ~isempty(scrollup_dat)
    % update data info
    info = sprintf('Condition: %s, Trial: %s', cond_str, trl_str);
    % expl_handles.text.info.String = info;
    microsaccade_explorer('update_textinfo', expl_handles, info)

    % data = convt2expl(scrollup_dat);
    expl_dat = this.scrollup2expl_data(scrollup_dat);
    
    % update Eyemovement Explorer
    expl_handles = microsaccade_explorer('input_plotdat', expl_handles, expl_dat{:});
    guidata(h_explorer, expl_handles);    
end % if

end % function update_plot_data

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

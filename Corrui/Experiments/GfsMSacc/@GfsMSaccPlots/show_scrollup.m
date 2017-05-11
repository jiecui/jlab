function f = show_scrollup(this, curr_exp, sname, plotdat)
% GFSMSACCPLOTS.show_scrollup show the scroll up plot
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

% Copyright 2016 Richard J. Cui. Created: Fri 08/12/2016 12:50:48.509 PM
% $Revision: 0.4 $  $Date: Thu 09/01/2016  4:27:56.786 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

em_plots = EyeMovementPlots;
f = em_plots.eye_movement_explorer(plotdat);
if isempty(f)
    return
end % if

% ----------------------
% Explorer option window
% ----------------------
namestr = f.Explorer.Name;
new_name = sprintf('%s -- %s - %s', namestr, curr_exp.name, curr_exp.SessName2UserSessName(sname));
f.Explorer.Name = new_name;

% -----------------
% Scroll up window
% -----------------
% figure title
figure(f.Scrollup) % f - scroll plot handle
fig_title = sprintf('Scroll Plot -- %s - %s', curr_exp.name, curr_exp.SessName2UserSessName(sname));
set(f.Scrollup, 'Name', fig_title, 'NumberTitle', 'off')

% add fixation target in the x-y position
expl_handles = guidata(f.Explorer);
ax_xy = expl_handles.fig.axxy;
htag = DrawCircle(ax_xy, 0, 0, .15/2, 100, 'Color', 'y', 'LineWidth', 2);
uistack(htag, 'bottom') % move target to the botom

% add fixation circle in the x-y position
hfixwin = DrawCircle(ax_xy, 0, 0, .6, 100,...
    'Color', [1, 0, 0],...
    'LineWidth', 1,...
    'LineStyle', ':');
uistack(hfixwin, 'bottom')

% add target circle in the x-y position
gms_trl = GMSTrial(curr_exp, sname);
if ~isempty(gms_trl.TargetPos)
    tpos = gms_trl.TargetPos;
    hfix = DrawCircle(ax_xy, tpos.x, tpos.y, 1/2, 100, 'Color', 'r', 'LineWidth', 2);
    uistack(hfix, 'bottom')
end % if

% add plot target onset label
expl_handles = guidata(f.Explorer);
expl_handles.PlotResv1.String = 'Plot Target On';
expl_handles.PlotResv2.String = 'Plot Surround On';
expl_handles.PlotResv3.String = 'Plot Level Release';

end % function plot_scrollup

% [EOF]

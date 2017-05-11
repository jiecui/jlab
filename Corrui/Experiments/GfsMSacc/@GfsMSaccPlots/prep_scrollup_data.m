function plotdat = prep_scrollup_data(this, sname, dat_var, cond_str, trl_str, filter)
% GFSMSACCPLOTS.PREP_SCROLLUP_DATA prepare data for scroll up plot
%
% Syntax:
%
% Input(s):
%   cond_str    - condition name (1: subjdisp, 2: subjnodisp, 3:
%                 physdisp)
%   trl_str    - trial name
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

% Copyright 2016 Richard J. Cui. Created: Fri 08/12/2016 11:12:33.294 AM
% $Revision: 0.2 $  $Date: Thu 09/01/2016  4:27:56.786 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Get options and parameters
% =========================================================================
% S = this.Options;

% Envelope        = S.Envelope;
% Drift           = S.Drift;
% Drift_Speed     = S.Drift_Speed;

% =========================================================================
% Prepare data
% =========================================================================
% get condition and trial number
% ------------------------------
switch cond_str
    case 'SubjDisp'
        ncond = 1;
    case 'SubjNoDisp'
        ncond = 2;
    otherwise
        cprintf('SystemCommands',...
            'Condition %s isn''t applied to Scroll Up plot.\n', cond_str) % msgbox
        plotdat = [];
        return
end % switch

switch trl_str
    case 'All'
        cprintf('SystemCommands',...
            'Condition %s isn''t applied to Scroll Up plot.\n', trl_str) % msgbox
        plotdat = [];
        return
    otherwise
        ntrial = str2double(trl_str);
end % switch

% basic data
% ----------
dat = CorruiDB.Getsessvars(sname, dat_var);

vars = {'left_eyedat', 'right_eyedat', 'left_eyeflags', 'right_eyeflags'};
num_vars = numel(vars);
for k = 1:num_vars
    if ~isfield(dat, vars{k})
        dat.(vars{k}) = table;
    end % if
end % for

left_eyedat     = dat.left_eyedat;
right_eyedat    = dat.right_eyedat;
left_eyeflags   = dat.left_eyeflags;
right_eyeflags  = dat.right_eyeflags;

plotdat.samplerate      = dat.samplerate;
if ~isempty(left_eyedat)
    dat_idx = left_eyedat.Trial == ntrial & left_eyedat.Condition == ncond;
elseif ~isempty(right_eyedat)
    dat_idx = right_eyedat.Trial == ntrial & right_eyedat.Condition == ncond;
else
    cprintf('SystemCommands', 'No eye data available.\n')
    plotdat = [];
    return
end % if

if isempty(left_eyedat)
    plotdat.left_eyedat     = [];
else
    plotdat.left_eyedat     = left_eyedat{dat_idx, {'X', 'Y'}};
end % if
if isempty(right_eyedat)
    plotdat.right_eyedat    = [];
else
    plotdat.right_eyedat    = right_eyedat{dat_idx, {'X', 'Y'}};
end % if
if isempty(left_eyeflags)
    plotdat.left_eyeflags    = [];
else
    plotdat.left_eyeflags    = logical(left_eyeflags{dat_idx, :});
end % if
if isempty(right_eyeflags)
    plotdat.right_eyeflags    = [];
else
    plotdat.right_eyeflags    = logical(right_eyeflags{dat_idx, :});
end % if

% -------------
% optional data
% -------------
gms_trl = GMSTrial(this.curr_exp, sname);
sig_len = gms_trl.TrialLength;

% resv1 - target onset indicator
tag_onset = gms_trl.TargetOnset;
tag_yn = false(sig_len, 1);
tag_yn((1:sig_len) >= tag_onset) = true;
plotdat.resv1 = tag_yn;

% resv2 - surround onset indicator
sur_onset = tag_onset + gms_trl.SurroundOnset;
sur_yn = false(sig_len, 1);
sur_yn((1:sig_len) >= sur_onset) = true;
plotdat.resv2 = sur_yn;

% resv3 - level release indicator
if ncond == 1
    rel_lat = sur_onset + gms_trl.RelLatShort(ntrial);
    rl_yn = false(sig_len, 1);
    rl_yn((1:sig_len) >= rel_lat) = true;
    plotdat.resv3 = rl_yn;
else
    plotdat.resv3 = [];
end % switch

% -------------
% trial filter
% -------------
if ~strcmp('All', filter) % filter = 'All' for now
    % isInTrialFilter = make_isInTrialFilter(plotdat.isInTrialCond,plotdat.enum,sname,current_tag,k);
    % plotdat = change_data_domain(plotdat,isInTrialFilter);
end

end % function prep_scrollup_data

% =========================================================================
% Subroutines
% =========================================================================

% [EOF]

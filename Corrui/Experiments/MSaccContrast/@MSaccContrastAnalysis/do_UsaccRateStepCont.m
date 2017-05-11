function result_dat = do_UsaccRateStepCont(current_tag, name, S, dat)
% DO_USACCRATESTEPCONT MS rate of cell in response to step-contrast change
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

% Copyright 2014 Richard J. Cui. Created: 10/26/2012 10:47:19.522 AM
% $Revision: 0.2 $  $Date: Fri 03/07/2014  5:16:01.434 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%% ========================================================================
% Options of analysis
% =========================================================================
if strcmpi(current_tag,'get_options')
    opt.Window_width = {100 '* ms' [1 1000]};
    opt.Window_step = {10 '* ms' [1 1000]};
    result_dat = opt;
    return
end % if

%% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'NumberCycle' 'UsaccXCondLength'...
                'Left_UsaccXCond12_Start' 'Left_UsaccXCond12_end' ...
                'Left_UsaccXCond23_Start' 'Left_UsaccXCond23_end'};
    result_dat = dat_var;
    return
end % if

%% ========================================================================
% get the data
% =========================================================================
win_wid     = S.Stage_2_Options.([mfilename '_options']).Window_width;
win_step    = S.Stage_2_Options.([mfilename '_options']).Window_step;

ncycle      = dat.NumberCycle;
len         = dat.UsaccXCondLength;
usatime12_s = dat.Left_UsaccXCond12_Start;
usatime12_e = dat.Left_UsaccXCond12_end;
usatime23_s = dat.Left_UsaccXCond23_Start;
usatime23_e = dat.Left_UsaccXCond23_end;

%% ========================================================================
% The analysis
% =========================================================================
% stage 1 --> stage 2
[wc12_s, fr12_s, fr12_mean_s, fr12_sem_s] = getUsaccRate(usatime12_s, ncycle, len, win_wid, win_step);
[~, fr12_e, fr12_mean_e, fr12_sem_e] = getUsaccRate(usatime12_e, ncycle, len, win_wid, win_step);

% stage 2 --> stage 3
[wc23_s, fr23_s, fr23_mean_s, fr23_sem_s] = getUsaccRate(usatime23_s, ncycle, len, win_wid, win_step);
[~, fr23_e, fr23_mean_e, fr23_sem_e] = getUsaccRate(usatime23_e, ncycle, len, win_wid, win_step);

%% ========================================================================
% Commit
% =========================================================================
result_dat.Left_UXCond12RateCenter = wc12_s;
result_dat.Left_UXCond12OnsetRate  = fr12_s;
result_dat.Left_UXCond12OnsetRateMean   = fr12_mean_s;
result_dat.Left_UXCond12OnsetRateSEM    = fr12_sem_s;

result_dat.Left_UXCond12OffsetRate      = fr12_e;
result_dat.Left_UXCond12OffsetRateMean  = fr12_mean_e;
result_dat.Left_UXCond12OffsetRateSEM   = fr12_sem_e;

result_dat.Left_UXCond23RateCenter = wc23_s;
result_dat.Left_UXCond23OnsetRate  = fr23_s;
result_dat.Left_UXCond23OnsetRateMean   = fr23_mean_s;
result_dat.Left_UXCond23OnsetRateSEM    = fr23_sem_s;

result_dat.Left_UXCond23OffsetRate      = fr23_e;
result_dat.Left_UXCond23OffsetRateMean  = fr23_mean_e;
result_dat.Left_UXCond23OffsetRateSEM   = fr23_sem_e;

end % function FiringXContrastCondition

%% ========================================================================
% subroutines
% =========================================================================
function [wc, fr, fr_mean, fr_sem] = getUsaccRate(usatime, ncycle, trl_len, win_wid, win_step)

N = length(usatime);
fr = [];
fr_mean = [];
fr_sem = [];
for k = 1:N
    spk_k = usatime{k};
    [wc, fr_k, fr_mean_k, fr_sem_k] ...
        = SpikeProcess.SpikeRateEstimation.PSTHEst(spk_k, ncycle, trl_len, win_wid, win_step);
    
    fr = cat(3, fr, fr_k);
    fr_mean = cat(3, fr_mean, fr_mean_k);
    fr_sem = cat(3, fr_sem, fr_sem_k);
end % for

end 
% [EOF]

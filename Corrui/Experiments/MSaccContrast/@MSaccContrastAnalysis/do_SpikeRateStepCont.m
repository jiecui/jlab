function result_dat = do_SpikeRateStepCont(current_tag, name, S, dat)
% DO_SPIKERATESTEPCONT Spike rate of a cell in response to step-contrast change
% 
% Description:
%   This function calculates the spike rates of the cell in response to the
%   step-contrast change.  The spike times are obtained using function
%   do_FiringXContrastCondition.
%
% Syntax:
%   result_dat = do_SpikeRateStepCont(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also do_FiringXContrastCondition.

% Copyright 2013 Richard J. Cui. Created: 10/26/2012 10:47:19.522 AM
% $Revision: 0.2 $  $Date: Thu 01/03/2013  3:29:00.765 PM AM $
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
    opt.Window_width = {50 '* ms' [1 1000]};
    opt.Window_step = {5 '* ms' [1 1000]};
    opt.Norm_window_width = {300 '* ms' [1 1000]};  % time length before 1st contrast onset
    result_dat = opt;
    return
end % if

%% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'NumberCycle' 'FiringXCondLength'...
                'FiringXCond12' 'FiringXCond23'};
    result_dat = dat_var;
    return
end % if

%% ========================================================================
% get the data
% =========================================================================
win_wid = S.Stage_2_Options.do_SpikeRateStepCont_options.Window_width;
win_step = S.Stage_2_Options.do_SpikeRateStepCont_options.Window_step;
nrm_wid = S.Stage_2_Options.do_SpikeRateStepCont_options.Norm_window_width;

ncycle      = dat.NumberCycle;
trl_len     = dat.FiringXCondLength;
spktime12   = dat.FiringXCond12;
spktime23   = dat.FiringXCond23;

%% ========================================================================
% The analysis
% =========================================================================
% stage 1 --> stage 2
[wc12, fr12, fr12_mean, fr12_sem] = getFiringRate(spktime12, ncycle, trl_len, win_wid, win_step);
[fr12_nm, fr12_mean_nm, fr12_sem_nm] = normalizeFiringRate(wc12, fr12, trl_len, fr12, nrm_wid);
% stage 2 --> stage 3
[wc23, fr23, fr23_mean, fr23_sem] = getFiringRate(spktime23, ncycle, trl_len, win_wid, win_step);
[fr23_nm, fr23_mean_nm, fr23_sem_nm] = normalizeFiringRate(wc23, fr23, trl_len, fr12, nrm_wid);

%% ========================================================================
% Commit
% =========================================================================
result_dat.FXCond12RateCenter = wc12;
result_dat.FXCond12Rate       = fr12;
result_dat.FXCond12RateMean   = fr12_mean;
result_dat.FXCond12RateSEM    = fr12_sem;
result_dat.FXCond12Rate_Norm  = fr12_nm;
result_dat.FXCond12RateMean_Norm   = fr12_mean_nm;
result_dat.FXCond12RateSEM_Norm    = fr12_sem_nm;

result_dat.FXCond23RateCenter = wc23;
result_dat.FXCond23Rate       = fr23;
result_dat.FXCond23RateMean   = fr23_mean;
result_dat.FXCond23RateSEM    = fr23_sem;
result_dat.FXCond23Rate_Norm  = fr23_nm;
result_dat.FXCond23RateMean_Norm   = fr23_mean_nm;
result_dat.FXCond23RateSEM_Norm    = fr23_sem_nm;

end % function FiringXContrastCondition

%% ========================================================================
% subroutines
% =========================================================================
function [wc, fr, fr_mean, fr_sem] = getFiringRate(spktime, ncycle, trl_len, win_wid, win_step)

N = length(spktime);
fr = [];
fr_mean = [];
fr_sem = [];
for k = 1:N
    spk_k = spktime{k};
    [wc, fr_k, fr_mean_k, fr_sem_k] ...
        = SpikeProcess.SpikeRateEstimation.PSTHEst(spk_k, ncycle, trl_len, win_wid, win_step);
    
    fr = cat(3, fr, fr_k);
    fr_mean = cat(3, fr_mean, fr_mean_k);
    fr_sem = cat(3, fr_sem, fr_sem_k);
end % for

end

function [fr_nm, fr_mean_nm, fr_sem_nm] = normalizeFiringRate(wc, fr, trl_len, fr12, nrm_wid)
% get normalized firing rate
%  fr12     - firing rate from stage 1 (0% contrast) to stage 2 (1st
%             contrst)

% get baseline
cont_ontime = round(trl_len / 2) + 1;   % contrast onset time, assume at middle
idx = wc >= cont_ontime - nrm_wid & wc <= cont_ontime;
blk = fr12(:, idx, :);      
baseline = mean(blk(:));

% fr_nm = zeros(size(fr));
% [M, ~, N] = size(fr);    % number of conditions
% for k = 1:N
%     fr_k = fr(:, :, k);
%     blk_k = fr_k(:, idx);
%     baseline = mean(blk_k(:));
%     fr_nm_k  = (fr_k - baseline) / baseline;
%     fr_nm(:, :, k) = fr_nm_k;
% end % for

fr_nm = (fr - baseline) / baseline;
fr_mean_nm = mean(fr_nm);
fr_sem_nm = std(fr_nm) / sqrt(size(fr, 1));

end 


% [EOF]

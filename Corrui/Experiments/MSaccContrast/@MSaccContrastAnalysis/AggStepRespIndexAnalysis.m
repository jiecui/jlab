function result_dat = AggStepRespIndexAnalysis(current_tag, name, S, dat)
% AGGSTEPRESPINDEXANALYSIS Index of the step response to step changes of contrast (archaic)
%
% Syntax:
%   result_dat = AggStepRespIndexAnalysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Thu 08/16/2012 11:08:34.795 AM
% $Revision: 0.1 $  $Date: Thu 08/16/2012 11:08:34.795 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
%     opt.tfmethod = {'{affine}|lwm'};
%     opt.Latency = {30 '* (ms)' [0 1000]};
%     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
%         % outside the fix grid more than SMThres * STDs will be discarded
%     opt.normalized_spike_map = { {'{0}','1'} };
%     opt.smooth_size = {40 '' [1 100]};
%     opt.smooth_sigma = {10 '' [1 100]};

%     opt.smoothed_image = {{'0','{1}'}};

    % opt = [];
    opt.pre_interval = {300 '* (ms)' [0 2000]};     % time interval before contrast onset for averaging FR
    opt.post_interval = {300 '* (ms)' [0 2000]};    % time interval after contrast onset for averaging FR
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'StepWinCenter', 'StepNoExcludeFr', 'ConEnvVars'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% -------------
all_fr  = dat.StepNoExcludeFr;
winc    = dat.StepWinCenter;
envvar  = dat.ConEnvVars;

% get parameters
% --------------
pre_int = S.Stage_2_Options.AggStepRespIndexAnalysis_options.pre_interval;
pos_int = S.Stage_2_Options.AggStepRespIndexAnalysis_options.post_interval;

% (1) step response index matrix
% ---------------------------------------------------------
grattime = envvar.grattime;
idx_pre = winc < grattime & winc >= (grattime - pre_int);
idx_pos = winc >= grattime & winc <= (grattime + pos_int);

step_resp_index = estStepRespIndex(all_fr, idx_pre, idx_pos);

% (2) Delta percentage index
% -----------------------------
dpi = zeros(21, 3);     % row: delta percentage = 100%, 90%, ..., 10%, 0%, -10%, ..., -90%, -100%
                        % col: 1st = mean, 2nd = std, 3rd = sem
for k = -10:10
    v_k = diag(step_resp_index, k);
    n_k = length(v_k);
    mean_v_k = mean(v_k);
    std_v_k  = std(v_k);
    sem_v_k  = std_v_k / sqrt(n_k);
    
    dpi(k + 11, :) = [mean_v_k, std_v_k, sem_v_k];
end % for

% ======================
% plot check
% ======================
plot_ind_mat(step_resp_index)
plot_dpi(dpi)

% =====================
% commit results
% =====================
result_dat.StepRespIdx  = step_resp_index;      % response index matrix, row = 1st contrast, col = 2nd contrast
result_dat.DeltaPercentageIdx = dpi;

end % function StepContrastAnalysis

% -------------------------
% subroutines
% -------------------------
function residx = estStepRespIndex(step_rep, idx_pre, idx_pos)

% Inputs:
%   step_rep    - contrast step response (see AggStepContrastAnalysis.m)
%   ind_pre     - index of data point before contrast onset
%   ind_pos     - after
% 
% Outputs:
%   residx      - estimated reaponse index maxtrix [11 x 11], col =
%                 start/first contrast, row = end/2nd contrast

numCond = size(step_rep, 2);
D = zeros(numCond, 1);

for k = 1:numCond
    rep_k = step_rep(:, k);     % k-th response
    rep_pre = rep_k(idx_pre);
    rep_pos = rep_k(idx_pos);
    m_pre   = mean(rep_pre);    % mean normalized pre-firing rate
    m_pos   = mean(rep_pos);    % mean normalized post firing rate
    D(k) = m_pos - m_pre;       % simple difference index
end % for

% convert to matrix
residx = reshape(D, 11, 11);

end 

function plot_ind_mat(M)

% M - index matrix, should be a sqaure
maxM = max(M(:));
minM = min(M(:));
yuplim = maxM * (1 + 0.02);
ylwlim = minM * (1 - 0.02);

[nr, nc] = size(M);

figure

for r = 1:nr
    for c = 1:nc
        k = (r - 1) * nr + c;
        subplot(nr, nc, k);
        M_k = M(r, c);
        if r > c    % contrast increase 
            bar(1, M_k, 0.5, 'g');
        elseif r == c   % no change of contrast
            bar(1, M_k, 0.5, 'y');
        else        % contrast decrease
            bar(1, M_k, 0.5, 'r');
        end % if
        ylim([ylwlim, yuplim]);
        set(gca, 'box', 'off')
        set(gca, 'XTickLabel', '')
        set(gca, 'YTickLabel', '')
        xlabel('')
    end % for
end % for

drawnow

end % funciton

function plot_dpi(d)

% d - Delta percentage index,  % row: delta percentage = 100%, 90%, ..., 10%, 0%, -10%, ..., -90%, -100%
                        % col: 1st = mean, 2nd = std, 3rd = sem

% bar                        
figure
dper = 100:-10:-100;
bar(dper, d(:, 1))

xlim([-110, 110])

% error bar
figure
errorbar(dper, d(:, 1), d(:, 3))
hold on
plot([0 0], ylim, 'r')
plot(xlim, [0 0], 'g')
xlim([-110, 110])

drawnow

end % function

% [EOF]

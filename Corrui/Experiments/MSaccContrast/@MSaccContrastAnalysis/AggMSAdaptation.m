function result_dat = AggMSAdaptation(current_tag, name, S, dat)
% AGGMSADAPTATION Impact of MS on contrast response adaptation
% 
% Description:
%
% Syntax:
%   result_dat = AggMSAdaptation(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Thu 01/17/2013  5:21:02.698 PM
% $Revision: 0.1 $  $Date: Thu 01/17/2013  5:21:02.698 PM $
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
% options
% --------
if strcmpi(current_tag,'get_options')
    % Note: 
    % Spike rate - absolute spike rate
    % Spike rate difference - spike rate minus baseline. baseline is the
    %       average spike rate before 1st contrast onset of each cell
    opt.measure_type = {'{Spike rate}|Spike rate difference', 'Measure of neural activity'};
    opt.msnum_range_less = {[0 3] 'Range of MS num for LESS class' [0 20]};
    opt.msnum_range_more = {[5 9] 'Range of MS num for MORE class' [0 20]};
    
    result_dat = opt;
    return
end % if

% load data need for analysis
% ----------------------------
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'FXCond12Rate', 'FXCond12RateCenter', ...
                'FXCond23Rate', 'FXCond23RateCenter', ...
                'NumberCycle', 'SortByMS'};
    
    result_dat = dat_var;
    return
end % if


% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------
measure_type = S.Stage_2_Options.AggMSAdaptation_options.measure_type;
num_less = S.Stage_2_Options.AggMSAdaptation_options.msnum_range_less;
num_more = S.Stage_2_Options.AggMSAdaptation_options.msnum_range_more;

contlevels = 0:10:100;  % level interested

% get the data
% -------------
sr12        = dat.FXCond12Rate;
sr12c       = dat.FXCond12RateCenter;
sr23        = dat.FXCond23Rate;
sr23c       = dat.FXCond23RateCenter;
numcycle    = dat.NumberCycle;
sortopt     = dat.SortByMS;

% ---------------------
% stats of number of MS
% ---------------------
N = length(numcycle);       % number of sessions / cells
M = size(sr23{1}, 3);       % number of conditions

msnum = [];     % num of MS at each trial x conditions
for m = 1:M
    msnum_m = [];   % num of MS at each trial
    for n = 1:N
        msnum_m_n = sortopt{n}.SortedMSNum(:, m);
        msnum_m = cat(1, msnum_m, msnum_m_n);
    end % for
    msnum = cat(2, msnum, msnum_m);
end % for

% ****** figures for checking hist ******
condnum = zeros(1, length(contlevels));
figure('Name', 'Distribution of MS numbers')
for k = 1:length(contlevels)
    cont_k = contlevels(k);
    condnum_k = Cont2Condnum(cont_k, cont_k);    % condition number
    condnum(k) = condnum_k;
    
    msnum_k = msnum(:, condnum_k);
    max_k = max(msnum_k);
    bin_k = 0:max_k;
    nc = hist(msnum_k, bin_k);
    subplot(4, 3, k), bar(bin_k, nc)
    xlim([0 max_k])
    title(sprintf('%d %%', cont_k))
end % for
% total distribution
msnum_interested = msnum(:, condnum);
max_all = max(msnum_interested(:));
bin_all = 0:max_all;
nc = hist(msnum_interested(:), bin_all);
subplot(4, 3, 12), bar(bin_all, nc)
xlim([0 max_all])
title('Distribution of all')

% -----------------------------------
% sorting spike rates by number of MS
% -----------------------------------
% ****** one function of MS number ******
% ALL = {};
% ALL_cell_id = {};
% for m = 1:M
%     all_m = [];
%     all_cell_id_m = [];
%     for n = 1:N
%         sr23_m_n = sr23{n}(:, :, m);    % spike rate of condition m of cell n
%         num_m_n  = sortopt{n}.SortedMSNum(:, m);        % sorted MS number of condition m of cell n
%         trlnum_m_n = sortopt{n}.SortedTrialNum(:, m);   % sorted trial number of condition m of cell n
% 
%         
%     end % for
% end % for

% ****** Two classes ******
[LESS12, LESS23, LESS_cell_id] = sort_one_class(M, N, sortopt, sr23, num_less, sr12, sr12c, measure_type);
[MORE12, MORE23, MORE_cell_id] = sort_one_class(M, N, sortopt, sr23, num_more, sr12, sr12c, measure_type);

% -----------------------------------
% average spike rate
% -----------------------------------
% ****** individual conditions *******
LESS12_cell_mean = get_cell_mean(contlevels, N, LESS_cell_id, LESS12);
MORE12_cell_mean = get_cell_mean(contlevels, N, MORE_cell_id, MORE12);
LESS23_cell_mean = get_cell_mean(contlevels, N, LESS_cell_id, LESS23);
MORE23_cell_mean = get_cell_mean(contlevels, N, MORE_cell_id, MORE23);

% average across cells
% --------------------
[LESS12_mean, LESS12_sem]  = class_average(LESS12_cell_mean);
[MORE12_mean, MORE12_sem]  = class_average(MORE12_cell_mean);
[LESS23_mean, LESS23_sem]  = class_average(LESS23_cell_mean);
[MORE23_mean, MORE23_sem]  = class_average(MORE23_cell_mean);


% ****** figure for checking ******
figure('Name', 'Stage 1 & 2 - MORE / LESS of each condition')
plotopt.flag_fill = true;
plotopt.flag_showerr = true;
color_less = [1 0 0];
color_more = [0 .5 0];
K = length(contlevels);
for k = 1:K
    cont_k = contlevels(k);

    subplot(4, 3, k)
    less_mean_k = LESS12_mean(:, k) * 1000;
    less_sem_k  = LESS12_sem(:, k) * 1000;
    plot_mean_error(gca, sr12c, less_mean_k, less_sem_k, color_less, 1, plotopt)
    hold on
    more_mean_k = MORE12_mean(:, k) * 1000;
    more_sem_k  = MORE12_sem(:, k) * 1000;
    plot_mean_error(gca, sr12c, more_mean_k, more_sem_k, color_more, 1, plotopt)
    title(sprintf('%d %%', cont_k))

end % for

figure('Name', 'Stage 2 & 3 - MORE / LESS of each condition')
plotopt.flag_fill = true;
plotopt.flag_showerr = true;
color_less = [1 0 0];
color_more = [0 .5 0];
K = length(contlevels);
for k = 1:K
    cont_k = contlevels(k);

    subplot(4, 3, k)
    less_mean_k = LESS23_mean(:, k) * 1000;
    less_sem_k  = LESS23_sem(:, k) * 1000;
    plot_mean_error(gca, sr23c, less_mean_k, less_sem_k, color_less, 1, plotopt)
    hold on
    more_mean_k = MORE23_mean(:, k) * 1000;
    more_sem_k  = MORE23_sem(:, k) * 1000;
    plot_mean_error(gca, sr23c, more_mean_k, more_sem_k, color_more, 1, plotopt)
    title(sprintf('%d %%', cont_k))

end % for

% average over conditions
% ------------------------
[LESS12_cross, LESS12_cross_sm] = class_average_over_cond(LESS12_mean);
[MORE12_cross, MORE12_cross_sm] = class_average_over_cond(MORE12_mean);

[LESS23_cross, LESS23_cross_sm] = class_average_over_cond(LESS23_mean);
[MORE23_cross, MORE23_cross_sm] = class_average_over_cond(MORE23_mean);

% ****** figure check ******
h12 = figure('Name', 'Stage 1 & 2 - MORE/LESS cross conditions');
h12_sm = figure('Name', 'Stage 1 & 2 - Smoothed MORE/LESS cross conditions');
for k = 1:K
    cont_k = contlevels(k);
    cont_max = contlevels(K);
    
    figure(h12)
    less_k = LESS12_cross(:, k) * 1000;
    subplot(4, 3, k)
    plot(sr12c, less_k, 'color', [1 0 0])
    hold on
    more_k = MORE12_cross(:, k) * 1000;
    plot(sr12c, more_k, 'color', [0 .5 0])
    axis tight
    % ylim('auto')
    title(sprintf('%d%% --> %d%%', cont_k, cont_max))

    figure(h12_sm)
    less_k = LESS12_cross_sm(:, k) * 1000;
    subplot(4, 3, k)
    plot(sr12c, less_k, 'color', [1 0 0])
    hold on
    more_k = MORE12_cross_sm(:, k) * 1000;
    plot(sr12c, more_k, 'color', [0 .5 0])
    axis tight
    % ylim('auto')
    title(sprintf('%d%% --> %d%%', cont_k, cont_max))
end % for

h23 = figure('Name', 'Stage 2 & 3 - MORE/LESS cross conditions');
h23_sm = figure('Name', 'Stage 2 & 3 - MORE/LESS cross conditions');
for k = 1:K
    cont_k = contlevels(k);
    cont_max = contlevels(K);
    
    figure(h23)
    less_k = LESS23_cross(:, k) * 1000;
    subplot(4, 3, k)
    plot(sr23c, less_k, 'color', [1 0 0])
    hold on
    more_k = MORE23_cross(:, k) * 1000;
    plot(sr23c, more_k, 'color', [0 .5 0])
    axis tight
    % ylim('auto')
    title(sprintf('%d%% --> %d%%', cont_k, cont_max))

    figure(h23_sm)
    less_k = LESS23_cross_sm(:, k) * 1000;
    subplot(4, 3, k)
    plot(sr23c, less_k, 'color', [1 0 0])
    hold on
    more_k = MORE23_cross_sm(:, k) * 1000;
    plot(sr23c, more_k, 'color', [0 .5 0])
    axis tight
    % ylim('auto')
    title(sprintf('%d%% --> %d%%', cont_k, cont_max))

end % for

% now fit 90% + 100%
% ------------------
less_all = [LESS12_cross(:, 10); LESS23_cross(sr23c >= 1300, 10)] * 1000;
more_all = [MORE12_cross(:, 10); MORE23_cross(sr23c >= 1300, 10)] * 1000;
t_all = linspace(25, 3900-25, length(less_all));
t = t_all - 1300;
[~, max_less_idx] = max(less_all);
max_less_t = t(max_less_idx);
[~, max_more_idx] = max(more_all);
max_more_t = t(max_more_idx);

less_base = less_all(t >= -150 & t <= max_less_t);
more_base = more_all(t >= -150 & t <= max_more_t);

mean_less_base = mean(less_base);
mean_more_base = mean(more_base);

t_less_adp = t(max_less_idx:end)';
t_more_adp = t(max_more_idx:end)';

less_adp = less_all(max_less_idx:end);
more_adp = more_all(max_more_idx:end);

% fit_less_adp = fit(t_less_adp, less_adp - mean_less_base, 'exp2');
% fit_more_adp = fit(t_more_adp, more_adp - mean_more_base, 'exp2');
fit_less_adp = fit(t_less_adp, less_adp, 'exp2');
fit_more_adp = fit(t_more_adp, more_adp, 'exp2');

figure
plot(t, less_all, 'r.')
hold on
plot(fit_less_adp, t_less_adp, less_adp, 'r')
plot(t, more_all, 'g.')
plot(fit_more_adp, t_more_adp, more_adp, 'g')

% =========================================================================
% commit results
% =========================================================================
result_dat.InterestedCondition = contlevels;
result_dat.MSNum = msnum;       % MS numbers per trial x per condition
result_dat.LESSClass.Mean = LESS23_mean;  % LESS class mean at each interested condition
result_dat.LESSClass.SEM  = LESS23_sem;
result_dat.LESSClass.Cross.Mean12 = LESS12_cross;
result_dat.LESSClass.Cross.SEM12 = LESS12_cross_sm;
result_dat.LESSClass.Cross.Mean23 = LESS23_cross;
result_dat.LESSClass.Cross.SEM23 = LESS23_cross_sm;

result_dat.MOREClass.Mean = MORE23_mean;  % LESS class mean at each interested condition
result_dat.MOREClass.SEM  = MORE23_sem;
result_dat.MOREClass.Cross.Mean12 = MORE12_cross;
result_dat.MOREClass.Cross.SEM12 = MORE12_cross_sm;
result_dat.MOREClass.Cross.Mean23 = MORE23_cross;
result_dat.MOREClass.Cross.SEM23 = MORE23_cross_sm;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [SPKR12, SPKR23, cell_id] = sort_one_class(numcond, numcell, sortopt, sr23,...
    num_range, sr12, sr12c, measure_type)
% Note: cell sorting according to MS # in stage 2 and 3

SPKR12 = {};          % spike rate for stage 1 & 2
SPKR23 = {};          % spike rate 
cell_id = {};         % cell ID
for m = 1:numcond     % condition by condition
    spkr12_m = [];
    spkr23_m = [];
    cell_id_m = [];
    for n = 1:numcell   % cell by cell
        sr12_m_n = sr12{n}(:, :, m);
        sr23_m_n = sr23{n}(:, :, m);    % spike rate of condition m of cell n
        num_m_n  = sortopt{n}.SortedMSNum(:, m);        % sorted MS number of condition m of cell n
        trlnum_m_n = sortopt{n}.SortedTrialNum(:, m);   % sorted trial number of condition m of cell n
        
        num_idx = num_m_n >= num_range(1) & num_m_n <= num_range(2);
        if sum(num_idx) > 0
            % save cell ID
            cell_id_m_n = n * ones(sum(num_idx), 1);
            cell_id_m = cat(1, cell_id_m, cell_id_m_n);
            % sort spike rate
            trl_idx = trlnum_m_n(num_idx);
            switch measure_type
                case 'Spike rate'
                    spkr12_m_n = sr12_m_n(trl_idx, :);
                    spkr23_m_n = sr23_m_n(trl_idx, :);
                case 'Spike rate difference'
                    base_idx = sr12c >= 1000 & sr12c <= 1300;
                    base_rate = mean(mean(sr12_m_n(:, base_idx), 2));
                    spkr12_m_n = sr12_m_n(trl_idx, :) - base_rate;
                    spkr23_m_n = sr23_m_n(trl_idx, :) - base_rate;
            end % switch
            spkr12_m = cat(1, spkr12_m, spkr12_m_n);
            spkr23_m = cat(1, spkr23_m, spkr23_m_n);
        end % if
    end % for
    cell_id = cat(2, cell_id, cell_id_m);
    SPKR12 = cat(2, SPKR12, spkr12_m);
    SPKR23 = cat(2, SPKR23, spkr23_m);
end % for

end 

function [cell_mean, cell_numtrial] = get_cell_mean(contlevels, numcell, cell_id, sorted_spk)
% cell_mean     - mean of cells for each interested condition
% cell_numtrial - the number of trials involved

K = length(contlevels);     % number of interested conditions
cell_mean = {};             % mean of each cell per interested condition
cell_numtrial = {};         % number of trials for each condition

for k = 1:K     % interested condition by condition
    cont_k = contlevels(k);
    condnum = Cont2Condnum(cont_k, cont_k);
    
    cell_mean_k = [];
    cell_numtrial_k = [];
    for n = 1:numcell % cell by cell
        % LESS signal
        cell_id_k = cell_id{condnum};
        cell_id_k_n = cell_id_k == n;
        if sum(cell_id_k_n) > 0
            sorted_k_n = sorted_spk{condnum}(cell_id_k_n, :);
            sorted_k_n_mean = mean(sorted_k_n, 1);
            numtrial_k_n = size(sorted_k_n, 1);
            
            cell_numtrial_k = cat(1, cell_numtrial_k, numtrial_k_n);
            cell_mean_k = cat(1, cell_mean_k, sorted_k_n_mean);
        end % if
    end % for
    cell_mean = cat(2, cell_mean, cell_mean_k);
    cell_numtrial = cat(2, cell_numtrial, cell_numtrial_k);
    
end % for

end % function

function [class_mean, class_sem] = class_average(class_sig)
% per each condtion

class_mean = [];
class_sem  = [];

K = length(class_sig);  % number of interested conditons
for k = 1:K
    sig_k = class_sig{k};
    N = size(sig_k, 1);     % number of cells included
    
    class_mean_k = mean(sig_k, 1)';
    class_sem_k = std(sig_k, [], 1)' / sqrt(N);
    
    class_mean = cat(2, class_mean, class_mean_k);
    class_sem  = cat(2, class_sem, class_sem_k);
end % for

end % funciton

function [sig_mean, smoothed_sig_mean] = class_average_over_cond(class_mean)
% cross over conditions

sig_mean = [];
smoothed_sig_mean = [];

K = size(class_mean, 2);  % number of interested conditons
for k = 1:K         % condition by condition
    p = k:K;        % combine conds
    class_p = class_mean(:, p);
    sig_mean_k = mean(class_p, 2);
    sm_sig_mean_k = smooth(sig_mean_k, 101);
    
    smoothed_sig_mean = cat(2, smoothed_sig_mean, sm_sig_mean_k);
    sig_mean = cat(2, sig_mean, sig_mean_k);
end % for

end % for

% [EOF]

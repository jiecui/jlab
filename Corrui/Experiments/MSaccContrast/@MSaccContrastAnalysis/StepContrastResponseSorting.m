function result_dat = StepContrastResponseSorting(current_tag, name, S, dat)
% STEPCONTRASTRESPONSESORTING Sorting trials of step-contrast response
%
% Description:
%       Sorting the trials of step response according to specified
%       criteria.
%
% Syntax:
%   result_dat = StepContrastResponseSorting(current_tag, name, S, dat)
%
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Mon 06/18/2012  5:23:49.112 PM
% $Revision: 0.5 $  $Date: Thu 01/17/2013 11:26:17.270 AM $
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
    % sorting by spikes
    % ------------------
    opt.flag_sort_by_spike = { {'{0}','1'}, 'Sorting by spikes' };
    opt.Sort_by_spikes_options.measure = {'{Spike rate}|Burst size', 'Measure type'};   % sorting by using estimated spike rate or size of spike burst
    opt.Sort_by_spikes_options.stage_included = { '1 & 2|{2 & 3}', 'Stage included'};
    opt.Sort_by_spikes_options.response_measure_interval = {200 '* (ms)' [1 1300]};
    opt.Sort_by_spikes_options.contrast_onset = {1300 '* (ms)' [1 1300]};
    
    % sorting by ms (microsaccades)
    % -----------------------------
    opt.flag_sort_by_ms = { {'0','{1}'}, 'Sorting by microsaccades' };
    opt.Sort_by_MS_options.measure = { 'MS numbers', 'Measure type' };
    opt.Sort_by_MS_options.stage_included = { '2 & 3', 'Stage included' };
    opt.Sort_by_MS_options.measure_interval = {[300 2300] 'Interval of measure (ms)' [1 3900]};   % the interval for calculating the measure; time relative to the start of the 1st stage included
    
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'FiringXCondRaster12', 'FiringXCondRaster23', ...
                'Left_UsaccXCond23_Start', 'NumberCycle', 'grattime'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% sort options
% ------------
flag_sort_by_spike = S.Stage_2_Options.StepContrastResponseSorting_options.flag_sort_by_spike;
flag_sort_by_ms = S.Stage_2_Options.StepContrastResponseSorting_options.flag_sort_by_ms;

% ++++++++++++++++++++++
% sort by spikes
% ++++++++++++++++++++++
if flag_sort_by_spike
    % -----------------
    % get the options
    % -----------------
    sort_measure = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_spikes_options.measure;
    stage_selected = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_spikes_options.stage_included;
    intv = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_spikes_options.response_measure_interval;
    cont_onset = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_spikes_options.contrast_onset;
    
    options.SortMeasure     = sort_measure;
    options.StageIncluded   = stage_selected;
    options.MeasureInterval = intv;
    options.SecondContrastOnset = cont_onset;
    
    % -----------
    % estimate response measure
    % -----------
    % numCondition = Cont2Condnum(cont1, cont2);
    numCondition = 1:121;       % number index of conditions
    
    % ---------------------------
    % find the response measure
    % ---------------------------
    % define: response measure = the number of spikes counted or average spike
    % rate in Response_measure_interval
    switch sort_measure
        case 'Spike rate'
            switch stage_selected
                case '1 & 2'
                    fr12_yn = dat.FiringXCondRaster12;
                    sorted_trialnum = MSaccContrastAnalysis.sortBySpikeRate(fr12_yn, cont_onset, intv, numCondition);
                case '2 & 3'
                    fr23_yn = dat.FiringXCondRaster23;
                    sorted_trialnum = MSaccContrastAnalysis.sortBySpikeRate(fr23_yn, cont_onset, intv, numCondition);
            end % switch
        case 'Burst size'
    end % switch
    
    
    % =====================
    % commit results
    % =====================
    result_dat.SortBySpikes.Options = options;
    result_dat.SortBySpikes.SortedTrialNum = sorted_trialnum;
    
end % if

% ++++++++++++++++++++++
% sort by usacc
% ++++++++++++++++++++++
if flag_sort_by_ms
    % -----------------
    % get the options
    % -----------------
    sort_measure = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_MS_options.measure;
    stage_included = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_MS_options.stage_included;
    measure_interval = S.Stage_2_Options.StepContrastResponseSorting_options.Sort_by_MS_options.measure_interval;
    
    options.SortMeasure     = sort_measure;
    options.StageIncluded   = stage_included;
    options.MeasureInterval = measure_interval;
    
    % sort trials
    % ------------
    switch sort_measure
        case 'MS numbers'
            switch stage_included
                case '2 & 3'
                    mt23_time = dat.Left_UsaccXCond23_Start;    % ms-times in stage 2 & 3
                    num_cycle = dat.NumberCycle;
                    grattime = dat.grattime;
                    if grattime ~= 1300
                        warning('Grattime is not 1300 ms!')
                    end % if
                    trllen = grattime * 2;
                    [sorted_trialnum, sorted_msnum] = sortByMSNum(mt23_time, measure_interval, num_cycle, trllen);
                otherwise
                    error('Unknown stage numbers')
            end % switch
        otherwise 
            error('Unknown sorting measure')
            
    end % switch
    
    % committ results
    % ---------------
    result_dat.SortByMS.Options = options;      % options for sorting
    result_dat.SortByMS.SortedTrialNum = sorted_trialnum;   % sorted trial num x conditions
    result_dat.SortByMS.SortedMSNum = sorted_msnum;         % sorted MS num x conditions
    
end % if


end % function StepContrastAnalysis

% =====================
% subroutines
% =====================
function [sorted_trialnum, sorted_msnum] = sortByMSNum(ms_times, measure_intv, num_trials, trial_len)
% sorting trials according to MS numbers in the measure interval
% 
% Inputs:
%   ms_times        - microsaccade onset/end times, cells = 1 x number of condiotns
%   measure_intv    - interval for measuring, relative to the start of the trial
%   num_trials      - number of trials
%   trial_len       - length of each trial (ms)
% 
% Output:
%   sorted_trialnum - Sorted trial number, where MS number is in an ascenting order = order x conditions
%   sorted_msnum    - Sorted MS number corresponding to sorted_trialnum = num x conditions

intv_start = measure_intv(1);
intv_end   = measure_intv(2);

N = length(ms_times);   % number of conditions
sorted_trialnum = zeros(num_trials, N);
sorted_msnum = sorted_trialnum;
for k = 1:N
    ms_yn_k = pointtime2yn(ms_times{k}, num_trials, trial_len);
    yn_k = ms_yn_k(:, intv_start:intv_end);
    msnum_k = sum(yn_k, 2);     % number of ms in the interval
    [sorted_msnum_k, idx_k] = sort(msnum_k);
    
    sorted_trialnum(:, k) = idx_k;
    sorted_msnum(:, k) = sorted_msnum_k;
end % for

end % sortByMSNum

% [EOF]

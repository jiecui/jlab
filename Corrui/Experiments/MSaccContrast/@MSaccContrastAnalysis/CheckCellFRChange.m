function result_dat = CheckCellFRChange(current_tag, name, S, dat)
% CHECKCELLFRCHANGE Examination of firing rate changes during experiment
% 
% Description:
%   This function checks the raster and firing rate change over the time
%   during the experiment for cell selection.
%
% Syntax:
%   result_dat = CheckCellFRChange(current_tag, name, S, dat)
% 
% Input(s):
%   current_tag
%   name            - session names
%   S               - structure of options
%   dat             - data
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also CellContrastResponse.

% Copyright 2012 Richard J. Cui. Created: 02/10/2012 11:45:21.187 AM
% $Revision: 0.7 $  $Date: Wed 10/10/2012 10:38:18.523 AM $
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
    
    opt.Show_checkpoint_plots = { {'{0}','1'} };
    opt.Contrast_level_checked = {100 '* (%)' [0 100]};     % the contrast leve for checking firing rate
    opt.Transition_time = {300 '* (ms)' [0 2000]};          % transition time
    opt.Slope_ci_level = {99 '* %', [0 100]};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'mSaccConSig', 'TrialCondition'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% ------------
mSaccConSig = dat.mSaccConSig;
% the contrast level to check firing rate
contrast_k = S.Stage_2_Options.CheckCellFRChange_options.Contrast_level_checked;
% transition time
tran_time = S.Stage_2_Options.CheckCellFRChange_options.Transition_time;
% trial condition number sequence
TrialCondition = dat.TrialCondition;

% find the positions
% ------------------
cond_stage = getCondPosition(contrast_k, TrialCondition);
% find spikeYN
% ------------
spikeyn = getSpikeYN(cond_stage, mSaccConSig);

% check raster
% ------------
[sig_len, repeats, numCycle] = size(spikeyn);
x = spikeyn(:);
T = find(x == 1);
% show check point
if S.Stage_2_Options.CheckCellFRChange_options.Show_checkpoint_plots
    p = [402, 424, 253, 343];
    figure('Position', p)
    rasterplot(T, repeats * numCycle, sig_len, gca);
    hold on
    plot([tran_time, tran_time], ylim, 'r', 'LineWidth', 2)
end % if
% 
% cal. fring rate after transition portion
% ----------------------------------------
spkyn_notran = spikeyn;
spkyn_notran(1:tran_time, :, :) = [];
timeint = sig_len - tran_time;  % time interval for cal. fr
numspk = squeeze(sum(spkyn_notran, 1));
frate = numspk(:) / timeint * 1000;      % spikes/s
seq = 1:length(frate);
seq = seq(:);

% fit
% ----
fobj = fit(seq, frate, 'poly1');
% slope
level = S.Stage_2_Options.CheckCellFRChange_options.Slope_ci_level / 100;
p1 = fobj.p1;
cfint = confint(fobj, level);
cfint_p1 = cfint(:,1)';

% display check point plot
if S.Stage_2_Options.CheckCellFRChange_options.Show_checkpoint_plots
    figure
    plot(fobj)
    hold on
    plot(seq, frate)
end % if

fprintf(sprintf('Slope = %g\n', p1))
fprintf('CI level = %g\n', level)
fprintf(sprintf('lower bound = %g, upper bound = %g\n', cfint_p1(1), cfint_p1(2)));

% ++++++++++++++++++++++++
% commit results
% ++++++++++++++++++++++++
result_dat.FRChange.TranTime = tran_time;
result_dat.FRChange.Raster.spiketime = T;
result_dat.FRChange.Raster.repeats = repeats;
result_dat.FRChange.Raster.numCycle = numCycle;
result_dat.FRChange.Raster.sigLength = sig_len;
result_dat.FRChange.Slope = p1;
result_dat.FRChange.SlopeCILevel = level;
result_dat.FRChange.ConfInt = cfint_p1;
result_dat.FRChange.fitobj = fobj;
result_dat.FRChange.FiringRate = frate;

end % function CheckCellFRChange


% ====================================
% subroutines
% ====================================
function p = getCondPosition(l, c)
% obtain the position of a given conditon in one trial
% 
% Input(s):
%   l       - contrast level (correspondition to 0% to 100%)
%   c       - sequence of trial conditions in one cycle
% 
% Output(s):
%   p       - position of the desired contrast level = [N, 2], where N = number
%             positions, (:,1) = condition number where the desired
%             contrast corrues, (:,2) = stage number where the position is

% check the condition in the sequence one by one
nCond = length(c);      % number of conditions
p = [];
for k = 1:nCond
    q = zeros(1, 2);    % temp to store condition number and stage number
    c_k = c(k);         % current conditon
    % check if level is zeros, stage 1 is always zeros
    if l == 0
        q(1) = c_k;
        q(2) = 1;
        p = cat(1, p, q);
    end % if
    % for stage 2 and 3
    [c2, c3] = Condnum2Cont(c_k);
    if l == c2
        q(1) = c_k;
        q(2) = 2;
        p = cat(1, p, q);
    end % if
    if l == c3
        q(1) = c_k;
        q(2) = 3;
        p = cat(1, p, q);
    end %if
end % for

end % function


function spkYN = getSpikeYN(p, mSaccConSig)
% obtain spike YN according to position
% 
% Input(s)
%   p       - positions of the desired contrast level = [N, 2], where N = number
%             positions, (:,1) = condition number where the desired
%             contrast corrues, (:,2) = stage number where the position is.
%   mSaccConSig
%           - the core data structre of the experiments
% 
% Output(s)
%   spkYN   - spike YN matrix = signal length x number of reppeast in one
%             cycle in time sequence x number of cycles


numCycle = size(mSaccConSig(1).blink, 1);
sig_len = length(mSaccConSig(1,1).eye_position.time_index(:,1));    % signal length

% check position one by one and cycle by cycle
N = length(p);
spkYN = zeros(sig_len, N, numCycle);

for m = 1:numCycle
    spikeYN_m = zeros(sig_len, N);
    for k = 1:N
        p_k = p(k,:);
        c_k = p_k(1);   % condition number
        s_k = p_k(2);   % stage number
        % get data
        stage_k = mSaccConSig(c_k, s_k);
        start_time = stage_k.eye_position.time_index(1, m); % start machine time index of recording
        
        % spike time
        spike_time_k = stage_k.spikes{m};
        % valid spike YN
        if spike_time_k(1, 1) ~= false
           spike_idx = spike_time_k - start_time + 1;
           spike_idx(spike_idx <= 0) = [];
           spikeYN_m(spike_idx, k) = 1;
        end % if
    end % for
    spkYN(:, :, m) = spikeYN_m;
end % for

end % function
% [EOF]
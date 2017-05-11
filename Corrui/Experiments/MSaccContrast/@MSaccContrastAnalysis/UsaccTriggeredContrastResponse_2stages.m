function utcresp = UsaccTriggeredContrastResponse_2stages(data, parameters, fr_method, normlz)
% USACCTRIGGEREDCONTRASTRESPONSE_2STAGES MS-triggered cell response using 2-stage data format
% 
% Description:
%   This function calculates ms-triggered cell response by using 2-stage
%   data format (from stage 1 to 2 and from stage 2 to 3).  See
%   UsaccXContrastCondition for the detail.
%
% Syntax:
%   utcresp = UsaccTriggeredContrastResponse_2stages(data, parameters, fr_method, norm)
% 
% Input(s):
%   data        - data structure
%                 .grattime
%                 .Left_UsaccXCond23_Start
%                 .Left_UsaccXCond23_end
%                 .FiringXCond23
%                 .NumberCycle
%   parameters  - parameters for estmating firing rate
%   fr_method   - method names for estimating firing rate
%   normlz      - method for normalizing firing rate
%                 .method
%                 .smt1_interval
%                 .pmt1_interval
% 
% Output(s):
%   utcresp     - structure of ms-triggered response at different contrast level
%                 .SpikeYN              : ms-onset triggered spike Y/N
%                 .MSNumbers            : number of MS onsets
%                 .SpikeTimes           : spktimes aligned with ms-onset
%                 .SpikeRateWinCenter   : center aligned with ms-onset
%                 .SpikeRate            : spike rate triggered by ms-onset
%                 .SpikeRate_Norm       : normalized spike rate triggered by ms-onset
%                 .SpikeYN_off          : ms-end triggered spike Y/N
%                 .MSNumbers_off        : number of MS ends
%                 .SpikeTimes_off       : spktimes aligned with ms-ends
%                 .SpikeRateWinCenter_off   : center aligned with ms-end
%                 .SpikeRate_off        : spike rate triggered by ms-end
%                 .SpikeRate_Norm_off   : normalized spike rate triggered by ms-end
%                 .Paras.TrialLength    : = pre_ms + post_ms + 1, cut segment length = pre_ms + post_ms + 1
%                 .Paras.GratTime       : = grattime, time for stimulus
%                 .Paras.PostOnsetIntv  : = post_onset, see options
%                 .Paras.PreMSIntv      : = pre_ms, see options
%                 .Paras.PostMSIntv     : = post_ms, see options
%
% Example:
%
% See also UsaccTriggeredContrastResponse, UsaccXContrastCondition.

% Copyright 2013 Richard J. Cui. Created: 12/03/2012 11:53:27.563 AM
% $Revision: 0.3 $  $Date: Fri 01/11/2013 11:57:55.073 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% get the data and parameters
% =========================================================================
usa23_start = data.Left_UsaccXCond23_Start; % use stage 2->3 ms-onset time
usa23_end   = data.Left_UsaccXCond23_end;   % use stage 2->3 ms-end time
num_cycle   = data.NumberCycle;

spktime23   = data.FiringXCond23;       % spike times from stage 2 to 3

grattime    = parameters.grattime;
post_onset  = parameters.post_onset;
pre_ms      = parameters.pre_ms;
post_ms     = parameters.post_ms;
win_width   = parameters.win_width;
win_step    = parameters.win_step;

paras = [grattime, post_onset, pre_ms, post_ms, num_cycle];

% =========================================================================
% cut usa-triggered signal
% =========================================================================
numConditions = length(usa23_start);
% mstrig# - usacc-triggered signal (Y/N_ at contrast level #
mstrig0_start = [];     mstrig0_end = []; 
mstrig10_start = [];    mstrig10_end = []; 
mstrig20_start = [];    mstrig20_end = []; 
mstrig30_start = [];    mstrig30_end = []; 
mstrig40_start = [];    mstrig40_end = []; 
mstrig50_start = [];    mstrig50_end = []; 
mstrig60_start = [];    mstrig60_end = []; 
mstrig70_start = [];    mstrig70_end = []; 
mstrig80_start = [];    mstrig80_end = []; 
mstrig90_start = [];    mstrig90_end = []; 
mstrig100_start = [];   mstrig100_end = []; 

for k = 1:numConditions
    [cont1, cont2] = Condnum2Cont(k);   % condition number --> contrast levels in stage 2 and 3
    spkt_k = spktime23{k};  % spike time from stage 2 to stage 3
    usacc_start_k = usa23_start{k};
    usacc_end_k = usa23_end{k};
    
    % cut ms-triggered spike train in stage 2 - cont1
    switch cont1
        case 0
            [mstrig0_start, mstrig0_end] = mstrigspk(mstrig0_start, mstrig0_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 10
            [mstrig10_start, mstrig10_end] = mstrigspk(mstrig10_start, mstrig10_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 20
            [mstrig20_start, mstrig20_end] = mstrigspk(mstrig20_start, mstrig20_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 30
            [mstrig30_start, mstrig30_end] = mstrigspk(mstrig30_start, mstrig30_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 40
            [mstrig40_start, mstrig40_end] = mstrigspk(mstrig40_start, mstrig40_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 50
            [mstrig50_start, mstrig50_end] = mstrigspk(mstrig50_start, mstrig50_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 60
            [mstrig60_start, mstrig60_end] = mstrigspk(mstrig60_start, mstrig60_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 70
            [mstrig70_start, mstrig70_end] = mstrigspk(mstrig70_start, mstrig70_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 80
            [mstrig80_start, mstrig80_end] = mstrigspk(mstrig80_start, mstrig80_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 90
            [mstrig90_start, mstrig90_end] = mstrigspk(mstrig90_start, mstrig90_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
        case 100
            [mstrig100_start, mstrig100_end] = mstrigspk(mstrig100_start, mstrig100_end, spkt_k, usacc_start_k, usacc_end_k, paras, 2);
    end % switch

    switch cont2
        case 0
            [mstrig0_start, mstrig0_end] = mstrigspk(mstrig0_start, mstrig0_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 10
            [mstrig10_start, mstrig10_end] = mstrigspk(mstrig10_start, mstrig10_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 20
            [mstrig20_start, mstrig20_end] = mstrigspk(mstrig20_start, mstrig20_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 30
            [mstrig30_start, mstrig30_end] = mstrigspk(mstrig30_start, mstrig30_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 40
            [mstrig40_start, mstrig40_end] = mstrigspk(mstrig40_start, mstrig40_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 50
            [mstrig50_start, mstrig50_end] = mstrigspk(mstrig50_start, mstrig50_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 60
            [mstrig60_start, mstrig60_end] = mstrigspk(mstrig60_start, mstrig60_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 70
            [mstrig70_start, mstrig70_end] = mstrigspk(mstrig70_start, mstrig70_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 80
            [mstrig80_start, mstrig80_end] = mstrigspk(mstrig80_start, mstrig80_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 90
            [mstrig90_start, mstrig90_end] = mstrigspk(mstrig90_start, mstrig90_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
        case 100
            [mstrig100_start, mstrig100_end] = mstrigspk(mstrig100_start, mstrig100_end, spkt_k, usacc_start_k, usacc_end_k, paras, 3);
    end % switch

end % for

usacc_on_triggered_spkyn = {mstrig0_start, mstrig10_start, mstrig20_start, ...
                            mstrig30_start, mstrig40_start, mstrig50_start, ...
                            mstrig60_start, mstrig70_start, mstrig80_start, ...
                            mstrig90_start, mstrig100_start};

usacc_off_triggered_spkyn = {mstrig0_end, mstrig10_end, mstrig20_end, ...
                            mstrig30_end, mstrig40_end, mstrig50_end, ...
                            mstrig60_end, mstrig70_end, mstrig80_end, ...
                            mstrig90_end, mstrig100_end};

% cal non/normalized firing rate                        
% ------------------------------
[usa_on_trig_rate, usa_on_trig_rate_norm, usa_on_num, spktimes_on, center_on] = ...
    getLevelFR(usacc_on_triggered_spkyn, win_width, win_step, paras, fr_method, normlz);
[usa_off_trig_rate, usa_off_trig_rate_norm, usa_off_num, spktimes_off, center_off] = ...
    getLevelFR(usacc_off_triggered_spkyn, win_width, win_step, paras, fr_method, normlz);

% =========================================================================
% commit results
% =========================================================================
% ms-onset triggered
utcresp.SpikeYN         = usacc_on_triggered_spkyn;     % ms-onset triggered
utcresp.MSNumbers       = usa_on_num;   % onset
utcresp.SpikeTimes      = spktimes_on;
utcresp.SpikeRateWinCenter = center_on;
utcresp.SpikeRate       = usa_on_trig_rate;
utcresp.SpikeRate_Norm  = usa_on_trig_rate_norm;
% ms-offset triggered
utcresp.SpikeYN_off     = usacc_off_triggered_spkyn;     % ms-onset triggered
utcresp.MSNumbers_off   = usa_off_num;   % onset
utcresp.SpikeTimes_off  = spktimes_off;
utcresp.SpikeRateWinCenter_off = center_off;
utcresp.SpikeRate_off   = usa_off_trig_rate;
utcresp.SpikeRate_Norm_off  = usa_off_trig_rate_norm;
% parameters
utcresp.Paras.TrialLength = pre_ms + post_ms + 1;  % cut segment length = pre_ms + post_ms + 1
utcresp.Paras.GratTime = grattime;    % time for stimulus
utcresp.Paras.PostOnsetIntv = post_onset;    % see options
utcresp.Paras.PreMSIntv = pre_ms;     % see options
utcresp.Paras.PostMSIntv = post_ms;   % see options

end % function UsaccTriggeredContrastResponse_2stages

% =========================================================================
% subroutines
% =========================================================================
function [rate, rate_norm, usa_num, spktimes, t] = getLevelFR(usa_triggered_spkyn, ...
    win_width, win_step, paras, fr_method, normlz)
% get firing rate of the cell at each level
% 
% Inputs
%   usa_triggered_spkyn         - usacc triggered spike y/n
%   win_width                   - window width for cal firing rate
%   win_step                    - moving window step
%   paras                       - paras = [grattime, post_onset, pre_ms, post_ms]
%   fr_method                   - method names for estimating firing rate
%   normlz                      - method for normalizing firing rate
% 
% Outputs
%   rate                        - firing rate
%   rate_norm                   - normalized firing rate
%   usa_num                     - usacc numbers
%   spktimes                    - spike times of each level
%   t                           - spike rate centers

pre_ms = paras(3);

numlevels = 11;                 % number of contrast level, basic constant of this universe
usa_num = zeros(1, numlevels);  % number of usacc of each levels
spktimes = cell(1, 11);         % spike times of each level
rate = [];
rate_norm = [];
for k = 1:numlevels
    
    spkyn_k = usa_triggered_spkyn{k};
    [spkt_k, usa_num_k, trl_len] = yn2pointtime(spkyn_k);
    
    spktimes{k} = spkt_k;
    usa_num(k) = usa_num_k;
    
    switch fr_method
        case 'PSTH'
            [t, ~, R] = SpikeProcess.SpikeRateEstimation.PSTHEst(spkt_k, usa_num_k, ...
                trl_len, win_width, win_step);
        case 'Chronux'
            params.Fs = 1000;
            [t, R] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spkyn_k, [win_width, win_step], params);
    end % switch
    
    R = R(:)';
    rate = cat(1, rate, R);
    % --------------
    % normalization
    % --------------
    norm_method = normlz.method;
    smt1_interval = normlz.smt1_interval;
    switch norm_method
        case 'Percentage change'
            smt1 = mean(R(t > smt1_interval(1) + pre_ms & t < smt1_interval(2) + pre_ms));
            norm_R = (R - smt1) / smt1;
        case 'Firing rate difference'
            smt1 = mean(R(t > smt1_interval(1) + pre_ms & t < smt1_interval(2) + pre_ms));
            norm_R = R - smt1;
    end % switch
    rate_norm = cat(1, rate_norm, norm_R);
    
end % for

end % function

function [out_start, out_end] = mstrigspk(mstrigin_start, mstrigin_end, spkt, usa_start, usa_end, paras, stage)
% Input(s)
%   mstrigin_start      - input usacc-triggered Y/N aligned at usacc ONSET
%   mstrigin_end        - input usacc-triggered Y/N aligned at usacc OFFSET
%   spkt                - spike time of current trial, from stage 2 to
%                         stage 3
%   usa_start           - usacc ONSET times, from stage 2 to stage 3
%   usa_end             - usacc OFFSET times
%   paras               - [grattime, post_onset, pre_ms, post_ms]
% 
% Output(s)
%   out_start           - output usacc-triggered Y/N aligned at usacc ONSET
%   out_end             - output usacc-triggered Y/N aligned at usacc OFFSET

% convert times to y/n matrix
% ---------------------------
grattime = paras(1);
num_cycle = paras(5);
trl_len = 2*grattime;
spkt_yn = pointtime2yn(spkt, num_cycle, trl_len); 
usa_start_yn = pointtime2yn(usa_start, num_cycle, trl_len);
usa_end_yn = pointtime2yn(usa_end, num_cycle, trl_len);

mstrig_start = [];
mstrig_end   = [];
for k = 1:num_cycle                 % cycle by cycle
    spktyn_k = spkt_yn(k, :); % spike times in the kth cycle
    usayn_on_k = usa_start_yn(k, :);  % usacc onset time in the kth cycle
    usayn_off_k = usa_end_yn(k, :);   % usacc offset time in the kth cycle
    
    spktyn_stage_k    = getStageYN(spktyn_k, stage, paras);
    usayn_on_stage_k  = getStageYN(usayn_on_k, stage, paras);
    usayn_off_stage_k = getStageYN(usayn_off_k, stage, paras);
    
    out_start_k = mstrigyn(usayn_on_stage_k, spktyn_stage_k, paras);
    out_end_k   = mstrigyn(usayn_off_stage_k, spktyn_stage_k, paras);
    
    mstrig_start    = cat(1, mstrig_start, out_start_k);
    mstrig_end      = cat(1, mstrig_end, out_end_k);
end % for

out_start = cat(1, mstrig_start, mstrigin_start);
out_end   = cat(1, mstrig_end, mstrigin_end);

end % function

function yn_stage = getStageYN(yn, stage, paras)
% yn    - y/n sequence
% stage - 2 or 3
% paras - [grattime, post_onset, pre_ms, post_ms]

grattime = paras(1);
switch stage
    case 2
        idx = 1:grattime;
    case 3
        idx = (grattime + 1):(2 * grattime);
    otherwise 
        error('Unknown stage number')
        
end % swtich
yn_stage = yn(idx);

end % function

function out_yn = mstrigyn(usayn, spkyn, paras)
% Inputs:
%   usayn           - microsaccade y/n of current stage
%   spkyn           - spike y/n of current stage
%   paras           - [grattime, post_onset, pre_ms, post_ms]
% 
% Outputs
%   out_yn          - ms-triggered spike Y/N

grattime = paras(1);    % stimulus time of one stage
post_onset = paras(2);
pre_ms = paras(3);
post_ms = paras(4);

% find point times
usatime = yn2pointtime(usayn);

out_yn = [];
M = length(usatime);    % number of ms
for k = 1:M     % ms by ms
    usat_k = usatime(k);
    % check the validity of usacc
    % ---------------------------
    if (usat_k > post_onset + pre_ms) && (usat_k <= grattime - post_ms)
        % length of the cut
        % ------------------
        cut_start = usat_k - pre_ms;
        cut_end   = usat_k + post_ms;
        
        % get the spike times in the interval
        % -----------------------------------
        spkyn_k = spkyn(cut_start:cut_end);
        out_yn = cat(1, out_yn, spkyn_k);
    end % if
end % for

end % function

% [EOF]

function utcresp = UsaccTriggeredContrastResponse_3stages(data, parameters)
% USACCTRIGGEREDCONTRASTRESPONSE_3STAGES MS-triggered cell response using 3-stage data format
% 
% Description:
%   This function calculates ms-triggered cell response by using old data
%   format from 3 stages of the data.  The data were obtained from
%   mSaccConSig structure.  At each stage, the signal began at the stage
%   onset and then was cut by grattime (usually 1300 ms).
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

% Copyright 2012 Richard J. Cui. Created: 11/14/2012  9:23:35.126 AM
% $Revision: 0.1 $  $Date: 11/14/2012  9:23:35.126 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

SpikeYN     = data.SpikeYN;
AllUsacc    = data.AllUsacc;
TrialTime   = data.TrialTime;

grattime    = parameters.grattime;
post_onset  = parameters.post_onset;
pre_ms      = parameters.pre_ms;
post_ms     = parameters.post_ms;
win_width   = parameters.win_width;
win_step    = parameters.win_step;

paras = [grattime, post_onset, pre_ms, post_ms];

numConditions = size(SpikeYN, 3);
% mstrig# - usacc-triggered signal at contrast level #
mstrig0 = []; mstrig10 = []; mstrig20 = []; mstrig30 = []; mstrig40 = [];
mstrig50 = []; mstrig60 = []; mstrig70 = []; mstrig80 = []; mstrig90 = []; mstrig100 = [];
for k = 1:numConditions
    
    [cont1, cont2] = Condnum2Cont(k);   % condition number --> contrast levels in stage 2 and 3
    spkyn_k = SpikeYN(:, :, k);         % spike YN data
    usacc_k = AllUsacc(:, :, k);        % usacc data structure, see getSessionInfo.m
    trltime_k = TrialTime(:, :, k);     % contrast start time index
    
    % cut ms-triggered spike train in stage 2 - cont1
    switch cont1
        case 0
            mstrig0 = mstrigspikyn(mstrig0, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 10
            mstrig10 = mstrigspikyn(mstrig10, spkyn_k, usacc_k, trltime_k,paras, 2);
        case 20
            mstrig20 = mstrigspikyn(mstrig20, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 30
            mstrig30 = mstrigspikyn(mstrig30, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 40
            mstrig40 = mstrigspikyn(mstrig40, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 50
            mstrig50 = mstrigspikyn(mstrig50, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 60
            mstrig60 = mstrigspikyn(mstrig60, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 70
            mstrig70 = mstrigspikyn(mstrig70, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 80
            mstrig80 = mstrigspikyn(mstrig80, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 90
            mstrig90 = mstrigspikyn(mstrig90, spkyn_k, usacc_k, trltime_k, paras, 2);
        case 100
            mstrig100 = mstrigspikyn(mstrig100, spkyn_k, usacc_k, trltime_k, paras, 2);
            
    end % switch
    
    % cut ms-triggered spike train in stage 3 - cont2
    switch cont2
        case 0
            mstrig0 = mstrigspikyn(mstrig0, spkyn_k, usacc_k,  trltime_k,paras, 3);
        case 10
            mstrig10 = mstrigspikyn(mstrig10, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 20
            mstrig20 = mstrigspikyn(mstrig20, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 30
            mstrig30 = mstrigspikyn(mstrig30, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 40
            mstrig40 = mstrigspikyn(mstrig40, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 50
            mstrig50 = mstrigspikyn(mstrig50, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 60
            mstrig60 = mstrigspikyn(mstrig60, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 70
            mstrig70 = mstrigspikyn(mstrig70, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 80
            mstrig80 = mstrigspikyn(mstrig80, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 90
            mstrig90 = mstrigspikyn(mstrig90, spkyn_k, usacc_k, trltime_k, paras, 3);
        case 100
            mstrig100 = mstrigspikyn(mstrig100, spkyn_k, usacc_k, trltime_k, paras, 3);
            
    end % switch
    
end % for

usacc_triggered_spkyn = {mstrig0, mstrig10, mstrig20, mstrig30, mstrig40, mstrig50,...
                      mstrig60, mstrig70, mstrig80, mstrig90, mstrig100};
 
% cal. firing rate and normalized firing rate
% --------------------------------------------
usa_trig_rate       = [];   % not normalized spike rate
usa_trig_rate_norm  = [];   % normalized spike rate
usa_num             = zeros(1, 11);     % usacc numbers of each contrast level
spktimes            = cell(1, 11);      % usacc_triggered spike times of each contrast level
for k = 1:11    % different contrast levels
    spkyn_k = usacc_triggered_spkyn{k};
    [spktimes_k, usa_num_k, trl_len] = yn2pointtime(spkyn_k);
    % [t,R] = SpikeProcess.SpikeRateEstimation.ChronuxEst(spkyn_k, movingwin, params);
    spktimes{k} = spktimes_k;
    usa_num(k) = usa_num_k;
    [t, ~, R] = SpikeProcess.SpikeRateEstimation.PSTHEst(spktimes_k, usa_num_k, trl_len, win_width, win_step);
    R = R(:)';
    usa_trig_rate = cat(1, usa_trig_rate, R);
    % normalize
    base_rate = mean(R(t > 0 & t < pre_ms));
    norm_R = (R - base_rate) / base_rate;
    usa_trig_rate_norm = cat(1, usa_trig_rate_norm, norm_R);
end % for

% =========================================================================
% commit results
% =========================================================================
utcresp.SpikeYN = usacc_triggered_spkyn;
utcresp.MSNumbers = usa_num;
utcresp.SpikeTimes = spktimes;
utcresp.SpikeRateWinCenter = t;
utcresp.SpikeRate = usa_trig_rate;    % row = different contrast levels
utcresp.SpikeRate_Norm = usa_trig_rate_norm;  % normalized
utcresp.Paras.TrialLength = trl_len;  % cut segment length = pre_ms + post_ms + 1
utcresp.Paras.GratTime = grattime;    % time for stimulus
utcresp.Paras.PostOnsetIntv = post_onset;    % see options
utcresp.Paras.PreMSIntv = pre_ms;     % see options
utcresp.Paras.PostMSIntv = post_ms;   % see options

end % function UsaccTriggeredContrastResponse_3stages

% =========================================================================
% subroutines
% =========================================================================
function mstrigout = mstrigspikyn(mstrigin, spkyn, usacc, trltime, paras, stage)
% cut microsaccade-triggered spikeyn
%   paras = [grattime, post_onset, pre_ms, post_ms];
%   stage = 1 or 2 or 3
% 
% Note: presently, assume the length of usacc-triggered signal is the same.
% may use variable length later

grattime = paras(1);    % stimulus time of one stage
post_onset = paras(2);
pre_ms = paras(3);
post_ms = paras(4);

mstrig = [];

N = size(spkyn, 1);     % number of cycles repeated in this data
for k = 1:N             % cycle by cycle
    spkyn_k = spkyn(k, :);
    usa_k = usacc{k, stage};
    M = size(usa_k, 1); % number of microsaccades
    if M > 0            % do have usacc
    % if ~isempty(usa_k)
        usacc_k = usa_k(:, 1) - trltime(k, stage) + 1;  % usacc onset time relative to the contrast onset
        % M = length(usacc_k);    % num of microsaccades
        for p = 1:M
            if (usacc_k(p) > post_onset + pre_ms) && (usacc_k(p) <= grattime - post_ms)
                usacc_onset = usacc_k(p) + (stage - 1) * grattime;
                spkyn_kp = spkyn_k((usacc_onset - pre_ms) : (usacc_onset + post_ms));   % the cut
                mstrig = cat(1, mstrig, spkyn_kp);  % assume equal length
            end % if
        end % for
    end % if
end % for

mstrigout = cat(1, mstrigin, mstrig);

end % function

% [EOF]

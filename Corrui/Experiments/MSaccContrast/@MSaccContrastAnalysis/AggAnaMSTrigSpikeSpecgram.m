function result_dat = AggAnaMSTrigSpikeSpecgram(current_tag, name, S, dat)
% AGGANAMSTRIGSPIKESPECGRAM MS triggered spike spectrogram in aggregated data
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

% Copyright 2014 Richard J. Cui. Created: Thu 10/23/2014  2:44:56.497 PM
% $Revision: 0.1 $  $Date: Thu 10/23/2014  2:44:56.497 PM $
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
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};
    
    %     opt.Usacc_rate_smoothing_Window_half_width = {100, '* (ms)', [1 2000]};     % 125
    % opt.Usacc_rate_option = {'Rate|{YN NPMovWin}|YN Locfit'};     

    opt = [];
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'SpikeSpectrogram', 'sessions' };
    
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% options
% intv_selected = S.Stage_2_Options.([mfilename, '_options']).intv_selected;

% data
sess = dat.sessions;
spike_specgram = dat.SpikeSpectrogram;
R = spike_specgram{1}.R;

% averaging
M = size(R, 2);     % number of contrast levels
N = length(sess);
S = [];
Srn = [];   % rate-normalized

for j = 1:M     % each contrast level
    S_j = [];
    Srn_j = [];
    for k = 1:N % each session
        S_kj = spike_specgram{k}.S(j).Spectrogram;
        Srn_kj = spike_specgram{k}.SRateNorm(j).Spectrogram;
        
        S_j = cat(3, S_j, S_kj);
        Srn_j = cat(3, Srn_j, Srn_kj);
    end % for
    
    avg_S_j = mean(S_j, 3);
    avg_Srn_j = mean(Srn_j, 3);
    
    S = cat(3, S, avg_S_j);
    Srn = cat(3, Srn, avg_Srn_j);
end % for

% =========================================================================
% commit
% =========================================================================
result_dat.AvgSpikeSpecgram = S;
result_dat.AvgRateNormSpikeSpecgram = Srn;

end % function AggAnaMSTrigResp

% =========================================================================
% subroutines
% =========================================================================


% [EOF]

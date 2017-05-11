function result_dat = MSTriggeredSpikeSpectrogram(current_tag, sname, S, dat)
% MSTRIGGEREDSPIKESPECTROGRAM Individual cell MS-triggered spike spectrogram response at different contrast level
% 
% Description:
%   This function calculates MS-triggered response of individual cell.  The
%   results are averaged spike spectrum at each contrast level.  The averaged
%   spike spectrum can be either absolute or rate-normalized one,
%   according to the choices. 
% 
% Syntax:
%   result_dat = MSTriggeredContrastResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
% 
% Reference:
%   Pesaran, B., Pezaris, J. S., Sahani, M., Mitra, P. P., & Andersen, R.
%   A. (2002). Temporal structure in neuronal activity during working
%   memory in macaque parietal cortex. Nature Neuroscience, 5(8), 805-811.
% 
% See also mtspecgrampt.

% Copyright 2014 Richard J. Cui. Created: Wed 10/22/2014  1:00:03.595 PM
% $Revision: 0.2 $  $Date: Thu 10/23/2014 11:55:33.645 AM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag, 'get_options')
    % moving window paras
    % -------------------
    opt.movingwin = { [100, 5] 'Win Width Step (ms)' [1 Inf] };
    
    % paras for multi-taper methods (see mtspecgrampt.m)
    % --------------------------------------------------
    opt.tapers  = {[3, 5] 'Taper' [1 Inf] true};
    opt.pad     = { 0 'Padding factor' [-1 10] };
    opt.Fs      = { 1000 'Sampling frequency (Hz)' [0 Inf] };
    opt.fp_min  = { 0 'Frequency pass lower bound (Hz)' [0 Inf] };
    opt.fp_max  = { 1000 / 2 'Frequency pass upper bound (Hz)' [0 Inf] };
    opt.err     = { [0 0.1], 'Error calculation', [0 2] };
    opt.trialave    = { {'0', '{1}'} 'Average trials'};
    opt.timerange   = { '{Trial range}|minmax spike times', 'Win moving range (ms)'};
    opt.fscorr  = { {'{0}', '1'} 'Finite size correction' };
    
    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'MSTriggeredContrastResponse' };
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data and options
% =========================================================================
% data
mstresp = dat.MSTriggeredContrastResponse;

% options and paras
movingwin   = S.Stage_2_Options.([mfilename, '_options']).movingwin;
tapers      = S.Stage_2_Options.([mfilename, '_options']).tapers;
pad         = S.Stage_2_Options.([mfilename, '_options']).pad;
Fs          = S.Stage_2_Options.([mfilename, '_options']).Fs;
fp_min      = S.Stage_2_Options.([mfilename, '_options']).fp_min;
fp_max      = S.Stage_2_Options.([mfilename, '_options']).fp_max;
err         = S.Stage_2_Options.([mfilename, '_options']).err;
trialave    = S.Stage_2_Options.([mfilename, '_options']).trialave;
timerange   = S.Stage_2_Options.([mfilename, '_options']).timerange;
fscorr      = S.Stage_2_Options.([mfilename, '_options']).fscorr;

% =========================================================================
% Data processing
% =========================================================================
% get data
% --------------------
spike_times = mstresp.SpikeTimes;
num_trials = mstresp.Paras.trial_num;
trial_len = mstresp.Paras.trial_length;

% moving wind
% ------------
mt_params.movingwin = movingwin / 1000 * Fs;     % ms --> points

% multi-taper params
% -------------------
params.tapers   = tapers;
params.pad      = pad;
params.Fs       = 1;        % calculation using unit sampling rate

fpass = [fp_min, fp_max];
params.fpass    = fpass / Fs;
params.err      = err;
params.trialave = trialave;

switch timerange
    case 'Trial range'
        minmaxtime = [1 trial_len] / 1000 * Fs;  % ms --> points
        params.minmaxtime = minmaxtime;
        
    case 'minmax spike times'
        % leave blank
        
end % switch
mt_params.params = params;

% fscorr
% ------
mt_params.fscorr = fscorr;

% cal spectrogram
% ---------------
curr_exp = CorrGui.CheckTag(current_tag);
spike = MSCSpike(curr_exp, sname);  % spike object
nlevels = length(spike_times);  % number of contrast levels

S = struct([]);
S_rnorm = struct([]);   % rate-normalized
R = [];
Serr = [];
for k = 1:nlevels   % cal spike spectrogram at each contrast level
    spkt_k = spike_times{k};     % ms --> sec
    numtrial_k = num_trials(k);
    
    [S_k, t, f, R_k, Serr_k] = spike.ChronuxSpikeSpectrogram(spkt_k, numtrial_k, trial_len, mt_params);
    
    rmat_k = repmat(R_k, 1, size(S_k, 2));
    Srn_k = S_k ./ rmat_k;
    
    S(k).Spectrogram = S_k;
    S_rnorm(k).Spectrogram = Srn_k;
    R = cat(2, R, R_k);
    Serr = cat(1, Serr, Serr_k);
    
end % for
                   
% =====================
% commit results
% =====================
spk_specgram.t      = t / Fs;   % point --> sec
spk_specgram.f      = f * Fs;
spk_specgram.S      = S;
spk_specgram.SRateNorm = S_rnorm;   % rate normalized
spk_specgram.R      = R * Fs;   % points/sec
spk_specgram.Serr   = Serr;

result_dat.SpikeSpectrogram = spk_specgram;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================


% [EOF]

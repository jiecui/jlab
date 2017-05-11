function [S, t, f, R, Serr] = ChronuxSpikeSpectrogram(spiketimes, num_trials, trial_length, mt_params)
% CHRONUXSPIKESPECTROGRAM estimates spike spectrogram using Chronux2
%
% Syntax:
%   [S, f, R, Serr] = ChronuxSpikeSpectrogram(spiketimes, num_trials, trial_length, mt_params)
% 
% Input(s):
%   spiketimes      - spike times in spike raster (see pointtime2yn.m)
%   num_trials      - number of trials/channels in 'spiketimes'
%   trial_length    - the length of each trial or data length in one channel
%   mt_params       - parameters for multitaper calculation
%                     mt_params.params: see mtspecgrampt.m for the details.
%                                       default values tapers = [3, 5]
%                     mt_params.fscorr: finite size corrections (see
%                                       mtspectrumpt.m for the details), default = 0;
%                     mt_params.movingwin: [winwidth, winstep], see mtspecgrampt.m for the details
% 
% Output(s):
%   S, t, f, R, Serr   - see mtspectrumpt.m for the details
%   
% Example:
%
% See also mtspecgrampt (Chronux).

% Copyright 2014 Richard J. Cui. Created: Wed 10/22/2014 11:34:05.739 AM
% $Revision: 0.2 $  $Date: Wed 10/22/2014  1:30:14.692 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ---------------------------
% parse inputs
% ---------------------------
% params for multitaper
if ~exist('mt_params', 'var')
   params.tapers = [3, 5];
   fscorr = 0;
   movingwin = [];   
else
   params = mt_params.params;
   fscorr = mt_params.fscorr;
   movingwin = mt_params.movingwin; 
end

% ----------
% main
% ----------
% construct data structure array
spk_yn = pointtime2yn(spiketimes, num_trials, trial_length);
% num_ch = size(spk_yn, 1);   % number of trials/channels
% data = struct([]);
% 
% for k = 1:num_ch
%     spk_yn_k = spk_yn(k, :);
%     spk_time_k = yn2pointtime(spk_yn_k);
%     data(k).spiketimes = spk_time_k;
% end % for

data = SpikeYN2ChronuxData(spk_yn);
% estimate spectrum
[S, t, f, R, Serr] = mtspecgrampt(data, movingwin, params, fscorr);

end % function ChronuxSpikeSpectrum

% [EOF]

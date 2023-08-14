function [S, f, R, Serr] = ChronuxSpikeSpectrum(spiketimes, num_trials, trial_length, mt_params)
% CHRONUXSPIKESPECTRUM estimates spike spectrum using Chronux2
%
% Syntax:
%   [S, f, R, Serr] = ChronuxSpikeSpectrum(spiketimes, num_trials, trial_length, mt_params)
% 
% Input(s):
%   spiketimes      - spike times in spike raster (see pointtime2yn.m)
%   num_trials      - number of trials/channels in 'spiketimes'
%   trial_length    - the length of each trial or data length in one channel
%   mt_params       - parameters for multitaper calculation
%                     mt_params.params: see mtspectrumpt.m for the details.
%                                       default values tapers = [3, 5]
%                     mt_params.fscorr: finite size corrections (see
%                                       mtspectrumpt.m for the details), default = 0;
%                     mt_params.t: see mtspectrumpt.m for the details
% 
% Output(s):
%   S, f, R, Serr   - see mtspectrumpt.m for the details
%   
% Example:
%
% See also mtspectrumpt (Chronux).

% Copyright 2014 Richard J. Cui. Created: Wed 10/22/2014  9:50:12.604 AM
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
   t = [];   
else
   params = mt_params.params;
   fscorr = mt_params.fscorr;
   t = mt_params.t; 
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
[S, f, R, Serr] = mtspectrumpt(data, params, fscorr, t);

end % function ChronuxSpikeSpectrum

% [EOF]

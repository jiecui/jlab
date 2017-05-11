function opt = plot_MSTriggeredSpikeSpecgram(current_tag, sname, S)
% PLOT_MSTRIGGEREDSPIKESPECGRAM plots MS-triggered spike spectrogram
%
% Syntax:
%   opt = plot_MSTriggeredSpikeSpecgram(current_tag, sname, S)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Thu 10/23/2014 12:16:31.670 PM
% $Revision: 0.1 $  $Date: Thu 10/23/2014 12:16:31.670 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% options
% =========================================================================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )

        opt.cont_level = { {'0' '10' '20' '30' '40' '50' '60' '70' '80' '90' '100'}, 'Chose contrast level (%)'};
        
        return
    end
end

% =========================================================================
% get options
% =========================================================================
cont_level = S.([mfilename,'_options']).cont_level;

% =========================================================================
% get data wanted
% =========================================================================
dat_var = {'SpikeSpectrogram', 'MSTriggeredContrastResponse'};
dat = CorruiDB.Getsessvars(sname,dat_var);
spike_specgram = dat.SpikeSpectrogram;
mstresp = dat.MSTriggeredContrastResponse;

% =========================================================================
% plot
% =========================================================================
if ischar(cont_level)
    cont = str2double(cont_level);
else
    cont = cont_level;
end % if

pre_ms = mstresp.Paras.pre_ms;
t = spike_specgram.t * 1000 - pre_ms;    % ms
f = spike_specgram.f;
S = spike_specgram.S;
Srn = spike_specgram.SRateNorm;
k = cont / 10 + 1;

% spike spectrogram
figure
imagesc(t, f, 10 * log10(S(k).Spectrogram)')
axis xy
hold on
plot([0 0], ylim, 'Color', [0 0 0], 'LineWidth', 2)
title(sprintf('Spectrogram at %d%% contrast', cont))
xlabel('Time from MS-Onset (ms)')
ylabel('Frequency (Hz)')

% spike rate-normalized spectrogram
figure
imagesc(t, f, 10 * log10(Srn(k).Spectrogram)')
axis xy
hold on
plot([0 0], ylim, 'Color', [0 0 0], 'LineWidth', 2)
title(sprintf('Rate-normalized Spectrogram at %d%% contrast', cont))
xlabel('Time from MS-Onset (ms)')
ylabel('Frequency (Hz)')

end % function plot_MSTriggeredSpikeSpecgram

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

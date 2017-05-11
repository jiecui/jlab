function options = Spike_raster_and_rate(current_tag, snames, S)
% SPIKE_RASTER_AND_RATE plots the spike raster and spike rates given the condition number.
%
% Syntax:
%
% Input(s):
%   current_tag         - current tag
%   snames              - session names, in cells
%   S                   - options
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.2 $  $Date: Wed 07/11/2012  9:49:14.679 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ========================
% options
% ========================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        % options.Something   = { {'0','{1}'} };
        options.Condition_number = {1 '' [1 121]};
        % options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'SpikeYN', 'StepContrastAnalysisResult', 'LastConChunk'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);

SpikeYN = dat.SpikeYN;
DynamicFiringRate = dat.StepContrastAnalysisResult.DynamicFiringRate;
NoExcludeFR = dat.StepContrastAnalysisResult.NoExcludeFR;
WindowCenters = dat.StepContrastAnalysisResult.WindowCenters;
grattime = dat.LastConChunk.ConEnvVars.grattime;

numCond = S.Spike_raster_and_rate_options.Condition_number;

% ========================
% plot
% ========================
fh = figure('name', sprintf('Cell %s - Spike raster & FR', snames{1}));

% plot spike raster
% ------------------
[numCycle, SigLen, ~] = size(SpikeYN);
a = SpikeYN(:,:,numCond)';
spktime = find(a > 0);
raster_axis = axes('Parent',fh,...
    'Position',[0.13 0.761904761904763 0.775 0.115476190476199]);
rasterplot(spktime, numCycle, SigLen, raster_axis)
hold on
plot(grattime*[1 1], ylim, 'r');
plot(grattime*[2 2], ylim, 'r');
xlim([0 SigLen]);
[con1, con2] = Condnum2Cont(numCond);
title(sprintf('Contrast %d --> Contrast %d', con1, con2));
xlabel('')
ylabel('Cycles')

% plot spike rates
% ----------------
selectedFR = DynamicFiringRate(:, numCond);
noexcludFR = NoExcludeFR(:, numCond);
fr_axis = axes('Parent',fh, 'Position',[0.13 0.11 0.775 0.570952380952381]);
plot(fr_axis, WindowCenters, [selectedFR, noexcludFR])
% legend('Selected', 'Not Selected')
hold on
plot(grattime*[1 1], ylim, 'r');
plot(grattime*[2 2], ylim, 'r');
xlim([0 SigLen]);
xlabel('Time (ms)')
ylabel('Normalized Firing Rate')

end % function Spike_raster_and_rate

% [EOF]

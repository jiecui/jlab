function result_dat = CellOrtTuning(current_tag, name, S, dat)
% CELLORTTUNING analyzes the orientation tuning of the cell, i.e.
%       firing rate of the cells in response to orientation of stimulus
%       bars
%
% Syntax:
%   result_dat = CellOrtTuning(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat      - .
% 
% Example:
%
% See also calDirect.

% Copyright 2014 Richard J. Cui. Created: Wed 05/30/2012 12:32:48.997 PM
% $Revision: 0.2 $  $Date: Sat 03/15/2014  9:52:20.825 PM $
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
    
    opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'BeforeExpTuneChunk', 'AfterExpTuneChunk'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% -------------
tune0 = dat.BeforeExpTuneChunk;
tune1 = dat.AfterExpTuneChunk;

% normalized probability (frequency)
% -----------------------------------
% Before the exp
hit0 = tune0.TrueHits(1:18);
p_b = hit0 / sum(hit0);     % normalized

% After the exp
hit1 = tune1.TrueHits(1:18);
p_a = hit1 / sum(hit1);     % normalized

% Directionality measure
% -----------------------
% A = 10 * (9:-1:-8);         % angles in degree
A = 0:10:170;
[dirt_b, hw_b] = calDirect(A, p_b);     % before experiment
[dirt_a, hw_a] = calDirect(A, p_a);     % after experiment

% similarity measure
% ------------------
c = corrcoef(p_a, p_b);
c0 = c(1,2);

% display
fprintf(sprintf('Orientation before exp = %g, Directionality = %g.\n', dirt_b, hw_b));
fprintf(sprintf('Orientation after exp = %g, Directionality = %g.\n', dirt_a, hw_a));
fprintf(sprintf('cross correlation coeff = %g.\n', c0));

ort_tune.OrientationBeforeExp  = dirt_b;
ort_tune.HalfWinWidthBeforeExp = hw_b;
ort_tune.OrientationAfterExp = dirt_a;
ort_tune.HalfWinWidthAfterExp  = hw_a;
ort_tune.XCorr = c0;

% ++++++++++++++++++++++++
% commit results
% ++++++++++++++++++++++++
result_dat.OrtTuneResponse = ort_tune;   % grating response

end % function CellContrastResponse


% ====================================
% subroutines
% ====================================



% [EOF]

function result_dat = do_SpikeTimeStepCont(current_tag, name, S, dat)
% DO_SPIKETIMESTEPCONT Spike times of cell data block in response to step-contrast change
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also FiringXContrastCondition.

% Copyright 2014 Richard J. Cui. Created: 10/26/2012 10:47:19.522 AM
% $Revision: 0.3 $  $Date: Wed 02/19/2014  5:14:41.228 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%% ========================================================================
% Options of analysis
% =========================================================================
if strcmpi(current_tag,'get_options')
    %     opt.tfmethod = {'{affine}|lwm'};
    %     opt.Latency = {30 '* (ms)' [0 1000]};
    %     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
    %         % outside the fix grid more than SMThres * STDs will be discarded
    %     opt.normalized_spike_map = { {'{0}','1'} };
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};

    opt.grat_time = {1300 'Stimulus presentation time (ms)' [1 1300]};
    result_dat = opt;
    return
end % if

%% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'enum' 'spiketimes' 'trialMatrix' 'NumberCondition'...
                'NumberCycle' 'CondInCycle'};
    result_dat = dat_var;
    return
end % if

%% ========================================================================
% get the data
% =========================================================================
% grattime    = dat.grattime;   % H12A06B = 2000;
ncond       = dat.NumberCondition;
ncycle      = dat.NumberCycle;
enum        = dat.enum;
spiketimes  = dat.spiketimes;
condcyc     = dat.CondInCycle;
trialmax    = dat.trialMatrix;

%% ========================================================================
% The analysis
% =========================================================================
grattime = S.Stage_2_Options.([mfilename, '_options']).grat_time;
[fxc12, fxc23] = MSaccContrastAnalysis.FiringXContrastCondition(ncond, ncycle, grattime, spiketimes,...
    condcyc, trialmax, enum);

%% ========================================================================
% Commit
% =========================================================================
result_dat.FiringXCond12 = fxc12;
result_dat.FiringXCond23 = fxc23;
result_dat.FiringXCondLength = 2 * grattime;

end % function FiringXContrastCondition

%% ========================================================================
% subroutines
% =========================================================================

% [EOF]

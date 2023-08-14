function [win_centers, spk_rate, rate_mean, rate_sem] = PSTHEst(spktimes, num_trial, trl_length, win_width, win_step)
% PSTHEST estimates spike rates using PSTH
%
% Syntax:
%   [win_centers, spk_rate, rate_mean, rate_sem] = PSTHEst(spktimes, num_trial, trial_length, win_width, win_step)
% 
% Input(s):
%   spktimes    - spike times
%   num_trial   - number of trials
%   trl_length  - trial length
%   win_width   - moving window width (unit same as pointyn)
%   win_step    - step for moving the window (unit same as pointyn)
%
% Output(s):
%   win_centers - moving window centers (unit samples)
%   spk_trate   - rate of each trial
%   rate_mean   - estimated mean point rate at each window 
%                 (unit - number of points per sample)
%   point_sem   - estimated standard error of point rate
%
% Example:
% 
% Reference:
%
% See also LocfitEst.

% Copyright 2013 Richard J. Cui. Created: Sun 06/24/2012  9:08:16.358 PM
% $Revision: 0.5 $  $Date: Sat 04/27/2013  3:12:14.957 PM $
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

% =========================================================================
% main body
% =========================================================================
spk_yn = pointtime2yn(spktimes, num_trial, trl_length);

[win_centers, spk_rate, rate_mean, rate_sem] ... 
    = NoneParaMovingWindowEst(spk_yn, win_width, win_step);

end % function estFixSpot

% ======================
% subroutines
% ======================

% [EOF]

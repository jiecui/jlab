function [win_centers, spk_rate, rate_mean, rate_sem] = PSTHEst(spktimes, num_trial, trl_length, win_width, win_step)
    % +SPIKEPROCESS.SPIKERATEESTIMATION.PSTHEST estimates spike rates using PSTH
    %
    % Syntax:
    %   [win_centers, spk_rate, rate_mean, rate_sem] = PSTHEst(spktimes, num_trial, trial_length, win_width, win_step)
    %
    % Input(s):
    %   spktimes    - spike times (time indexes of point events)
    %   num_trial   - number of trials
    %   trl_length  - trial length (length of indexes of point events)
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
    % $Revision: 0.6 $  $Date: Mon 08/14/2023  4:47:14.137 PM $
    %
    % Rocky Creek Dr NE
    % Rochester, MN 55906
    % USA
    %
    % Email: richard.cui@utoronto.ca

    % ======================================================================
    % input parameters
    % ======================================================================
    arguments
        spktimes (:, 1) double {mustBeInteger, mustBeNonnegative} % spike time indexes
        num_trial (1, 1) double {mustBeInteger, mustBeNonnegative} % number of trials
        trl_length (1, 1) double {mustBeInteger, mustBeNonnegative} % length of the signal
        win_width (1, 1) double {mustBeInteger, mustBeNonnegative} % width of the moving window
        win_step (1, 1) double {mustBeInteger, mustBeNonnegative} % step of the moving window
    end

    % ======================================================================
    % main body
    % ======================================================================
    spk_yn = pointtime2yn(spktimes, num_trial, trl_length);

    [win_centers, spk_rate, rate_mean, rate_sem] ...
        = NoneParaMovingWindowEst(spk_yn, win_width, win_step);

end % function estFixSpot

% ==========================================================================
% subroutines
% ==========================================================================

% [EOF]

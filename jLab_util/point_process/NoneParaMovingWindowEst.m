function [win_centers, sess_rate, rate_mean, rate_sem] = NoneParaMovingWindowEst(pointyn, win_width, win_step)
% ESTIMATEMICROSACCADERATE estimates rates of a point process using
%       non-parametric moving window approach
%
% Syntax:
%   [win_centers, sess_rate, rate_mean, rate_sem] = NoneParaMovingWindowEst(pointyn, win_width, win_step)
% 
% Input(s):
%   pointyn     - Point Y/N information. rows = trials/channles, col
%                 = time instance, if 1 means a point event and 0 means no
%                 point event
%   win_width   - moving window width (unit same as pointyn)
%   win_step    - step for moving the window (unit same as pointyn)
%
% Output(s):
%   win_centers - moving window centers (unit samples)
%   sess_rate   - rate of each session
%   rate_mean   - estimated mean point rate at each window 
%                 (unit - number of points per sample)
%   point_sem   - estimated standard error of point rate
%
% Example:
% 
% Reference:
%
% See also LocfitEst.

% Copyright 2012-2015 Richard J. Cui. Created: Sun 06/24/2012  9:08:16.358 PM
% $Revision: 0.5 $  $Date: Wed 04/29/2015 10:40:06.312 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% input parameters
% =========================================================================

% =========================================================================
% main body
% =========================================================================
[num_sess, SigLen] = size(pointyn);
[win_centers, numwin] = estmovingwin(win_width, win_step, SigLen);

% estimate rate window by window
sess_rate = zeros(num_sess, numwin);
rate_mean = zeros(1, numwin);
rate_sem = zeros(1, numwin);
for k = 1:numwin
    winstart_k = (k-1)* win_step + 1;
    blk_k = pointyn(:, winstart_k:(winstart_k + win_width - 1));
    rate_k = sum(blk_k, 2) / win_width;
    sess_rate(:, k) = rate_k;
    rate_mean(k) = mean(rate_k);
    rate_sem(k) = std(rate_k)/sqrt(num_sess);
end % for

end % function estFixSpot

% ======================
% subroutines
% ======================

% [EOF]

function [us_start12_yn, us_end12_yn, us_start23_yn, us_end23_yn] = get_1trial_usyn(cycleidx, condidx, enum, grattime, NumberCondition, ...
    CondInCycle, trialMatrix, usacc_props)
% GET_1TRIAL_USYN (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 10/30/2012  1:48:21.516 PM
% $Revision: 0.1 $  $Date: 10/30/2012  1:48:21.516 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

[us_start12_times, us_end12_times, us_start23_times, us_end23_times, ...
    start12, end12, start23, end23] = MSaccContrast.get_1trial_ustime(cycleidx, condidx, trialMatrix, ...
    NumberCondition, CondInCycle, grattime, enum, usacc_props);

us_start12_yn = false(1, end12 - start12 + 1);
us_end12_yn = false(1, end12 - start12 + 1);

us_start23_yn = false(1, end23 - start23 + 1);
us_end23_yn = false(1, end23 - start23 + 1);

if ~isempty(us_start12_times)
    idx = us_start12_times - start12 + 1;
    us_start12_yn(idx) = true;
end % if

if ~isempty(us_end12_times)
    idx = us_end12_times - start12 + 1;
    us_end12_yn(idx) = true;
end % if

if ~isempty(us_start23_times)
    idx = us_start23_times - start23 + 1;
    us_start23_yn(idx) = true;
end % if

if ~isempty(us_end23_times)
    idx = us_end23_times - start23 + 1;
    us_end23_yn(idx) = true;
end % if

end % function get_1trial_usyn

% [EOF]

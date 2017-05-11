function result_dat = UsaccTriggered2ndPeakAnalysis(current_tag, name, S, dat)
% USACCTRIGGERED2NDPEAKANALYSIS Analysis of 2nd peak of MS-triggered response of individual cell
% 
% Description:
%   This function analyzes the first peak after MS-onset of the
%   MS-triggered response.
% 
% Syntax:
%   result_dat = PMT1(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Tue 03/05/2013  4:34:29.197 PM
% $Revision: 0.1 $  $Date: Tue 03/05/2013  4:34:29.197 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    % choose data source format
    opt.spkrate_diff = {{'0', '{1}'}, 'Spike Rate Difference'};
    opt.Spike_rate_diff_options.s1 = {[-150 0] 'Baseline interval (ms)' [-500 0]};   % for sustained response 1
    
    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    
    dat_var = { 'UsaccTriggeredContrastResponse'};
    result_dat = dat_var;
    
    return
end % if

% =========================================================================
% Data processing
% =========================================================================
% options and paras
% ------------------
spkdiff_flag = S.Stage_2_Options.UsaccTriggered2ndPeakAnalysis_options.spkrate_diff;
intv_s1 = S.Stage_2_Options.UsaccTriggered2ndPeakAnalysis_options.Spike_rate_diff_options.s1;

% get data
% --------
time = dat.UsaccTriggeredContrastResponse.SpikeRateWinCenter;   % center of windows
spk  = dat.UsaccTriggeredContrastResponse.SpikeRate;            % averaged spike rate at each contrast: levels x signal
pre_ms = dat.UsaccTriggeredContrastResponse.Paras.PreMSIntv;    % time length before MS

% analysis
% ---------
% spike rate
Pmt2.SpikeRate = spk;

% response of spike rate difference 
if spkdiff_flag
    base_idx = (time >= intv_s1(1) + pre_ms ) & (time <= intv_s1(2) + pre_ms);
    smt1 = mean(spk(:, base_idx), 2);
    spkdiff = spk - repmat(smt1, [1, size(spk, 2)]);
    Pmt2.SpikeRateDiff = spkdiff;
end % if

% =====================
% commit results
% =====================

result_dat.UsaccTriggered2ndPeak = Pmt2;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================

% [EOF]

function result_dat = UsaccAmplitudeDistributionTest(current_tag, name, S, dat)
% USACCAMPLITUDEDISTRIBUTIONTEST Statistic test of the distribution of microsaccade amplitudes
%
% Description:
%   This function tests the hypothesis of the distribution of MS amplitude,
%   which can be used to check the quality of the eye signals in cell and
%   data selection.
% 
% Syntax:
%   result_dat = UsaccAmplitudeDistributionTest(current_tag, name, S, dat)
% 
% Input(s):
%   current_tag
%   name            - session names
%   S               - structure of options
%   dat             - data
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also fitdata.

% Copyright 2012 Richard J. Cui. Created: Tue 10/23/2012 11:23:57.393 AM
% $Revision: 0.1 $  $Date: Tue 10/23/2012 11:23:57.393 AM$
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
    
    opt.number_of_bins = {50 '' [1 1000]};
    opt.distribution_test_alpha = {0.05 '' [0 1]};
    opt.show_check_plot = { {'0','{1}'} };
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'enum', 'left_usacc_props'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the data
% ------------
enum = dat.enum;
usacc_props = dat.left_usacc_props;
% number of bins of histogram
nbins = S.Stage_2_Options.UsaccAmplitudeDistributionTest_options.number_of_bins;

% get usacc amplitude
% -------------------
conditions = usacc_props(:, enum.usacc_props.condition);
% use all microsaccades in the trials
usacc_amp = usacc_props(conditions > 0, enum.usacc_props.magnitude);

% fit the distribution
% ---------------------
distribution = 'Ex-gaussian';
fitParams = fitdata(usacc_amp, distribution, nbins);

% test the distribution
% ---------------------
alpha = S.Stage_2_Options.UsaccAmplitudeDistributionTest_options.distribution_test_alpha;
[h, p] = kstest(usacc_amp, [usacc_amp, exgausscdf(usacc_amp, fitParams)], alpha, 0);

% check print / plot
% -------------------
fprintf('Komogrov-Smirnov test: h = %g, p = %0.6f\n', h, p)
if S.Stage_2_Options.UsaccAmplitudeDistributionTest_options.show_check_plot
    [n, xout] = hist(usacc_amp, nbins);
    y = exgausspdf(xout, fitParams);
    figure
    bar(xout, n/sum(n), 1)
    hold on
    plot(xout, y/sum(y), 'r')
    xlabel('Amplitude (deg)')
    ylabel('Percent')
end % if

% ++++++++++++++++++++++++
% commit results
% ++++++++++++++++++++++++
result_dat.UsaccAmpDisTest.Distribution = distribution;
result_dat.UsaccAmpDisTest.FitParameters = fitParams;
result_dat.UsaccAmpDisTest.pValue = p;

end % function CheckCellFRChange


% ====================================
% subroutines
% ====================================

% [EOF]
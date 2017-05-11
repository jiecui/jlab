function result_dat = AggUsaccAmpDisTest(current_tag, name, S, dat)
% AGGUSACCAMPDISTEST Analysis of the results of MS amplitude tests
% 
% Description:
%   This function analyzes the results obtained and aggregated from function
%   UsaccAmplitudeDistributionTest, which tests the MS amplitude of
%   individual session.
% 
% Syntax:
%   result_dat = AggUsaccAmpDisTest(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also UsaccAmplitudeDistributionTest.

% Copyright 2012 Richard J. Cui. Created: Thu 08/16/2012  6:16:26.422 PM
% $Revision: 0.1 $  $Date: Thu 08/16/2012  6:16:26.422 PM $
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
    
    opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'UsaccAmpDisTest', 'sessions' };
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% -------------
% get the data
% -------------
bnames = dat.sessions;          % block names
amp_dis = dat.UsaccAmpDisTest;  % amplitude distribution

% p-value index
% --------------------
N = length(bnames);
pv = zeros(N, 1);   % p-values
for k = 1:N
    pv(k) = amp_dis{k}.pValue;
end % for

[sorted_pv, idx] = sort(pv);
sorted_bnames = bnames(idx);

% -----------------------------------
% plot check points
% -----------------------------------
for k = 1:N
    fprintf('%s: %0.10f\n', sorted_bnames{k}, sorted_pv(k));
end % for

figure
semilogy(sorted_pv,'o-')
xlim([1 N])
xlabel('Blocks')
ylabel('log(p)')

% =====================
% commit results
% =====================
result_dat.SortedPValue = sorted_pv;
result_dat.SortedSessName = sorted_bnames;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================


% [EOF]
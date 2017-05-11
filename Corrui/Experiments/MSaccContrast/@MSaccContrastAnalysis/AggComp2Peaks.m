function result_dat = AggComp2Peaks(current_tag, sname, S, dat)
% AGGCOMP2PEAKS Compares peaks in two conditions
%
% Syntax:
%   result_dat = AggComp2Peaks(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Wed 08/20/2014  3:35:22.367 PM
% $Revision: 0.1 $  $Date: Wed 08/20/2014  3:35:22.367 PM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters
% =========================================================================
if strcmpi(current_tag,'get_options')
    opt.Max_average_response_options.pk_intv = {[50 100] 'Peak interval from MS-onset (ms)' [-1000, 1000]};
    opt.Compare_two_conditions.vn_cond1 = { 'SpikeRateLargeAmp', 'Variable name of condition 1'};
    opt.Compare_two_conditions.vn_cond2 = { 'SpikeRateSmallAmp', 'Variable name of condition 2'};
    
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    % dat_var = { 'UsaccTriggeredSpikeRate'};
    % result_dat = dat_var;
    
    result_dat = [];
    return
end % if


% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------
pk_intv             = S.Stage_2_Options.([mfilename, '_options']).Max_average_response_options.pk_intv;
vn_cond1            = S.Stage_2_Options.([mfilename, '_options']).Compare_two_conditions.vn_cond1;
vn_cond2            = S.Stage_2_Options.([mfilename, '_options']).Compare_two_conditions.vn_cond2;

% processing peak values
% -----------------------
curr_exp = CorrGui.CheckTag(current_tag);
[pk_mean, pk_err] = MaxAvgResp(curr_exp, vn_cond1, vn_cond2, pk_intv, sname);

% regression and check
% --------------------
cont = (0:10:100)';     % contrast level
pk_mean = pk_mean(:);
[fo, gof] = fit(cont, pk_mean * 1000, 'poly1');    % linear fit
% check image
figure
errorbar(cont, pk_mean * 1000, pk_err * 1000, 'o')
hold on
plot(fo)
disp(gof)

% =========================================================================
% commit results
% =========================================================================
result_dat.MSTrigCompPeak.PeakMean = pk_mean;
result_dat.MSTrigCompPeak.PeakSEM  = pk_err;
result_dat.MSTrigCompPeak.RSquare  = gof.rsquare;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [pk_mean, pk_err] = MaxAvgResp(curr_exp, dat_var1, dat_var2, pk_intv, sname)

data = curr_exp.db.Getsessvars(sname, {dat_var1});
sr1 = data.(dat_var1);

data = curr_exp.db.Getsessvars(sname, {dat_var2});
sr2 = data.(dat_var2);

sr = sr1 - sr2;

dat_vars = {'SpikeRateWinCenter' 'PreMSIntv'};
data = curr_exp.db.Getsessvars(sname, dat_vars);
time = data.SpikeRateWinCenter;

pre_ms = data.PreMSIntv;
pk_time = pk_intv + pre_ms;

[pk_mean, pk_err] = getPeakValueSpk(time, sr, pk_time);

end

function [pk_mean, pk_err] = getPeakValueSpk(time, sr, pk_intv)
% estimate peak value using spike rate 
% 
% inputs:
%   time 
%   sr    - spike rate levels x signals x cells
%   pk_intv   - interval to deteck peak

L = size(sr, 1);        % number of contrast levels
N = size(sr, 3);                    % number of cells
sr_mean = squeeze(mean(sr, 3));     % average across cells
sr_sem  = squeeze(std(sr, [], 3)) / sqrt(N);

pk_idx = time >= pk_intv(1) & time <= pk_intv(2);
srpk_mean = sr_mean(:, pk_idx);
srpk_sem  = sr_sem(:, pk_idx);
[~, p] = max(srpk_mean, [], 2);

pk_mean = zeros(L, 1);
pk_err  = zeros(L, 1);
for k = 1:L
    pk_mean(k) = srpk_mean(k, p(k));
    pk_err(k)  = srpk_sem(k, p(k));
end % for


end % function


% [EOF]

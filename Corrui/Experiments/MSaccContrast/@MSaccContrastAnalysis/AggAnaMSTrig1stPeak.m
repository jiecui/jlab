function result_dat = AggAnaMSTrig1stPeak(current_tag, sname, S, dat)
% AGGANAMSTRIG1STPEAK Analysis of Pmt1 of MS-triggered responses in aggregated session
% 
% Description:
%   This function analyzes 1st peak of MS-triggered responses in the aggregated
%   data set.
%
% Syntax:
%   result_dat = AggPMT1Analysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2013-2014 Richard J. Cui. Created: Mon 03/04/2013  3:46:02.916 PM
% $Revision: 0.3 $  $Date: Tue 08/19/2014  3:47:51.746 PM $
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
    opt.signal_type = {'Spike rate|{Spike rate normalized}', 'Signal type'};
    opt.pk_detect_method = { {'{Max average response}' 'Max cell response'} };
    opt.Max_average_response_options.pk_intv = {[50 100] 'Peak interval from MS-onset (ms)' [-1000, 1000]};
    
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
signal_type         = S.Stage_2_Options.([mfilename, '_options']).signal_type;
pk_detect_method    = S.Stage_2_Options.([mfilename, '_options']).pk_detect_method;
pk_intv             = S.Stage_2_Options.([mfilename, '_options']).Max_average_response_options.pk_intv;

% processing peak values
% -----------------------
curr_exp = CorrGui.CheckTag(current_tag);
switch signal_type
    case 'Spike rate'
        switch pk_detect_method
            case 'Max average response'                
                dat_var = 'SpikeRate';
            case 'Max cell response'
                error('not work yet')
        end % switch
    case 'Spike rate normalized'
        switch pk_detect_method
            case 'Max average response'
                dat_var = 'SpikeRate_Norm';
            case 'Max cell response'
                error('not work yet')
        end % switch
end % switch
[pk_mean, pk_err] = MaxAvgResp(curr_exp, dat_var, pk_intv, sname);

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
result_dat.MSTrig1stPeak.PeakMean = pk_mean;
result_dat.MSTrig1stPeak.PeakSEM  = pk_err;
result_dat.MSTrig1stPeak.RSquare  = gof.rsquare;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [pk_mean, pk_err] = MaxAvgResp(curr_exp, dat_var, pk_intv, sname)

data = curr_exp.db.Getsessvars(sname, {dat_var});
sr = data.(dat_var);

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

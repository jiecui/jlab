function result_dat = AggAnaMSTrig1stTrough(current_tag, sname, S, dat)
% AGGANAMSTRIG1STTROUGH Analysis of 2nd peak of MS-triggered responses in aggregated session
% 
% Description:
%   This function analyzes 2nd peak of MS-triggered responses in the aggregated
%   data set.
%
% Syntax:
%   result_dat = AggUsaccTriggered1stTroughAnalysis(current_tag, sname, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Mon 03/04/2013  3:46:02.916 PM
% $Revision: 0.1 $  $Date: Mon 03/04/2013  3:46:02.916 PM $
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
if strcmpi(current_tag,'get_options')
    opt.signal_type = {'Spike rate|{Spike rate normalized}', 'Signal type'};
    opt.th_detect_method = { {'{Min average response}' 'Min cell response'} };  % th - trough
    opt.Min_average_response_options.th_intv = {[50 150] 'Trough interval from MS-onset (ms)' [-1000, 1000]};
        
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
signal_type = S.Stage_2_Options.([mfilename, '_options']).signal_type;
th_detect_method = S.Stage_2_Options.([mfilename, '_options']).th_detect_method;

% processing
% -------------
curr_exp = CorrGui.CheckTag(current_tag);
switch signal_type
    case 'Spike rate'
        switch th_detect_method
            case 'Min average response'
                th_intv = S.Stage_2_Options.([mfilename, '_options']).Min_average_response_options.th_intv;
                dat_var = 'SpikeRate';
                [th_mean, th_err] = MinAvgResp(curr_exp, dat_var, th_intv, sname);
            case 'Min cell response'
                error('not work yet')
        end % switch
    case 'Spike rate normalized'
        switch th_detect_method
            case 'Min average response'
                th_intv = S.Stage_2_Options.([mfilename, '_options']).Min_average_response_options.th_intv;
                dat_var = 'SpikeRate_Norm';
                [th_mean, th_err] = MinAvgResp(curr_exp, dat_var, th_intv, sname);
            case 'Min cell response'
                error('not work yet')
        end % switch
end % switch

% regression and check
% --------------------
cont = (0:10:100)';     % contrast level
th_mean = th_mean(:);
[fo, gof] = fit(cont, th_mean, 'poly1');    % linear fit
% check image
figure
errorbar(cont, th_mean, th_err, 'o')
hold on
plot(fo)
disp(gof)

% =========================================================================
% commit results
% =========================================================================
result_dat.MSTrig1stTrough.TroughMean = th_mean;
result_dat.MSTrig1stTrough.TroughSEM  = th_err;
result_dat.MSTrig1stTrough.RSquare    = gof.rsquare;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [pk_mean, pk_err] = MinAvgResp(curr_exp, dat_var, pk_intv, sname)

data = curr_exp.db.Getsessvars(sname, {dat_var});
sr = data.(dat_var);

dat_vars = {'SpikeRateWinCenter' 'PreMSIntv'};
data = curr_exp.db.Getsessvars(sname, dat_vars);
time = data.SpikeRateWinCenter;

pre_ms = data.PreMSIntv;
pk_time = pk_intv + pre_ms;
[pk_mean, pk_err] = getTroughValueSpk(time, sr, pk_time);

end

function [pk_mean, pk_err] = getTroughValueSpk(time, sr, pk_intv)
% estimate trough value
% 
% inputs:
%   time 
%   sr    - data levels x signals x cells
%   pk_intv   - interval to deteck peak

L = size(sr, 1);        % number of contrast levels
N = size(sr, 3);                    % number of cells
sr_mean = squeeze(mean(sr, 3));     % average across cells
sr_sem  = squeeze(std(sr, [], 3)) / sqrt(N);

pk_idx = time >= pk_intv(1) & time <= pk_intv(2);
srpk_mean = sr_mean(:, pk_idx);
srpk_sem  = sr_sem(:, pk_idx);
[~, p] = min(srpk_mean, [], 2);

pk_mean = zeros(L, 1);
pk_err  = zeros(L, 1);
for k = 1:L
    pk_mean(k) = srpk_mean(k, p(k));
    pk_err(k)  = srpk_sem(k, p(k));
end % for


end % function


% [EOF]

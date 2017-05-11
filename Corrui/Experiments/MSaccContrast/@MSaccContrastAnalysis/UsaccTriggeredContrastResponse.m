function result_dat = UsaccTriggeredContrastResponse(current_tag, name, S, dat)
% USACCTRIGGEREDCONTRASTRESPONSE Individual cell MS-triggered response at different contrast level
% 
% Description:
%   This function calculates MS-triggered response of individual cell.  The
%   results are averaged spike rage at each contrast level.  The averaged
%   spike rate can be either absolute spike rates or normalized one,
%   according to the choices.
% 
% Syntax:
%   result_dat = UsaccTriggeredContrastResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
% 
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Mon 06/18/2012  5:23:49.112 PM
% $Revision: 0.8 $  $Date: Wed 04/17/2013  2:58:40.315 PM $
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
    opt.data_format = {'tri-stages|{paired-stages}','Choose data format'};
    
    % paras for cutting usacc segment
    opt.post_onset_int = {300 'Post-contrast-onset interval (ms)' [0 1300]};   % post onset interval - time after contrast onset during which the usaccs are not selected
    opt.pre_ms_int = {175 'Pre-MS interval (ms)' [0 1300]};     % pre-microsaccade interval - time interval examined before a usacc
    opt.post_ms_int = {375 'Post-MS interval (ms)' [0 1300]};   % post-microsaccade interval - time interval examined after a usacc
    
    % paras for cal. firing rate
    opt.win_width = {30 'Moving-win width (ms)' [1 1000]};      % moving window width
    opt.win_step = {5 'Moving-win step (ms)' [1 1000]};         % moving window step
    
    % opts for choosing methos of estimating firing rate
    opt.fr_method = { {'Chronux' '{PSTH}'}, 'Firing rate estimation method' };
    
    % opts for choosing normalization methods
    opt.norm_method = { {'{Firing rate difference}' 'Percentage change'}, 'Choose normalization method' }; 
    opt.norm_options.smt1_interval = {[-150 0] 'Smt1 interval (ms)' [-1000 0]};  % time relative to MS-onset, ms-onset = zero
    opt.norm_options.pmt1_interval = { [0 100] 'Pmt1 interval (ms)' [0 1000] };  % time relative to MS-onset, ms-onset = zero
    
    result_dat = opt;
    return
end % if


% =========================================================================
% Load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    data_format = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.data_format; 

    switch data_format
        case 'tri-stages'
            dat_var = { 'grattime', 'SpikeYN', 'AllUsacc', 'TrialTime'};
            result_dat = dat_var;
        case 'paired-stages'
            dat_var = { 'grattime', 'Left_UsaccXCond23_Start', ...
                        'Left_UsaccXCond23_end', 'FiringXCond23', 'NumberCycle'};
            result_dat = dat_var;
    end % switch
    
    return
end % if

% =========================================================================
% Data processing
% =========================================================================
% options and paras
data_format = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.data_format; 

grattime = dat.grattime;
post_onset = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.post_onset_int;
pre_ms = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.pre_ms_int;
post_ms = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.post_ms_int;
win_width = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.win_width;
win_step = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.win_step;

paras.grattime = grattime;
paras.post_onset = post_onset;
paras.pre_ms = pre_ms;
paras.post_ms = post_ms;
paras.win_width = win_width;
paras.win_step = win_step;

fr_method = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.fr_method;     % method for estimating firing rate

norm.method = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.norm_method; % method for normalization
norm.smt1_interval = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.norm_options.smt1_interval;
norm.pmt1_interval = S.Stage_2_Options.UsaccTriggeredContrastResponse_options.norm_options.pmt1_interval;

% process
switch data_format
    case 'tri-stages'
        utcresp = MSaccContrastAnalysis.UsaccTriggeredContrastResponse_3stages(dat, paras);

    case 'paired-stages'
        utcresp = MSaccContrastAnalysis.UsaccTriggeredContrastResponse_2stages(dat, paras, fr_method, norm);
        
end

                   
% =====================
% commit results
% =====================

result_dat.UsaccTriggeredContrastResponse = utcresp;

end % function StepContrastAnalysis

% =====================
% subroutines
% =====================

% [EOF]

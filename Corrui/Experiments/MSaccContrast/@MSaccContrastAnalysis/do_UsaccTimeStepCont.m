function result_dat = do_UsaccTimeStepCont(current_tag, name, S, dat)
% DO_USACCTIMESTEPCONT Microsaccadic times of cell in response to step-contrast change
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

% Copyright 2014 Richard J. Cui. Created: 10/26/2012 10:47:19.522 AM
% $Revision: 0.2 $  $Date: Fri 03/07/2014  5:16:01.434 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%% ========================================================================
% Options of analysis
% =========================================================================
if strcmpi(current_tag,'get_options')
    %     opt.tfmethod = {'{affine}|lwm'};
    %     opt.Latency = {30 '* (ms)' [0 1000]};
    %     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
    %         % outside the fix grid more than SMThres * STDs will be discarded
    %     opt.normalized_spike_map = { {'{0}','1'} };
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};

    opt.Which_Eye_to_Use = {'{Left}|Right|Both', 'Which eye to use'};
    opt.Check_time = {1300 'Check time (ms)' [1 1300]};
    result_dat = opt;
    return
end % if

%% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'enum' 'trialMatrix' 'grattime' 'NumberCondition'...
                'NumberCycle' 'CondInCycle' 'left_usacc_props' 'right_usacc_props'};
    result_dat = dat_var;
    return
end % if

%% ========================================================================
% get the data
% =========================================================================
% grattime    = dat.grattime;   % H12A06B = 2000;
ncond       = dat.NumberCondition;
ncycle      = dat.NumberCycle;
enum        = dat.enum;
condcyc     = dat.CondInCycle;
trialmax    = dat.trialMatrix;
lusacc      = dat.left_usacc_props;
rusacc      = dat.right_usacc_props;

%% ========================================================================
% The analysis
% =========================================================================
grattime    = S.Stage_2_Options.([mfilename '_options']).Check_time;
eye_choice  = S.Stage_2_Options.([mfilename '_options']).Which_Eye_to_Use;

left_uxcr12_start   = [];
left_uxcr12_end     = [];
right_uxcr12_start  = [];
right_uxcr12_end    = [];
left_uxcr23_start   = [];
left_uxcr23_end     = [];
right_uxcr23_start  = [];
right_uxcr23_end    = [];

switch eye_choice
    case 'Left'
        if ~isempty(lusacc)
            [left_uxcr12_start, left_uxcr12_end, left_uxcr23_start, left_uxcr23_end]...
                = MSaccContrastAnalysis.UsaccXContrastCondition(ncond, ncycle, grattime, lusacc,...
                condcyc, trialmax, enum);
        else
            error('MSaccContrastAnalysis:do_UsaccTimeStepCont:noLeftUsacc', ...
                'No left microsaccade can be found')
        end % if
    case 'Right'
        if ~isempty(rusacc)
            [right_uxcr12_start, right_uxcr12_end, right_uxcr23_start, right_uxcr23_end]...
                = MSaccContrastAnalysis.UsaccXContrastCondition(ncond, ncycle, grattime, rusacc,...
                condcyc, trialmax, enum);
        else
            error('MSaccContrastAnalysis:do_UsaccTimeStepCont:noRightUsacc', ...
                'No right microsaccade can be found')            
        end % if
    case 'Both'
        if ~(isempty(lusacc) || isempty(rusacc))
            [left_uxcr12_start, left_uxcr12_end, left_uxcr23_start, left_uxcr23_end]...
                = MSaccContrastAnalysis.UsaccXContrastCondition(ncond, ncycle, grattime, lusacc,...
                condcyc, trialmax, enum);
            [right_uxcr12_start, right_uxcr12_end, right_uxcr23_start, right_uxcr23_end]...
                = MSaccContrastAnalysis.UsaccXContrastCondition(ncond, ncycle, grattime, rusacc,...
                condcyc, trialmax, enum);
        else
            error('MSaccContrastAnalysis:do_UsaccTimeStepCont:noLeftRightUsacc', ...
                'Either left or right or both microsaccade can be found')                        
        end % if
end % switch

%% ========================================================================
% Commit
% =========================================================================
switch eye_choice
    case 'Left'
        result_dat.Left_UsaccXCond12_Start    = left_uxcr12_start;
        result_dat.Left_UsaccXCond12_end      = left_uxcr12_end;
        result_dat.Left_UsaccXCond23_Start    = left_uxcr23_start;
        result_dat.Left_UsaccXCond23_end      = left_uxcr23_end;
    case 'Right'
        result_dat.Right_UsaccXCond12_Start   = right_uxcr12_start;
        result_dat.Right_UsaccXCond12_end     = right_uxcr12_end;
        result_dat.Right_UsaccXCond23_Start   = right_uxcr23_start;
        result_dat.Right_UsaccXCond23_end     = right_uxcr23_end;
    case 'Both'
        result_dat.Left_UsaccXCond12_Start    = left_uxcr12_start;
        result_dat.left_UsaccXCond12_end      = left_uxcr12_end;
        result_dat.Left_UsaccXCond23_Start    = left_uxcr23_start;
        result_dat.Left_UsaccXCond23_end      = left_uxcr23_end;

        result_dat.Right_UsaccXCond12_Start   = right_uxcr12_start;
        result_dat.Right_UsaccXCond12_end     = right_uxcr12_end;
        result_dat.Right_UsaccXCond23_Start   = right_uxcr23_start;
        result_dat.Right_UsaccXCond23_end     = right_uxcr23_end;        
end % switch

result_dat.UsaccXCondLength = 2 * grattime;

end % function FiringXContrastCondition

%% ========================================================================
% subroutines
% =========================================================================

% [EOF]

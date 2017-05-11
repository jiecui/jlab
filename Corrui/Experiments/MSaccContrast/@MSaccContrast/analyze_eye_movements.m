function  dat = analyze_eye_movements( this, sname, S,  import_variables)
% MSACCCONTRAST.ANALYZE_EYE_MOVEMENTS analysis of eye movement signals

% Copyright 2014-2016 Richard J. Cui. Created: 3/25/2014
% $Revision: 0.9 $  $Date: Tue 08/02/2016  4:19:59.328 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% This function is for Stage 1 processing

% =========================================================================
% Prepare
% =========================================================================
% get data
% --------
if ~exist('import_variables', 'var')
    import_variables = { 'samples' 'trialMatrix' 'isInTrial' 'isInTrialNumber' 'isInTrialCond' 'isInCycle'...
                         'isInTrialStage' 'blinkYesNo' 'samplerate' 'info' 'enum' 'trial_props'};
end % if
dat = this.db.getsessvars( sname, import_variables );

% events of eye movement objects
% ------------------------------
exp_ms = this.Usacc(sname);     % MSCUsacc(sname);
exp_sa = this.Sacc(sname);      % MSCSacc(sname);
exp_bk = this.Blink(sname);     % MSCBlink(sname);
exp_fx = this.Fixation(sname);  % MSCFixation(sname);
exp_df = this.Drift(sname);     % MSCDrift(sname);
exp_tr = this.Trial(sname);     % MSCTrial(sname)

% update enums
% --------------
dat.enum = get_enums( dat.enum );

dat.enum.usacc_props    = exp_ms.getEnum();
dat.enum.saccade_props  = exp_sa.getEnum();
dat.enum.blink_props    = exp_bk.getEnum();
dat.enum.fixation_props = exp_fx.getEnum();
dat.enum.trial_props    = exp_tr.getEnum();
dat.enum.driftdat       = DriftAlgorithmAbstract.getEnum();
dat.enum.drift_props    = exp_df.getEnum;
enum = dat.enum;

this.enum = enum;

% construct the data type of eye samples
% ----------------------------------------
% (a) The unit of the eye samples should be in dva and (b) the origin of
% the coordinate should be at the center of the diaplay
samples = array2table(dat.samples);
samples.Properties.VariableNames = {'Timestamps', 'LeftX', 'LeftY', 'RightX', 'RightY'};

% get options
% -----------
stage1_opt = S.Stage_1_Options;

% =========================================================================
% Estimate Eye Events
% =========================================================================
cprintf('Text', 'Analyze eye movements...\n')

% ---------------
% estimation
% ---------------
[samples, samples_org, eye_events] = ...
    this.estimate_eye_events(samples, dat.samplerate, dat.isInTrial, dat.blinkYesNo, stage1_opt);

dat.samples = table2array(samples);
if stage1_opt.Low_pass_filter == true || stage1_opt.Wavelet_Filter == true
    dat.samples_org = table2array(samples_org);     % original
end % if

% convert table to arrays for MS-contrast experiments
% ---------------------------------------------------
eye_events = msc_tables2arrays(samples, eye_events);

% -------------------------
% properties of eye events
% -------------------------
[LEFT, RIGHT] = getWhichEye(samples);
% left eye 
if LEFT == true
    dat.left_eyedat         = eye_events.eyedat.Left;
    dat.left_monoculars     = eye_events.monoculars.Left;
    dat.left_overshoots     = eye_events.overshoots.Left;
    dat.left_usacc_props    = exp_ms.getprops(eye_events.usacc_props.Left, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.left_saccade_props  = exp_sa.getprops(eye_events.saccade_props.Left, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.left_blink_props    = exp_bk.getprops(eye_events.blink_props.Left, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.left_fixation_props = exp_fx.getprops(eye_events.fixation_props.Left, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.left_drift_props    = exp_df.getprops(eye_events.drift_props.Left, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.left_eyeflags       = eye_events.eyeflags.Left;
end % if
% right eye
if RIGHT == true
    dat.right_eyedat        = eye_events.eyedat.Right;
    dat.right_monoculars    = eye_events.monoculars.Right;
    dat.right_overshoots    = eye_events.overshoots.Right;
    dat.right_usacc_props   = exp_ms.getprops(eye_events.usacc_props.Right, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.right_saccade_props = exp_sa.getprops(eye_events.saccade_props.Right, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.right_blink_props   = exp_bk.getprops(eye_events.blink_props.Right, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.right_fixation_props = exp_fx.getprops(eye_events.fixation_props.Right, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.right_drift_props   = exp_df.getprops(eye_events.drift_props.Right, dat.isInTrialNumber, dat.isInTrialCond, dat.isInCycle, dat.isInTrialStage);
    dat.right_eyeflags      = eye_events.eyeflags.Right;
end % if

% =========================================================================
% other information
% =========================================================================
% update trial props according to eye movement
% --------------------------------------------
if LEFT == true && RIGHT == true
    dat.trial_props = exp_tr.getprops( dat.trialMatrix, dat.samplerate, dat.left_fixation_props, dat.right_fixation_props, dat.enum);
elseif LEFT == true
    dat.trial_props = exp_tr.getprops( dat.trialMatrix, dat.samplerate, dat.left_fixation_props, [], dat.enum);
elseif RIGHT == true
    dat.trial_props = exp_tr.getprops( dat.trialMatrix, dat.samplerate, [], dat.right_fixation_props, dat.enum);
end

% =========================================================================
% subroutines
% =========================================================================
function events_array = msc_tables2arrays(eye_samples, eye_events)
% convert table to arrays for MS-contrast experiments

[LEFT, RIGHT] = getWhichEye(eye_samples);

fnames = fieldnames(eye_events);
num_events = numel(fnames);
for k = 1:num_events
    event_k = fnames{k};
    if LEFT
        event_left  = table2array(eye_events.(event_k).Left);
    else
        event_left = [];
    end % if
    if RIGHT
        event_right = table2array(eye_events.(event_k).Right);
    else
        event_right = [];
    end % if
    switch event_k
        case 'eyeflags'
            events_array.(event_k).Left  = logical(event_left);
            events_array.(event_k).Right = logical(event_right);            
        otherwise
            events_array.(event_k).Left  = event_left;
            events_array.(event_k).Right = event_right;
    end % switch
end % for

% if LEFT
%     left_eyedat         = table2array(eye_events.eyedat.Left); % **
%     left_overshoots     = table2array(eye_events.overshoots.Left);
%     left_monoculars     = table2array(eye_events.monoculars.Left);
%     left_usacc_props    = table2array(eye_events.usacc_props.Left);
%     left_saccade_props  = table2array(eye_events.saccade_props.Left);
%     left_eyeflags       = logical(table2array(eye_events.eyeflags.Left));
%     left_fixation_props = table2array(eye_events.fixation_props.Left);
%     left_blink_props    = table2array(eye_events.blink_props.Left);
%     left_drift_props    = table2array(eye_events.drift_props.Left);
% else
%     left_eyedat = [];
%     left_overshoots = [];
%     left_monoculars = [];
%     left_usacc_props = [];
%     left_saccade_props = [];
%     left_eyeflags = [];
%     left_fixation_props = [];
%     left_blink_props = [];    
% end % if
% if RIGHT
%     right_eyedat        = table2array(eye_events.eyedat.Right); % **
%     right_overshoots    = table2array(eye_events.overshoots.Right);
%     right_monoculars    = table2array(eye_events.monoculars.Right);
%     right_usacc_props   = table2array(eye_events.usacc_props.Right);
%     right_saccade_props = table2array(eye_events.saccade_props.Right);
%     right_eyeflags      = logical(table2array(eye_events.eyeflags.Right));
%     right_fixation_props= table2array(eye_events.fixation_props.Right);
%     right_blink_props   = table2array(eye_events.blink_props.Right);
%     right_drift_props   = table2array(eye_events.drift_props.Right);
% else
%     right_eyedat = [];
%     right_overshoots = [];
%     right_monoculars = [];
%     right_usacc_props = [];
%     right_saccade_props = [];
%     right_eyeflags = [];
%     right_fixation_props = [];
%     right_blink_props = [];    
% end % if
% 
% eyedat.Left     = left_eyedat;
% eyedat.Right    = right_eyedat;
% 
% monoculars.Left  = left_monoculars;
% monoculars.Right = right_monoculars;
% 
% overshoots.Left  = left_overshoots;
% overshoots.Right = right_overshoots;
% 
% usacc_props.Left  = left_usacc_props;
% usacc_props.Right = right_usacc_props;
% 
% saccade_props.Left  = left_saccade_props;
% saccade_props.Right = right_saccade_props;
% 
% eyeflags.Left  = left_eyeflags;
% eyeflags.Right = right_eyeflags;
% 
% fixation_props.Left  = left_fixation_props;
% fixation_props.Right = right_fixation_props;
% 
% blink_props.Left = left_blink_props;
% blink_props.Right = right_blink_props;
% 
% drift_props.Left    = left_drift_props;
% drift_props.Right   = right_drift_props;
% 
% events_array.eyedat       = eyedat;
% events_array.monoculars   = monoculars;
% events_array.overshoots   = overshoots;
% events_array.usacc_props  = usacc_props;
% events_array.saccade_props = saccade_props;
% events_array.eyeflags     = eyeflags;
% events_array.fixation_props = fixation_props;
% events_array.blink_props= blink_props;


function enum = get_enums( enum )
enum.eyedat.x               = 1;
enum.eyedat.y               = 2;
enum.eyedat.vx              = 3;
enum.eyedat.vy              = 4;
enum.eyedat.accrho          = 5;
enum.eyedat.polar_vel       = 6;
enum.eyedat.turn            = 7;
enum.eyedat.turn_vel        = 8;
enum.eyedat.acceleration    = 9;

enum.eyeflags.good_sample   = 1;
enum.eyeflags.usacc         = 2;
enum.eyeflags.blink         = 3;
enum.eyeflags.saccade       = 4;
enum.eyeflags.drift         = 5;
enum.eyeflags.overshoot     = 6;
enum.eyeflags.monocular     = 7;
enum.eyeflags.swjusacc      = 8;    % swj in usacc

% [EOF]
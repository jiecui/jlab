function dat = analyze_eye_movements( this, sname, S,  import_variables)
% GFSMSACC.ANALYZE_EYE_MOVEMENTS identify the events of eye movements
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Wed 08/10/2016 11:00:23.856 AM
% $Revision: 0.1 $  $Date: Wed 08/10/2016 11:00:23.858 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Prepare
% =========================================================================
% get data
% --------
if ~exist('import_variables', 'var')
    import_variables = { 'EyesamplesSubjdisp' 'EyesamplesSubjnodisp' 'samplerate'};
end % if
dat = this.db.getsessvars( sname, import_variables );

% get options
% -----------
stage1_opt = S.Stage_1_Options;
stage1_opt.verbose = false;

% =========================================================================
% Estimate Eye Events
% =========================================================================
cprintf('Text', 'Analyze eye movements...\n')

% exp_trl = GMSTrial(this, sname);

[samples_subjdisp, samples_org_subjdisp, eye_events_subjdisp] = ...
    eye_events_cond(this, dat.EyesamplesSubjdisp, dat.samplerate, 'SubjDisp', stage1_opt);

[samples_subjnodisp, samples_org_subjnodisp, eye_events_subjnodisp] = ...
    eye_events_cond(this, dat.EyesamplesSubjnodisp, dat.samplerate, 'SubjNoDisp', stage1_opt);

% =========================================================================
% combine conditions and trials to save
% =========================================================================
dat_samples = combCondTrl(samples_subjdisp, samples_subjnodisp, 'samples');

if stage1_opt.Low_pass_filter == true || stage1_opt.Wavelet_Filter == true
    dat_samples_org = combCondTrl(samples_org_subjdisp, samples_org_subjnodisp, 'samples_org');
else
    dat_samples_org = [];
end % if

% eye events
% ---------
[LEFT, RIGHT] = getWhichEye(dat_samples.samples);
dat_events = combEyeEvents(LEFT, RIGHT, eye_events_subjdisp, eye_events_subjnodisp);

dat = mergestructs(dat_samples, dat_samples_org, dat_events);

% -------------------------------------------------------------------------
% summary of the detected eye events
% -------------------------------------------------------------------------
if LEFT == true
    lusac   = dat.left_usacc_props;
    lsacc   = dat.left_saccade_props;
    los     = dat.left_overshoots;
    lmon    = dat.left_monoculars;
    lblink  = dat.left_blink_props;
    lfix    = dat.left_fixation_props;
    ldrift  = dat.left_drift_props;
    
    num_lusac   = height(lusac);
    num_lswj    = sum(lusac.SWJPair == 1);    % number of swj pairs
    num_lsac    = height(lsacc);
    num_los     = height(los);
    num_lmon    = height(lmon);
    num_lbink   = height(lblink);
    num_lfix    = height(lfix);
    num_ldrift  = height(ldrift);
    
    fprintf(sprintf('  - LEFT: usacc(%d), usacc_swj(%d), saccade(%d), os(%d), mon(%d), blink(%d), fix(%d), drift(%d)\n',...
        num_lusac, num_lswj, num_lsac, num_los, num_lmon, num_lbink, num_lfix, num_ldrift));
end

if RIGHT == true
    rusac   = dat.right_usacc_props;
    rsacc   = dat.right_saccade_props;
    ros     = dat.right_overshoots;
    rmon    = dat.right_monoculars;
    rblink  = dat.right_blink_props;
    rfix    = dat.right_fixation_props;
    rdrift  = dat.right_drift_props;
    
    num_rusac   = height(rusac);
    num_rswj    = sum(rusac.SWJPair == 1);    % number of swj pairs
    num_rsac    = height(rsacc);
    num_ros     = height(ros);
    num_rmon    = height(rmon);
    num_rbink   = height(rblink);
    num_rfix    = height(rfix);
    num_rdrift  = height(rdrift);
    
    fprintf(sprintf('  - RIGHT: usacc(%d), usacc_swj(%d), saccade(%d), os(%d), mon(%d), blink(%d), fix(%d), drift(%d)\n',...
        num_rusac, num_rswj, num_rsac, num_ros, num_rmon, num_rbink, num_rfix, num_rdrift));
end

end % function analyze_eye_movements

% =========================================================================
% subroutines
% =========================================================================
function [left_trl, right_trl] = getEventTrl(ev, ev_name)

num_trl = numel(ev);
left_trl = cell(1, num_trl);
right_trl = cell(1, num_trl);
for k = 1:num_trl
    left_trl{k} = ev{k}.(ev_name).Left;
    right_trl{k} = ev{k}.(ev_name).Right;
end % for

end % function

function dat = combEyeEvents(LEFT, RIGHT, ev_subjdisp, ev_subjnodisp)

dat = [];

fnames = fieldnames(ev_subjdisp{1});
for k = 1:numel(fnames)
    dat_k = [];
    fn_k = fnames{k};
    
    % subjdisp
    [left_d_subjdisp_k, right_d_subjdisp_k] = getEventTrl(ev_subjdisp, fn_k);
    
    % subjnodisp
    [left_d_subjnodisp_k, right_d_subjnodisp_k] = getEventTrl(ev_subjnodisp, fn_k);
    
    % Left
    if LEFT
        left_dat_k = combCondTrl(left_d_subjdisp_k, left_d_subjnodisp_k, fn_k);
        dat_k.(['left_', fn_k])  = left_dat_k.(fn_k);
    end % if
    
    % Right
    if RIGHT
        right_dat_k = combCondTrl(right_d_subjdisp_k, right_d_subjnodisp_k, fn_k);
        dat_k.(['right_', fn_k]) = right_dat_k.(fn_k);
    end % if
    
    dat = mergestructs(dat, dat_k);
end % for

end % function

function dat = combTrl(dat_cond)

dat = table;
num_trl = numel(dat_cond);
for k = 1:num_trl
    dat_k = dat_cond{k};
    if ~isempty(dat_k)
        dat_k.Trial = ones(height(dat_k), 1) * k;
        dat = cat(1, dat, dat_k);
    end % if
end % for

end % function

function dat = combCondTrl(dat_subjdisp, dat_subjnodisp, dat_name)
% condition = 1, subjdisp
%             2, subjnodisp
%             3, physdisp

d_subjdisp = combTrl(dat_subjdisp);
d_subjdisp.Condition = ones(height(d_subjdisp), 1) * 1; % 1 = subjdisp

d_subjnodisp = combTrl(dat_subjnodisp);
d_subjnodisp.Condition = ones(height(d_subjnodisp), 1) * 2; % 2 = subjnodisp

if height(d_subjdisp) == 0 && height(d_subjnodisp) == 0
    dat.(dat_name) = table;
elseif height(d_subjdisp) == 0 && height(d_subjnodisp) > 0  
    dat.(dat_name) = d_subjnodisp;
elseif height(d_subjdisp) > 0 && height(d_subjnodisp) == 0
    dat.(dat_name) = d_subjdisp;
elseif height(d_subjdisp) > 0 && height(d_subjnodisp) > 0
    dat.(dat_name) = cat(1, d_subjdisp, d_subjnodisp);
end % if

end % function

function [samples, samples_org, eye_events] = eye_events_cond(this, samples_cond, samplerate, cond_str, opt)

[eye_samples, sig_len, num_trl] = prepEyeSamples(samples_cond);
isInTrial = true(sig_len, 1);

samples = cell(1, num_trl);
samples_org = cell(1, num_trl);
eye_events = cell(1, num_trl);

msg_str = sprintf('Condition %s', cond_str);
wh = waitbar(0, msg_str, 'Name', 'Analyze eye movements...');
for k = 1:num_trl
    waitbar(k/num_trl, wh, msg_str);
    
    eye_samples_k = eye_samples{k};
    [samples_k, samples_org_k, eye_events_k] = ...
        this.estimate_eye_events(eye_samples_k, samplerate, isInTrial, [], opt);
    samples{k} = samples_k;
    samples_org{k} = samples_org_k;
    eye_events{k} = eye_events_k;
end % for
delete(wh)

end % function

function [eye_samples, sig_len, num_trl] = prepEyeSamples(samples_cond)

[sig_len, num_trl] = size(samples_cond.x);
eye_samples = cell(1, num_trl);

var_names = {'Timestamps', 'LeftX', 'LeftY', 'RightX', 'RightY'};
for k = 1:num_trl
    x_k = samples_cond.x(:, k);
    y_k = samples_cond.y(:, k);
    s_k = [(1:sig_len)', x_k, y_k, NaN(sig_len, 2)];
    eye_samples{k} = array2table(s_k, 'VariableNames', var_names);
end % for

end % function

% [EOF]

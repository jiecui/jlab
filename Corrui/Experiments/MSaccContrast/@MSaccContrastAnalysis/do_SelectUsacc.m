function result_dat = do_SelectUsacc(current_tag, sname, S, ~) % dat)
% MSACCCONTRASTANALYSIS.DO_SELECTUSACC selects microsaccades for subsequent analysis 
%
% Syntax:
%   result_dat = do_SelectUsacc(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013-2014 Richard J. Cui. Created: Wed 04/24/2013 10:34:04.406 AM
% $Revision: 0.5 $  $Date: Mon 06/23/2014 11:43:07.467 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% Options of analysis
% =========================================================================
if strcmpi(current_tag,'get_options')
    % criteria for MS selection
    % which eye
    % ---------
    opt.eye_choise = {'{Left}|Right|Both', 'Which Eye'};    % both means MS 
            % are selected according to info from both eyes
            
    % MS onset
    % ---------
    opt.ms_onset = { {'All', 'Stage 2 onset to Stage 3 end', ...
                      'Stage 1 onset to Stage 2 end', ...
                      '{In Stage 2 / 3: 475 ms after Stage onset to 375 ms before Stage end}' },...
                      'MS onset criteria' };
    % MS end
    % ---------
    opt.ms_end = { {'{All}', 'Stage 2 onset to Stage 3 end'}, 'MS end criteria'};
    
    % MS direction
    % ------------
    opt.ms_dir = {{'{All}', 'Orthogonal to cell orientation', ...
                   'Parallel to cell orientation', 'Pair of angle and bin'}, ...
                   'Direction criteria' };
    opt.ms_dir_pair = {[0 30], 'Pair of angle and bin (dva)'};    % first: angle between dir checked and gb_dir, second: bin width in dva
    
    % MS magnitude
    % ------------
    opt.ms_mag = {{'{All}', '<= 0.3246 DVA', '>= 0.5075 DVA'}, 'Magnitude criteria'};
               
    % peak velocity
    % -------------
    opt.ms_pkv = { {'{All}' '0 - 100'}, 'Peak veolcity criteria (dva/s)' };
    
    % ISI - inter usacc interval
    % --------------------------
    opt.ms_isi = { {'{All}' 'both pre and post ISI <= 500'}, 'Inter microsaccade interval (ms)'};
    
    % MS SWJ options
    % --------------
    opt.Select_SWJ = { {'{0}', '1'}, 'Select SWJ' };
    opt.Select_SWJ_options.swj_type = { {'{All}', ...
        '1st in SWJ', ...
        '1st in SWJ and no MS 500 ms before and SWJ ISI <= 500', ...
        '2nd in SWJ',...
        '2nd in SWJ and no MS 500 ms before 1st in SWJ and SWJ ISI <= 500', ...
        'Exclude SWJ'}, ...
        'SWJ type' };
    
    result_dat = opt;
    return

end % if

% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    % vars = { ' samplerate' };
    
    result_dat = [];
    return
end % if

% =========================================================================
% get the data and options
% =========================================================================

% options
eye_choice  = S.Stage_2_Options.([mfilename, '_options']).eye_choise;
ms_onset    = S.Stage_2_Options.([mfilename, '_options']).ms_onset;
ms_end      = S.Stage_2_Options.([mfilename, '_options']).ms_end;
ms_dir      = S.Stage_2_Options.([mfilename, '_options']).ms_dir;
ms_dir_pair = S.Stage_2_Options.([mfilename, '_options']).ms_dir_pair;
ms_mag      = S.Stage_2_Options.([mfilename, '_options']).ms_mag;
ms_pkv      = S.Stage_2_Options.([mfilename, '_options']).ms_pkv;
ms_isi      = S.Stage_2_Options.([mfilename, '_options']).ms_isi;
Select_SWJ  = S.Stage_2_Options.([mfilename, '_options']).Select_SWJ;
swj_type    = S.Stage_2_Options.([mfilename, '_options']).Select_SWJ_options.swj_type;

% =========================================================================
% select usacc
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
MS = MSCUsacc(curr_exp, sname);    % construct usacc object
criteria.ms_onset       = ms_onset;
criteria.ms_end         = ms_end;
criteria.ms_dir         = ms_dir;
criteria.ms_dir_pair    = ms_dir_pair;
criteria.ms_mag         = ms_mag;
criteria.ms_pkv         = ms_pkv;
criteria.ms_isi         = ms_isi;
criteria.Select_SWJ     = Select_SWJ;
criteria.swj_type       = swj_type;

if strcmp(eye_choice, 'Left')
    ms_props = MS.left_usacc_props;
    selected_ms_props = selectMSSingleEye(curr_exp, ms_props, criteria, sname);
end % if

if strcmp(eye_choice, 'Right')
    ms_props = MS.left_usacc_props;
    selected_ms_props = selectMSSingleEye(curr_exp, ms_props, criteria, sname);    
end % if

if strcmp(eye_choice, 'Both')
    error('MSaccContrast:result_dat', 'Not impletmented yet.')
end % if

% =========================================================================
% Commit
% =========================================================================
result_dat.SelectedMSProps = selected_ms_props; % in the same sequence as in selected_ms_time

end % function 

% =========================================================================
% subroutines
% =========================================================================
function selected_ms_idx = selMSOnset(Trial, ms_props, onset_criteria)

enum = Trial.enum;
num_ms = size(ms_props, 1);     % total number of microsaccades

switch onset_criteria
    case 'All'
        % sel_ms_props = ms_props;
        selected_ms_idx = true(num_ms, 1);
        
    case 'Stage 2 onset to Stage 3 end'     % paired, aligned at stage3_onset
        [stage2_onset_idx, ~, ~, stage3_end_idx] = Trial.getPairedStageOnEndIdx('2->3');
        maxIdx = Trial.maxIndex;    
        stage23_yn = be2yn(stage2_onset_idx, stage3_end_idx, maxIdx);
        
        ms_onset_idx = ms_props(:, enum.usacc_props.start_index); 
        ms_onset_yn = false(maxIdx, 1);
        ms_onset_yn(ms_onset_idx) = true;
        
        selected_ms_yn = stage23_yn & ms_onset_yn;
        selected_ms_idx = selected_ms_yn(ms_onset_idx);
        % sel_ms_props = ms_props(selected_ms_idx, :);
        
    case 'Stage 1 onset to Stage 2 end'
        [stage1_onset_idx, ~, ~, stage2_end_idx] = Trial.getPairedStageOnEndIdx('1->2');
        maxIdx = Trial.maxIndex;    
        stage12_yn = be2yn(stage1_onset_idx, stage2_end_idx, maxIdx);
        
        ms_onset_idx = ms_props(:, enum.usacc_props.start_index); 
        ms_onset_yn = false(maxIdx, 1);
        ms_onset_yn(ms_onset_idx) = true;
        
        selected_ms_yn = stage12_yn & ms_onset_yn;
        selected_ms_idx = selected_ms_yn(ms_onset_idx);
        % sel_ms_props = ms_props(selected_ms_idx, :);
        
    case 'In Stage 2 / 3: 475 ms after Stage onset to 375 ms before Stage end'
        [stage2_on_idx, stage2_end_idx, stage3_on_idx, stage3_end_idx] = ...
            Trial.getPairedStageOnEndIdx('2->3');
        maxIdx = Trial.maxIndex;

        int2_start = stage2_on_idx + 475 - 1;
        int2_end = stage2_end_idx - 375;
        int2_yn = be2yn(int2_start, int2_end, maxIdx);
        
        int3_start = stage3_on_idx + 475 - 1;
        int3_end = stage3_end_idx - 375;
        int3_yn = be2yn(int3_start, int3_end, maxIdx);
        
        ms_onset_idx = ms_props(:, enum.usacc_props.start_index); 
        ms_onset_yn = false(maxIdx, 1);
        ms_onset_yn(ms_onset_idx) = true;
 
        selected_ms_yn = (int2_yn | int3_yn) & ms_onset_yn;
        selected_ms_idx = selected_ms_yn(ms_onset_idx);
        % sel_ms_props = ms_props(selected_ms_idx, :);

    otherwise
        % sel_ms_props = [];
        error('DOSelectUsacc:SelMSOnset', 'Unknown onset criteria')
        
end % switch

end 

function selected_ms_idx = selMSEnd(ms_props, end_criteria)

num_ms = size(ms_props, 1);     % total number of MS
switch end_criteria
    case 'All'
        % sel_ms_props = ms_props;
        selected_ms_idx = true(num_ms, 1);
        
    otherwise
        % sel_ms_props = [];
        error('DOSelectUsacc:SelMSEnd', 'Unknown onset criteria')

end % switch

end 

function selected_ms_idx = selMSPkvel(ms_props, pkvel_criteria)

num_ms = size(ms_props, 1);     % total number of MS
switch pkvel_criteria
    case 'All'
        % sel_ms_props = ms_props;
        selected_ms_idx = true(num_ms, 1);
        
    otherwise
        % sel_ms_props = [];
        error('DOSelectUsacc:SelMSPkvel', 'Unknown onset criteria')
end

end 

function selected_swj_idx = selMSSwj(usacc_props, swj_type, sname)

Trial = MSCTrial(sname);    % trial object
enum = Trial.enum;

switch swj_type
    case 'All'
        selected_swj_idx = usacc_props(:, enum.usacc_props.swj_pair) > 0;
        % sel_ms_swj = usacc_props(swj_idx, :);
        
    case '1st in SWJ'
        selected_swj_idx = usacc_props(:, enum.usacc_props.swj_pair) == 1;
        % sel_ms_swj = usacc_props(swj1_idx, :);
        
    case '1st in SWJ and no MS 500 ms before and SWJ ISI <= 500'
        swj1_idx = usacc_props(:, enum.usacc_props.swj_pair) == 1;
        % swj1_seq = find(swj1_idx);
        
        swj1_pre_time_end = usacc_props(swj1_idx, enum.usacc_props.pre_time_end);
        swj1_isi = usacc_props(swj1_idx, enum.usacc_props.post_time);
        valid_idx = swj1_pre_time_end >= 500 & swj1_isi <= 500;
        
        selected_swj_idx = swj1_idx & valid_idx;
        
        % sel_ms_swj = usacc_props(swj1_seq(valid_idx), :);
        
    case '2nd in SWJ'
        selected_swj_idx = usacc_props(:, enum.usacc_props.swj_pair) == 2;
        % sel_ms_swj = usacc_props(swj2_idx, :);
        
    case '2nd in SWJ and no MS 500 ms before 1st in SWJ and SWJ ISI <= 500'
        swj2_idx = usacc_props(:, enum.usacc_props.swj_pair) == 2;
        % swj2_seq = find(swj2_idx);
        
        swj1_idx = usacc_props(swj2_idx, enum.usacc_props.pre_event_index);
        swj1_pre_time_end = usacc_props(swj1_idx, enum.usacc_props.pre_time_end);
        swj2_isi = usacc_props(swj2_idx, enum.usacc_props.pre_time_end);
        valid_idx = swj1_pre_time_end >= 500 & swj2_isi <= 500;
        
        selected_swj_idx = swj2_idx & valid_idx;
        
        % sel_ms_swj = usacc_props(swj2_seq(valid_idx), :);
        
    case 'Exclude SWJ'
        swj_idx = usacc_props(:, enum.usacc_props.swj_pair) > 0;  
        selected_swj_idx = ~swj_idx;
        
        % sel_ms_swj = usacc_props(~swj_idx, :);
        
end % switch

end % function

function selected_ms_idx = selMSIsi(Trial, ms_props, isi)

enum = Trial.enum;
num_ms = size(ms_props, 1);     % total number of MS

switch isi
    case 'All'
        % sel_ms_isi = ms_props;
        selected_ms_idx = true(num_ms, 1);
        
    case 'both pre and post ISI <= 500'
        N = size(ms_props);     % number of candidate MS
        selected_ms_idx = false(N, 1);
        for k = 1:N     % check one by one
            ms_props_k = ms_props(k, :);
            % either prevous or post event must be a usacc
            pre_event = ms_props_k(enum.usacc_props.pre_event);
            post_event = ms_props_k(enum.usacc_props.post_event);
            is_valid_event = pre_event == 1 & post_event == 1;
            
            % pre and post ISI
            pre_time = ms_props_k(enum.usacc_props.pre_time_end);
            post_time = ms_props_k(enum.usacc_props.post_time_end);
            is_valid_isi = pre_time <= 500 & post_time <= 500;
            
            selected_ms_idx(k) = is_valid_event & is_valid_isi;
        end % for
        
        % sel_ms_isi = ms_props(valid_idx, :);
        
end % switch

end % function

function selected_dir_idx = selMSDir(Trial, usacc_props, ms_dir_criterion, ms_dir_pair)

enum = Trial.enum;
num_ms = size(usacc_props, 1);     % total number of MS
ms_dir = usacc_props(:, enum.usacc_props.direction);    % compass, visual degree
gb_dir = -Trial.GaborDir;   % Gabor direction = orientation in dva, changed to compass coordinate

switch ms_dir_criterion
    case 'All'
        selected_dir_idx = true(num_ms, 1);
        
    case 'Orthogonal to cell orientation'
        angle_thres = 30;   % threshold of angle in dva
        deta = abs(ms_dir - gb_dir);
        
        selected_dir_idx = (deta >= 90 - angle_thres & deta <= 90 + angle_thres) | (deta >= 270 - angle_thres & deta <= 270 + angle_thres);
        
    case 'Parallel to cell orientation'
        angle_thres = 30;   % threshold of angle in dva
        deta = abs(ms_dir - gb_dir);
        
        selected_dir_idx = (deta >= - angle_thres & deta <= angle_thres) | (deta >= 180 - angle_thres & deta <= 180 + angle_thres);
        
    case 'Pair of angle and bin'
        ang = ms_dir_pair(1);
        bin = ms_dir_pair(2);
        check_dir = gb_dir + ang;
        deta = abs(ms_dir - check_dir);
        
        selected_dir_idx = (deta >= - bin/2 & deta <= bin/2) | (deta >= 180 - bin/2 & deta <= 180 + bin/2);
        
    otherwise
        error('DOSelectUsacc:SelMSDir', 'Unknown onset criteria')
end % switch

end % function

function selected_mag_idx = selMSMagnitude(Trial, usacc_props, ms_mag_criterion)

enum = Trial.enum;
num_ms = size(usacc_props, 1);     % total number of MS

switch ms_mag_criterion
    case 'All'
        selected_mag_idx = true(num_ms, 1);
        
    case '<= 0.3246 DVA'
        ms_mag = usacc_props(:, enum.usacc_props.magnitude);
        selected_mag_idx = ms_mag <= 0.3246;
        
    case '>= 0.5075 DVA'
        ms_mag = usacc_props(:, enum.usacc_props.magnitude);
        selected_mag_idx = ms_mag >= 0.5075;
        
    otherwise
            error('DOSelectUsacc:SelMSMagnitude', 'Unknown onset criteria')

end % switch

end % function

function sel_ms_props = selectMSSingleEye(curr_exp, usacc_props, criteria, sname)
% Select MS from single eye
% 
% Inputs:
%   usacc_props
%   criteria
%   msobj
%   stagetype       
% 
% Outputs:
%   sel_ms_prop

% trial obj
% ---------
Trial = MSCTrial(curr_exp, sname);    % trial object

% select according to ms_onset
% ----------------------------
ms_onset = criteria.ms_onset;
sel_onset_idx = selMSOnset(Trial, usacc_props, ms_onset);

% select according to ms_end
% ----------------------------
ms_end  = criteria.ms_end;
sel_end_idx = selMSEnd(usacc_props, ms_end);

% select according to ms_dir
% --------------------------
ms_dir      = criteria.ms_dir;
ms_dir_pair = criteria.ms_dir_pair;
sel_dir_idx = selMSDir(Trial, usacc_props, ms_dir, ms_dir_pair);

% select according to ms magnitude
% --------------------------------
ms_mag = criteria.ms_mag;
sel_mag_idx = selMSMagnitude(Trial, usacc_props, ms_mag);

% select according to ms pkvel
% ----------------------------
ms_pkv   = criteria.ms_pkv;
sel_pkvel_idx = selMSPkvel(usacc_props, ms_pkv);

% select according to inter MS interval
% -------------------------------------
ms_isi = criteria.ms_isi;
sel_isi_idx = selMSIsi(Trial, usacc_props, ms_isi);

% select according to swj choice
% ------------------------------
num_ms = size(usacc_props, 1);
if criteria.Select_SWJ
    sel_swj_idx = selMSSwj(usacc_props, criteria.swj_type, sname);
else
    sel_swj_idx = true(num_ms, 1);
end % if

% required MS found
% -----------------
sel_dir_idx = sel_onset_idx & sel_end_idx & sel_dir_idx & sel_mag_idx & ...
             sel_pkvel_idx & sel_isi_idx & sel_swj_idx;
sel_ms_props = usacc_props(sel_dir_idx, :);

end

% [EOF]

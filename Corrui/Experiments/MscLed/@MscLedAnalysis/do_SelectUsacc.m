function result_dat = do_SelectUsacc(current_tag, sname, S, dat)
% MSCLEDANALYSIS.DO_SELECTUSACC selects microsaccades for subsequent analysis 
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

% Copyright 2013 Richard J. Cui. Created: Tue 09/03/2013  3:07:13.998 PM
% $Revision: 0.1 $  $Date: Tue 09/03/2013  3:07:13.998 PM $
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
    opt.ms_onset = { {'All', '{All in trials}' },...
                      'MS onset criteria' };
    % MS end
    % ---------
    opt.ms_end = { {'{All}', 'All in trials'}, 'MS end criteria'};
    
    % peak velocity
    % -------------
    opt.pkvel = { {'{All}' '0 - 100'}, 'Peak veolcity criteria (dva/s)' };
    
    result_dat = opt;
    return

end % if

% =========================================================================
% Specify data for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')

    result_dat = [];
    return
end % if

% =========================================================================
% get the options
% =========================================================================
eye_choice = S.Stage_2_Options.([mfilename, '_options']).eye_choise;
ms_onset = S.Stage_2_Options.([mfilename, '_options']).ms_onset;
ms_end = S.Stage_2_Options.([mfilename, '_options']).ms_end;
pkvel = S.Stage_2_Options.([mfilename, '_options']).pkvel;

% =========================================================================
% select usacc
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
MS = MLDUsacc(curr_exp, sname);    % construct usacc object
criteria.ms_onset = ms_onset;
criteria.ms_end = ms_end;
criteria.pkvel = pkvel;

if strcmp(eye_choice, 'Left')
    ms_props = MS.left_usacc_props;
    selected_ms_props = selectMSSingleEye(curr_exp, ms_props, criteria, sname);
end % if

if strcmp(eye_choice, 'Right')
    ms_props = MS.left_usacc_props;
    selected_ms_props = selectMSSingleEye(curr_exp, ms_props, criteria, sname);    
end % if

if strcmp(eye_choice, 'Both')
    
end % if

% =========================================================================
% Commit
% =========================================================================
result_dat.SelectedMSProps = selected_ms_props; % in the same sequence as in selected_ms_time

end % function 

% =========================================================================
% subroutines
% =========================================================================
function sel_ms_props = selMSOnset(curr_exp, ms_props, onset_criteria, sname)

Trial = MLDTrial(curr_exp, sname);    % trial object
enum = Trial.enum;

switch onset_criteria
    case 'All'
        sel_ms_props = ms_props;
        
    case 'All in trials'
        trial_props = Trial.trial_props;
        trial_seq = trial_props(:, enum.trial_props.Sequence);
        max_seq = max(trial_seq);
        
        ms_seq = ms_props(:, enum.usacc_props.trial_seq);
        sel_ms_idx = ms_seq > 0 & ms_seq <= max_seq;
        
        sel_ms_props = ms_props(sel_ms_idx, :);

    otherwise
        sel_ms_props = [];
        
end % switch

end 

function sel_ms_props = selMSEnd(ms_props, end_criteria, sname)

switch end_criteria
    case 'All'
        sel_ms_props = ms_props;
        
    otherwise
        sel_ms_props = [];

end % switch

end 

function sel_ms_props = selMSPkvel(ms_props, pkvel_criteria, sname)

switch pkvel_criteria
    case 'All'
        sel_ms_props = ms_props;
        
    otherwise
        sel_ms_props = [];
end

end 

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

% criteria
% --------
ms_onset = criteria.ms_onset;
ms_end = criteria.ms_end;
pkvel = criteria.pkvel;

% select according to ms_onset
% ----------------------------
sel_ms_onset = selMSOnset(curr_exp, usacc_props, ms_onset, sname);

% select according to ms_end
% ----------------------------
sel_ms_end = selMSEnd(sel_ms_onset, ms_end, sname);

% select according to ms pkvel
% ----------------------------
sel_ms_pkvel = selMSPkvel(sel_ms_end, pkvel, sname);

% find MS time
sel_ms_props = sel_ms_pkvel;

end

% [EOF]

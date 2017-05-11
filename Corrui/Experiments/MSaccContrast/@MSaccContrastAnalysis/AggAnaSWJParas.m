function result_dat = AggAnaSWJParas(current_tag, sname, S, dat)
% AGGANASWJPARAS get SWJ parameters for SWJ detection
%
% Syntax:
%
% Input(s):
%   sname       - session name
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 05/01/2013 10:32:44.512 PM
% $Revision: 0.1 $  $Date: 05/01/2013 10:32:44.512 PM $
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
    opt.trial_props = { 'All recording|{All trials}', 'Trial property' }; 
    opt.which_eye = { 'Right|{Left}', 'Which eye' };
    opt.sacc_type = { '{Microsaccade}|Saccade', 'Saccade type' };
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'left_usacc_props', 'right_usacc_props', ...
                'left_saccade_props', 'right_saccade_props'};
    
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% options
trial_props = S.Stage_2_Options.([mfilename, '_options']).trial_props;
which_eye = S.Stage_2_Options.([mfilename, '_options']).which_eye;
sacc_type = S.Stage_2_Options.([mfilename, '_options']).sacc_type;

% data
vars = { 'enum', 'samplerate', 'timestamps' };
para = CorruiDB.Getsessvars(sname, vars);

enum = para.enum;
samplerate = para.samplerate;
timestamps = para.timestamps;
left_usacc_props = dat.left_usacc_props;
right_usacc_props = dat.right_usacc_props;

switch which_eye
    case 'Left'
        switch sacc_type
            case 'Microsaccade'
                sacc_props = left_usacc_props;
                enum_sacc_props = enum.usacc_props;
            case 'Saccade'
                sacc_props = left_saccade_props;
                enum_sacc_props = enum.saccade_props;                
        end % switch
    case 'Right'
        switch sacc_type
            case 'Microsaccade'
                sacc_props = right_usacc_props;
                enum_sacc_props = enum.usacc_props;                
            case 'Saccade'
                sacc_props = right_saccade_props;
                enum_sacc_props = enum.saccade_props;                                
        end % switch
        
end % switch

switch trial_props
    case 'All recording'
        
    case 'All trials'
        sacc_props = selSaccInTrial(sacc_props, enum_sacc_props);
end % switch

% get paras
swj_paras = SWJDectionAlgorithm.getswjparameters(sacc_props, timestamps, samplerate, enum_sacc_props);

% =========================================================================
% commit
% =========================================================================

result_dat.SWJParameters = swj_paras;

end % function AggAnaMSTrigResp

% =========================================================================
% subroutines
% =========================================================================
function sel_sacc_props = selSaccInTrial(sacc_props, enum_sacc_props)

if ~iscell(sacc_props)
    sacc_props = {sacc_props};
end


sel_sacc_props = cell(size(sacc_props));
N = length(sacc_props);
for k = 1:N
    sacc_props_k = sacc_props{k};
    in_trial_idx = sacc_props_k(:, enum_sacc_props.ntrial) > 0;
    sel_sacc_props_k = sacc_props_k(in_trial_idx, :);
    
    sel_sacc_props{k} = sel_sacc_props_k;
end % for

end

% [EOF]

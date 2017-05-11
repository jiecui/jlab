function sac_frm = format_sacc(this, sacc_props, var_name)
% MSACCCONTRASTPLOTS.FORMAT_SACC format sacc_props data if necessary
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

% Copyright 2016 Richard J. Cui. Created: Tue 09/13/2016  3:28:20.277 PM
% $Revision: 0.1 $  $Date: Tue 09/13/2016  3:28:20.277 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% property variable names
% -----------------------
msc_vars = {'NTrial', 'Condition', 'Cycle', 'StartInStage', 'EndInStage'};
eye_saccade = EyeSacc;
saccade_prop_names = cat(2, eye_saccade.prop_var_names, msc_vars);
eye_usacc = EyeUsacc;
usacc_prop_names = cat(2, eye_usacc.prop_var_names, msc_vars);

switch var_name
    case {'left_saccade_props', 'right_saccade_props'}
        prop_names = saccade_prop_names;
    case {'left_usacc_props', 'right_usacc_props'}
        prop_names = usacc_prop_names;
end % switch

if isempty(sacc_props)
    sacc_props = zeros(0, numel(prop_names));
end % if

sac_frm = array2table(sacc_props, 'VariableNames', prop_names);

end % function import_sacc_props

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

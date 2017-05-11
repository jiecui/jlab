function fix_frm = format_fix(this, fix_props)
% MSACCCONTRASTPLOTS.FORMAT_FIX format fixation_props data if necessary
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

% Copyright 2016 Richard J. Cui. Created: Wed 10/26/2016 12:36:28.535 PM
% $Revision: 0.1 $  $Date: Wed 10/26/2016 12:36:28.535 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% property variable names
% -----------------------
msc_vars = {'NTrial', 'Condition', 'Cycle', 'StartInStage', 'EndInStage'};
eye_fix = EyeFixation;
prop_names = cat(2, eye_fix.FixPropsVarNames, msc_vars);

if isempty(fix_props)
    fix_props = zeros(0, numel(prop_names));
end % if

fix_frm = array2table(fix_props, 'VariableNames', prop_names);

end % function format_fix

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

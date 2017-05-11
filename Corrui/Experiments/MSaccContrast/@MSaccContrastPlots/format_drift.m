function drift_frm = format_drift(this, drift_props)
% MSACCCONTRASTPLOTS.FORMAT_DRIFT format drift_props data if necessary
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

% Copyright 2016 Richard J. Cui. Created: Wed 11/09/2016  2:41:18.709 PM
% $Revision: 0.1 $  $Date: Wed 11/09/2016  2:41:18.709 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% property variable names
% -----------------------
msc_vars = {'NTrial', 'Condition', 'Cycle', 'StartInStage', 'EndInStage'}; % msc - microsaccade contrast exp
eye_drift = EyeDrift;
prop_names = cat(2, eye_drift.DriftPropsNames, msc_vars);

if isempty(drift_props)
    drift_props = zeros(0, numel(prop_names));
end % if

drift_frm = array2table(drift_props, 'VariableNames', prop_names);

end % function format_drift

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

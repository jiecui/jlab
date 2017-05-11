function blink_frm = format_blink(this, blink_props)
% MSACCCONTRASTPLOTS.FORMAT_BLINK format blink_props data if necessary
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

% Copyright 2016 Richard J. Cui. Created: Mon 11/14/2016  2:52:31.518 PM
% $Revision: 0.1 $  $Date: Mon 11/14/2016  2:52:31.518 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% property variable names
% -----------------------
msc_vars = {'NTrial', 'Condition', 'Cycle', 'StartInStage', 'EndInStage'}; % msc - microsaccade contrast exp
eye_blink = EyeBlink;
prop_names = cat(2, eye_blink.BlinkPropVarNames, msc_vars);

if isempty(blink_props)
    blink_props = zeros(0, numel(prop_names));
end % if

blink_frm = array2table(blink_props, 'VariableNames', prop_names);

end % function format_blink

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

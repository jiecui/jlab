function result_dat = AggMSContStep(current_tag, name, S, dat)
% MSACCCONTRASTANALYSIS.AGGMSCONTSTEP Relationship between MS and Contrast steps in aggregate data
% 
% Description:
%   This function analyzes the relationship between events of microsaccades
%   and events of contrast step change
%
% Syntax:
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Mon 01/13/2014 11:06:42.826 AM
% $Revision: 0.1 $  $Date: Mon 01/13/2014 11:06:42.826 AM $
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
if strcmpi(current_tag,'get_options')
    opt = [];
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = {  };
    
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------

% get the data
% -------------

% =====================
% commit results
% =====================
% P2
result_dat = [];

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================

% [EOF]

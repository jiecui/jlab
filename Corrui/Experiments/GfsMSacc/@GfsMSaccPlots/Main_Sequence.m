function result_dat = Main_Sequence(current_tag, sname, S)
% GFSMSACCPLOTS.MAIN_SEQUENCE plots main sequence for GMS experiment
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

% Copyright 2016 Richard J. Cui. Created: Mon 11/28/2016 10:02:34.349 PM
% $Revision: 0.1 $  $Date: Thu 12/08/2016 10:02:43.246 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag, 'get_options')
    % general options
    result_dat = EyeMovementExpPlots.Main_Sequence(current_tag, [], []);
    
    % GMS specified options
    
	return
end % if

% =========================================================================
% Get options and parameters
% =========================================================================
% example = S.([mfilename, '_options']).example;

% =========================================================================
% Get data
% =========================================================================


% =========================================================================
% Plot
% =========================================================================


end % function Main_Sequence

% =========================================================================
% Subroutines
% =========================================================================


% [EOF]

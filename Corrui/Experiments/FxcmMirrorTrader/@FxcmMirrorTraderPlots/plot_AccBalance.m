function opt = plot_AccBalance(current_tag, sname, S)
% PLOT_ACCBALANCE plots results from do_AccBalance
%
% Syntax:
%   options = plot_MSTriggeredContrastResponse(current_tag, snames, S)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Mon 11/17/2014  3:35:33.881 PM
% $Revision: 0.2 $  $Date: Wed 09/16/2015 10:21:43.927 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% options
% =========================================================================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        % opt.Show_single_luminance_options.flag_raster = { {'{0}','1'}, 'Show spike raster' };
        opt =[];
        
        return
    end
end

% =========================================================================
% get options
% =========================================================================
% data_type = S.([mfilename,'_options']).data_type;

% =========================================================================
% get data wanted
% =========================================================================
% dat_var = {'MSTriggeredContrastResponse'};
% dat = CorruiDB.Getsessvars(sname,dat_var);
% ms_trig_resp = dat.MSTriggeredContrastResponse;

% =========================================================================
% plot
% =========================================================================


end % function plot_MSTriggeredContrastResponse

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

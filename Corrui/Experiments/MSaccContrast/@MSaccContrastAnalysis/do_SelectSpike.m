function result_dat = do_SelectSpike(current_tag, sname, S, dat)
% DO_SELECTSPIKE select spikes for subsequent analysis
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: 04/25/2013  4:16:50.576 PM
% $Revision: 0.1 $  $Date: 04/25/2013  4:16:50.576 PM $
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

    result_dat = [];
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

% =========================================================================
% select spikes
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
Spike = MSCSpike(curr_exp, sname);

result_dat.SelectedSpiketimes = Spike.spiketimes;


end % function do_SelectSpike

% [EOF]

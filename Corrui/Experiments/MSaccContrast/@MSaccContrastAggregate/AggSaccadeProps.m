function [mn, se] = AggSaccadeProps(curr_exp, sessionlist, S)
% AGGSACCADEPROPS Assembles saccade props
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

% Copyright 2013 Richard J. Cui. Created: 05/16/2013  9:55:57.549 PM
% $Revision: 0.1 $  $Date: 05/16/2013  9:55:57.553 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% options
% =========================================================================
if ( nargin == 1 )
    switch( curr_exp )
        case 'get_options'
            
            mn = { {'{0}', '1'} };   % select this or not
            
            return
    end
end

% =========================================================================
% get the options
% =========================================================================
% do_spikerate = S.(mfilename).options.spikerate;

% =========================================================================
% main
% =========================================================================
se = [];
numSess = length(sessionlist);  % number of sessions

% enum
% ----------------------------
dat = CorruiDB.Getsessvars(sessionlist{1}, {'enum'});
mn.enum = dat.enum;

% samplerate
% ----------------------------
dat = CorruiDB.Getsessvars(sessionlist{1}, {'samplerate'});
mn.samplerate = dat.samplerate;

% usacc_props and others
% ----------------------------
vars = { 'left_usacc_props', 'right_usacc_props', 'timestamps' };

left_usacc_props = cell(1, numSess);
right_usacc_props = cell(1, numSess);
timestamps = cell(1, numSess);
h = waitbar(0, 'Aggregating...');
for k = 1:numSess
    waitbar(k / numSess, h)
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    left_usacc_props{k} = dat.left_usacc_props;
    right_usacc_props{k} = dat.right_usacc_props;
    timestamps{k} = dat.timestamps;
end % for
close(h)

mn.left_usacc_props = left_usacc_props;
mn.right_usacc_props = right_usacc_props;
mn.timestamps = timestamps;

end % function AggUsaccProps

% [EOF]

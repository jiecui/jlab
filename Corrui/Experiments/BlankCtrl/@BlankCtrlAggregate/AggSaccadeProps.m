function [mn, se] = AggSaccadeProps(curr_exp, sessionlist, S)
% BLANKCTRLAGGREGATE.AGGSACCADEPROPS Assembles (u)saccade props and other relative infomation
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

% Copyright 2013 Richard J. Cui. Created:Wed 09/04/2013 12:09:58.252 PM
% $Revision: 0.1 $  $Date: Wed 09/04/2013 12:09:58.252 PM $
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

% trialtime
% ----------------------------
dat = CorruiDB.Getsessvars(sessionlist{1}, {'trialtime'});
mn.trialtime = dat.trialtime;


% enum
% ----------------------------
dat = CorruiDB.Getsessvars(sessionlist{1}, {'enum'});
mn.enum = dat.enum;

% samplerate
% ----------------------------
dat = CorruiDB.Getsessvars(sessionlist{1}, {'samplerate'});
mn.samplerate = dat.samplerate;

% timestamps
% -----------
vars = { 'timestamps' };
timestamps = cell(1, numSess);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);    
    timestamps{k} = dat.timestamps;
end % for
mn.aggtimestamps = timestamps;

% trial_props
% -----------
vars = { 'trial_props' };
trial_props = cell(1, numSess);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);    
    trial_props{k} = dat.trial_props;
end % for
mn.aggtrial_props = trial_props;

% usacc_props
% ----------------------------
vars = { 'left_usacc_props', 'right_usacc_props' };

left_usacc_props = cell(1, numSess);
right_usacc_props = cell(1, numSess);
h = waitbar(0, 'Aggregating MS props...');
for k = 1:numSess
    waitbar(k / numSess, h)
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    if isfield(dat, 'left_usacc_props')
        left_usacc_props{k} = dat.left_usacc_props;
    end % if
    if isfield(dat, 'right_usacc_props')    
        right_usacc_props{k} = dat.right_usacc_props;
    end % if
end % for
close(h)

mn.aggleft_usacc_props = left_usacc_props;
mn.aggright_usacc_props = right_usacc_props;

end % function AggUsaccProps

% [EOF]

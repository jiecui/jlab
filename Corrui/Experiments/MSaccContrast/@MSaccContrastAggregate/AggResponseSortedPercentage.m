function [mn se] = AggResponseSortedPercentage( curr_exp, sessionlist, S)
% AggResponseSortedPercentage 
% 
% Syntax:
%   [mn se] = AggResponseSortedPercentage( curr_exp, sessionlist, S)
% 
% Input(s):
%
% Output(s):
%   mn      - store
%   se      - not store
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Wed 06/20/2012  8:49:22.313 AM
% $Revision: 0.1 $  $Date: Wed 06/20/2012  8:49:22.313 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% options
if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            % 
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            mn = { {'{0}', '1'} };
            
            return
    end
end

% =======
% main
% =======
% new_session_name    = S.Name_of_New_Averaged_Session;
% str = 'fixgridstat';
% disp(str)

% =======================================================
% change to dbDirectory
% =======================================================
% old_path = pwd;
% dbdir = getpref('corrui','dbDirectory');
% cd(dbdir)

% read the variable
numSess = length(sessionlist);  % number of sessions

% aggreate
% =======================================================
% (1) SpikeRate
% =======================================================
vars = {'SpikeRate'};

SpikeRate = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    sr_k = data.SpikeRate;
    SpikeRate = cat(1, SpikeRate, sr_k);
end % for

% =======================================================
% (2) UsaccRate
% =======================================================
vars = {'UsaccRate'};

UsaccRate = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    ur_k = data.UsaccRate;
    UsaccRate = cat(1, UsaccRate, ur_k);
end % for

% =======================================================
% (3) SpikeRateWinCenter
% =======================================================
vars = {'SpikeRateWinCenter'};

data = CorruiDB.Getsessvars(sessionlist{1}, vars);
spk_c = data.SpikeRateWinCenter;

% =======================================================
% (4) UsaccRateWinCenter
% =======================================================
vars = {'UsaccRateWinCenter'};

data = CorruiDB.Getsessvars(sessionlist{1}, vars);
usa_c = data.UsaccRateWinCenter;

% =======================================================
% (5) UsaccYN
% =======================================================
vars = {'UsaccYN'};

UsaccYN = [];
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    usyn_k = data.UsaccYN;
    UsaccYN = cat(1, UsaccYN, usyn_k);
end % for

% =======================================================
% change back to old path
% =======================================================
% cd(old_path)

% =======================================================
% commit results
% =======================================================
mn.ResponseSortedPercentage.SpikeRate = SpikeRate;
mn.ResponseSortedPercentage.UsaccRate = UsaccRate;
mn.ResponseSortedPercentage.UsaccYN   = UsaccYN;
mn.SpikeRateWinCenter = spk_c;
mn.UsaccRateWinCenter = usa_c;

se = [];

end % function MSaccStat

% [EOF]

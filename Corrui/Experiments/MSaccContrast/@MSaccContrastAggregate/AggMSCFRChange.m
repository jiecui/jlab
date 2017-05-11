function [mn se] = AggMSCFRChange( curr_exp, sessionlist, S )
% AGGMSCFRCHANGE assembles the results of CheckCellFRChange.m from individual cells
% 
% Syntax:
%   [mn se] = AggMSCFRChange( curr_exp, sessionlist, S)
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

% Copyright 2012 Richard J. Cui. Created: Fri 10/12/2012  4:09:03.555 PM
% $Revision: 0.1 $  $Date: Fri 10/12/2012  4:09:03.555 PM $
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
% read the variable
numSess = length(sessionlist);  % number of sessions

% =======================================================
% aggregate 
% =======================================================
vars = {'FRChange'};
Level = zeros(numSess, 1);      % level of confidence interval
ConfInt = zeros(numSess, 2);    % bounds of confidence interval of Slop
Slope = zeros(numSess, 1);      % slop of trend line of firing rate
FiringRate = cell(numSess, 1);  % fring rates of each session
Raster = struct('spiketime', [], 'repeats', [], 'numCycle', [], 'sigLength', []);            % raster of spikes

for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    
    Level(k)        = data.FRChange.SlopeCILevel;
    ConfInt(k,:)    = data.FRChange.ConfInt;
    Slope(k)        = data.FRChange.Slope;
    Raster(k)       = data.FRChange.Raster;
    FiringRate(k)   = {data.FRChange.FiringRate};
end % for

% =======================================================
% commit results
% =======================================================
mn.SlopeCILevel = Level;
mn.SlopeConfInt = ConfInt;
mn.Slope = Slope;
mn.Raster = Raster;
mn.FiringRate = FiringRate;

se = [];

end % function MSaccStat

% [EOF]

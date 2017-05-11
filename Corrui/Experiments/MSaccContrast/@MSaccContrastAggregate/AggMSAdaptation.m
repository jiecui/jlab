function [mn se] = AggMSAdaptation( curr_exp, sessionlist, S)
% AGGSTEPCONTRASTRESP Aggreation for microsaccade and adaptation of contrast response
%
% Syntax:
%   [mn se] = AggMSAdaptation( curr_exp, sessionlist, S)
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

% Copyright 2013 Richard J. Cui. Created: Thu 01/17/2013  4:40:16.276 PM
% $Revision: 0.1 $  $Date: Thu 01/17/2013  4:40:16.276 PM $
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
    switch( curr_exp)
        case 'get_options'
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            % 
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            options = { {'{0}', '1'} };
            mn = options;
            
            return
    end
end

% =========================================================================
% main
% =========================================================================
numSess = length(sessionlist);  % number of sessions

% =========================================================================
% NumberCycle = num sessions x 1
% =========================================================================
vars = {'NumberCycle'};
nc = zeros(numSess, 1);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    nc(k) = dat.NumberCycle;
end % for
mn.NumberCycle = nc;

% =========================================================================
% FXCond12RateCenter = copy from 1st session
% =========================================================================
vars = {'FXCond12RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.FXCond12RateCenter = dat.FXCond12RateCenter;

% =========================================================================
% FXCond12Rate = numSess x 1 cells
% =========================================================================
vars = {'FXCond12Rate'};
FXCond12Rate = cell(numSess, 1);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond12Rate{k} = dat.FXCond12Rate;
end % for
mn.FXCond12Rate = FXCond12Rate;

% =========================================================================
% FXCond23RateCenter
% =========================================================================
vars = {'FXCond23RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.FXCond23RateCenter = dat.FXCond23RateCenter;

% =========================================================================
% FXCond23Rate
% =========================================================================
vars = {'FXCond23Rate'};
FXCond23Rate = cell(numSess, 1);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond23Rate{k} = dat.FXCond23Rate;
end % for
mn.FXCond23Rate = FXCond23Rate;

% =========================================================================
% SortByMS
% =========================================================================
vars = {'SortByMS'};
sort_by_ms = cell(numSess, 1);
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    sort_by_ms{k} = dat.SortByMS;
end % for
mn.SortByMS = sort_by_ms;

% =========================================================================
se = [];

end % function MSaccStat

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% subroutines
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


% [EOF]

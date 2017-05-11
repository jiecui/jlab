function  [mn, se] = AggPortfolio( curr_exp, sessionlist, S )
% FXCMMIRRORTRADERAGGREGATE.AGGPORTFOLIO Assembles the portfolio
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

% Copyright 2014 Richard J. Cui. Created: Tue 11/11/2014 10:17:27.637 PM
% $Revision: 0.1 $  $Date: Tue 11/11/2014 10:17:27.637 PM $
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
            % opt.select = { {'{0}', '1'} };   % select this or not           
            % mn = opt;

            mn = { {'{0}', '1'} };   % select this or not
            
            return
    end
end

% =========================================================================
% get the options
% =========================================================================

% =========================================================================
% main
% =========================================================================
se = [];
curr_agg = curr_exp.aggregateClass;

mn = AggPort(curr_agg, curr_exp, sessionlist, S);

end % function AggTinnitus

% =========================================================================
% subroutines
% =========================================================================
function mn = AggPort(curr_agg, curr_exp, sessionList, S)
% Portfolio

% ----------------------------
% copy
% ----------------------------
% S.Copy = [];
% S.Copy.select = true;
% S.Copy.options.enum = true;
% S.Copy.options.trialtime = true;
% mn_copy = curr_agg.Copy(curr_exp, sessionlist, S);

% -------------------------
% concatenate
% -------------------------
S.Concatenate = [];
S.Concatenate.options.Property      = true;
S.Concatenate.options.History       = true;
S.Concatenate.options.MonthlyReturn = true;
mn_concatenate = curr_agg.Concatenate(curr_exp, sessionList, S);

% -------------------------
% Other data aggregate
% -------------------------

% =========================================================================
% commit
% =========================================================================
% mn = mergestructs(mn_copy, mn_concatenate, mn_lrconcate);
mn = mn_concatenate;

end % function

% [EOF]

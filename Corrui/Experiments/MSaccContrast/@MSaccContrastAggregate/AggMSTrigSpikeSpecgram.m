function  [mn, se] = AggMSTrigSpikeSpecgram( curr_exp, sessionlist, S)
% AGGMSTRIGCONTRESP Assebles the results of MSTriggeredContrastResponse
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

% Copyright 2013-2014 Richard J. Cui. Created: Thu 10/23/2014  1:20:40.119 PM
% $Revision: 0.1 $  $Date: Thu 10/23/2014  1:20:40.119 PM $
%
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
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            %
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            % mn.select = { {'{0}', '1'} };   % select this or not           
            % opt.spikerate = { {'0', '{1}'}, 'Aggregate spike rate' };

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
if numSess <= 3
    warning('AggMSTrigContResp:NumberOfSessions', ...
        'The number of sessions (%g) may be too small.', numSess)
end % if
curr_agg = curr_exp.aggregateClass;

% ----------------------------
% copy
% ----------------------------
S.Copy = [];
S.Copy.select = true;
S.Copy.options.enum = true;
S.Copy.options.MSTriggeredContrastResponse = true;
mn_copy = curr_agg.Copy(curr_exp, sessionlist, S);

% -------------------------
% concatenate
% -------------------------
S.Concatenate = [];
S.Concatenate.options.SpikeSpectrogram = true;
mn_concatenate = curr_agg.Concatenate(curr_exp, sessionlist, S);

% -------------------------
% left-right concatenate
% -------------------------
% S.Left_Right_Concatenate = [];
% S.Left_Right_Concatenate.options.usacc_props = true;
% S.Left_Right_Concatenate.options.saccade_props = true;
% mn_lrconcate = curr_agg.Left_Right_Concatenate(curr_exp, sessionlist, S);

% -------------------------
% Other data aggregate
% -------------------------

% =========================================================================
% commit
% =========================================================================
mn = mergestructs(mn_copy, mn_concatenate);

end % function AggMSTrigContResp

% [EOF]

function  [mn, se] = AggMSTrigMldResp( curr_exp, sessionlist, S)
% AGGMSTRIGMLDRESP Assebles the results of MSTriggeredMscledResp
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

% Copyright 2013-2014 Richard J. Cui. Created: 05/01/2013  8:44:09.320 PM
% $Revision: 0.3 $  $Date: Tue 09/30/2014  2:38:41.445 PM $
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
    switch( curr_exp)
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

% =========================================================================
% main
% =========================================================================
se = [];
numSess = length(sessionlist);  % number of sessions
if numSess <= 3
    warning('AggMSTrigMldResp:NumberOfSessions', ...
        'The number of sessions (%g) may be too small.', numSess)
end % if
curr_agg = curr_exp.aggregateClass;

% ----------------------------
% copy 
% ----------------------------
% copy_vars = { 'enum', 'trialtime' };
% mn = CorruiDB.Getsessvars(sessionlist{1}, copy_vars);
S.Copy = [];
S.Copy.select = true;
S.Copy.options.enum = true;
S.Copy.options.trialtime = true;
mn_copy = curr_agg.Copy(curr_exp, sessionlist, S);

% -------------------------
% concateneate
% -------------------------
% vars = { 'MSTriggeredMscledResp' 'left_usacc_props' 'trial_props'};
% 
% mldresp = cell(1, numSess);
% lup     = cell(1, numSess);
% tp      = cell(1, numSess);
% for k = 1:numSess
%     dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
%     mldresp{k}  = dat.MSTriggeredMscledResp;
%     lup{k}      = dat.left_usacc_props;
%     tp{k}       = dat.trial_props;
% end % for
% 
% mn.MSTriggeredMscledResp = mldresp;
% mn.left_usacc_props = lup;
% mn.trial_props = tp;

S.Concatenate = [];
S.Concatenate.options.trial_props = true;
S.Concatenate.options.SelectedMSProps = true;
S.Concatenate.options.MSTriggeredMscledResp = true;
S.Concatenate.options.LastBctChunk = true;
mn_concatenate = curr_agg.Concatenate(curr_exp, sessionlist, S);

% -------------------------
% left-right concatenate
% -------------------------
S.Left_Right_Concatenate = [];
S.Left_Right_Concatenate.options.usacc_props = true;
S.Left_Right_Concatenate.options.saccade_props = true;
mn_lrconcate = curr_agg.Left_Right_Concatenate(curr_exp, sessionlist, S);

% -------------------------
% Other data aggregate
% -------------------------

% =========================================================================
% commit
% =========================================================================
mn = mergestructs(mn_copy, mn_concatenate, mn_lrconcate);

end % function AggMSTrigMldResp

% [EOF]

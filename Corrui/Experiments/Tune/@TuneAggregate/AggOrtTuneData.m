function [mn se] = AggOrtTuneData( curr_exp, sessionlist, S)
% AGGORTTUNEDATA aggregates variables for cell orientation tuning curve analysis
%
% Syntax:
%   [mn se] = AggOrtTuneData( curr_exp, sessionlist, S)
% 
% Input(s):
%   curr_exp
%   sessionlist
%
% Output(s):
%   mn      - store
%   se      - not store
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Mon 10/01/2012 12:39:10.671 PM
% $Revision: 0.1 $  $Date: Mon 10/01/2012 12:39:10.671 PM $
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
numSess = length(sessionlist);  % number of sessions
vars = {'OrtTuneResponse'};

OrtBE   = [];   % orientation before experiment
OrtAE   = [];   % orientation after experiment
WidthBE = [];   % width of tuning curve before experiment
WidthAE = [];   % width of tuning curve after experiment
XCorr   = [];   % Pearson correlation coefficients
for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    ortbe_k = data.OrtTuneResponse.OrientationBeforeExp;
    ortae_k = data.OrtTuneResponse.OrientationAfterExp;
    widthbe_k = data.OrtTuneResponse.HalfWinWidthBeforeExp;
    widthae_k = data.OrtTuneResponse.HalfWinWidthAfterExp;
    xcorr_k = data.OrtTuneResponse.XCorr;
    
    OrtBE = cat(1, OrtBE, ortbe_k);
    OrtAE = cat(1, OrtAE, ortae_k);
    WidthBE = cat(1, WidthBE, widthbe_k);
    WidthAE = cat(1, WidthAE, widthae_k);
    XCorr = cat(1, XCorr, xcorr_k);
end % for

% =======================================================
% commit results
% =======================================================
mn.AggOrtTuneData.BlockList = sessionlist;
mn.AggOrtTuneData.OrientationBeforeExp = OrtBE;
mn.AggOrtTuneData.OrientationAfterExp = OrtAE;
mn.AggOrtTuneData.TuneWidthBeforeExp = WidthBE;
mn.AggOrtTuneData.TuneWidthAfterExp = WidthAE;
mn.AggOrtTuneData.XCorr = XCorr;

se = [];

end % function MSaccStat

% [EOF]

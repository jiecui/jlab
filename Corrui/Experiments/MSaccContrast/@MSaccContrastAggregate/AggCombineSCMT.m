function [mn se] = AggCombineSCMT( curr_exp, sessionlist, S)
% AGGCOMBINESCMT combines results of aggregated step contrast response and
%       aggregated microsaccade-triggered response
%
% Syntax:
%   [mn se] = AggCombineSCMT( curr_exp, sessionlist, S)
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

% Copyright 2012 Richard J. Cui. Created: Thu 12/20/2012  3:03:06.780 PM
% $Revision: 0.1 $  $Date: Thu 12/20/2012  3:03:06.780 PM $
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

% =======================================================
% add results of step contrast response
% =======================================================
vars = {'FXCond23Rate', 'FXCond23RateMean', 'FXCond23RateSEM', 'FXCond23RateCenter'};
fxcond23rate        = [];
fxcond23ratemean    = [];
fxcond23ratesem     = [];
fxcond23ratecenter  = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    if ~isempty(dat)
        if isfield(dat, 'FXCond23Rate')
            fxcond23rate = cat(1, fxcond23rate, dat.FXCond23Rate);
        end % if
        if isfield(dat, 'FXCond23RateMean')
            fxcond23ratemean = cat(1, fxcond23ratemean, dat.FXCond23RateMean);
        end % if
        if isfield(dat, 'FXCond23RateSEM')
            fxcond23ratesem = cat(1, fxcond23ratesem, dat.FXCond23RateSEM);
        end % if
        if isfield(dat, 'FXCond23RateCenter')
            fxcond23ratecenter = cat(1, fxcond23ratecenter, dat.FXCond23RateCenter);
        end % if
    end % if
end % for
mn.FXCond23Rate     = fxcond23rate;
mn.FXCond23RateCenter = fxcond23ratecenter;
mn.FXCond23RateMean = fxcond23ratemean;
mn.FXCond23RateSEM  = fxcond23ratesem;

% =======================================================
% add results of ms-triggered response
% =======================================================
vars = {'UsaccTriggeredSpikeRate', 'SpikeRateMean', 'SpikeRateSEM', ...
        'SpikeRateWinCenter', 'PreMSIntv', 'PostMSIntv'};
utsr = [];
srmean = [];
srsem = [];
srwc = [];
pre = [];
post = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    if ~isempty(dat)
        if isfield(dat, 'UsaccTriggeredSpikeRate')
            utsr = cat(1, utsr, dat.UsaccTriggeredSpikeRate);
        end % if
        if isfield(dat, 'SpikeRateMean')
            srmean = cat(1, srmean, dat.SpikeRateMean);
        end % if
        if isfield(dat, 'SpikeRateSEM')
            srsem = cat(1, srsem, dat.SpikeRateSEM);
        end % if
        if isfield(dat, 'SpikeRateWinCenter')
            srwc = cat(1, srwc, dat.SpikeRateWinCenter);
        end % if
        if isfield(dat, 'PreMSIntv')
            pre = cat(1, pre, dat.PreMSIntv);
        end % if
        if isfield(dat, 'PostMSIntv')
            post = cat(1, post, dat.PostMSIntv);
        end % if
    end % if
end % for
mn.UsaccTriggeredSpikeRate  = utsr;
mn.SpikeRateMean            = srmean;
mn.SpikeRateSEM             = srsem;
mn.SpikeRateWinCenter       = srwc;
mn.PreMSIntv                = pre;
mn.PostMSIntv               = post;

% =======================================================
se = [];

end % function MSaccStat

% subroutines



% [EOF]

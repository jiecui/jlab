function [mn se] = AggStepContrastResp( curr_exp, sessionlist, S)
% AGGSTEPCONTRASTRESP aggregates variables for step cotnrast response
%       analysis
%
% Syntax:
%   [mn se] = AggStepContrastResp( curr_exp, sessionlist, S)
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

% Copyright 2012 Richard J. Cui. Created: Tue 06/12/2012 10:13:50.468 AM
% $Revision: 0.2 $  $Date: Thu 06/21/2012 10:25:31.238 AM $
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
% (1) FiringXCondLength
% =======================================================
vars = {'FiringXCondLength'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.FiringXCondLength = dat.FiringXCondLength;

% =======================================================
% (2) NumberCycle
% =======================================================
vars = {'NumberCycle'};
nc = 0;
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    nc = nc + dat.NumberCycle;
end % for
mn.NumberCycle = nc;

% =======================================================
% (3)FiringXCond12
% =======================================================
fxc12 = sessdb('getvar', 'FiringXCond12', sessionlist);
fxc_length = sessdb('getvar', 'FiringXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(fxc12)
    mn.FiringXCond12 = concateXCond(sessionlist, fxc12, fxc_length, numcyc);
end % if


% (4) FXCond12RateCenter
vars = {'FXCond12RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.FXCond12RateCenter = dat.FXCond12RateCenter;

% (5) FXCond12Rate_Norm, FXCond12RateMean_Norm, FXCond12RateSEM_Norm
vars = {'FXCond12RateMean_Norm'};
FXCond12Rate_Norm = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond12Rate_Norm = cat(1, FXCond12Rate_Norm, dat.FXCond12RateMean_Norm);
end % for
mn.FXCond12RateMean_Norm = mean(FXCond12Rate_Norm);
mn.FXCond12RateSEM_Norm = std(FXCond12Rate_Norm) / sqrt(numSess);
mn.FXCond12Rate_Norm = FXCond12Rate_Norm;

% (6) FXCond12Rate, FXCond12RateMean, FXCond12RateSEM
vars = {'FXCond12RateMean'};
FXCond12Rate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond12Rate = cat(1, FXCond12Rate, dat.FXCond12RateMean);
end % for
mn.FXCond12RateMean = mean(FXCond12Rate);
mn.FXCond12RateSEM = std(FXCond12Rate) / sqrt(numSess);
mn.FXCond12Rate = FXCond12Rate;

% =======================================================
% (7)FiringXCond23
% =======================================================
fxc23 = sessdb('getvar', 'FiringXCond23', sessionlist);
fxc_length = sessdb('getvar', 'FiringXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(fxc23)
    mn.FiringXCond23 = concateXCond(sessionlist, fxc23, fxc_length, numcyc);
end % if


% (8) FXCond23RateCenter
vars = {'FXCond23RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.FXCond23RateCenter = dat.FXCond23RateCenter;

% (9) FXCond23Rate_Norm, FXCond23RateMean_Norm, FXCond23RateSEM_Norm
vars = {'FXCond23RateMean_Norm'};
FXCond23Rate_Norm = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond23Rate_Norm = cat(1, FXCond23Rate_Norm, dat.FXCond23RateMean_Norm);
end % for
mn.FXCond23RateMean_Norm = mean(FXCond23Rate_Norm);
mn.FXCond23RateSEM_Norm = std(FXCond23Rate_Norm) / sqrt(numSess);
mn.FXCond23Rate_Norm = FXCond23Rate_Norm;

% (10) FXCond23Rate, FXCond23RateMean, FXCond23RateSEM
vars = {'FXCond23RateMean'};
FXCond23Rate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    FXCond23Rate = cat(1, FXCond23Rate, dat.FXCond23RateMean);
end % for
mn.FXCond23RateMean = mean(FXCond23Rate);
mn.FXCond23RateSEM = std(FXCond23Rate) / sqrt(numSess);
mn.FXCond23Rate = FXCond23Rate;

% =======================================================
% (11) UsaccXCondLength
% =======================================================
vars = {'UsaccXCondLength'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.UsaccXCondLength = dat.UsaccXCondLength;

% (12) Left_UXCond12RateCenter
vars = {'Left_UXCond12RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.Left_UXCond12RateCenter = dat.Left_UXCond12RateCenter;

% =======================================================
% (13)Left_UsaccXCond12_Start
% =======================================================
l_uxc12_s = sessdb('getvar', 'Left_UsaccXCond12_Start', sessionlist);
uxc_length = sessdb('getvar', 'UsaccXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(l_uxc12_s)
    mn.Left_UsaccXCond12_Start = concateXCond(sessionlist, l_uxc12_s, uxc_length, numcyc);
end % if

% (14) Left_UXCond12OnsetRate, Left_UXCond12OnsetRateMean, Left_UXCond12OnsetRateSEM
vars = {'Left_UXCond12OnsetRateMean'};
Left_UXCond12OnsetRate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    Left_UXCond12OnsetRate = cat(1, Left_UXCond12OnsetRate, dat.Left_UXCond12OnsetRateMean);
end % for
mn.Left_UXCond12OnsetRateMean = mean(Left_UXCond12OnsetRate);
mn.Left_UXCond12OnsetRateSEM = std(Left_UXCond12OnsetRate) / sqrt(numSess);
mn.Left_UXCond12OnsetRate = Left_UXCond12OnsetRate;

% =======================================================
% (15)Left_UsaccXCond12_end
% =======================================================
l_uxc12_e = sessdb('getvar', 'Left_UsaccXCond12_end', sessionlist);
uxc_length = sessdb('getvar', 'UsaccXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(l_uxc12_e)
    mn.Left_UsaccXCond12_end = concateXCond(sessionlist, l_uxc12_e, uxc_length, numcyc);
end % if

% (16) Left_UXCond12OffsetRate, Left_UXCond12OffsetRateMean, Left_UXCond12OffsetRateSEM
vars = {'Left_UXCond12OffsetRateMean'};
Left_UXCond12OffsetRate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    Left_UXCond12OffsetRate = cat(1, Left_UXCond12OffsetRate, dat.Left_UXCond12OffsetRateMean);
end % for
mn.Left_UXCond12OffsetRateMean = mean(Left_UXCond12OffsetRate);
mn.Left_UXCond12OffsetRateSEM = std(Left_UXCond12OffsetRate) / sqrt(numSess);
mn.Left_UXCond12OffsetRate = Left_UXCond12OffsetRate;

% (17) Left_UXCond23RateCenter
vars = {'Left_UXCond23RateCenter'};
dat = CorruiDB.Getsessvars(sessionlist{1}, vars);
mn.Left_UXCond23RateCenter = dat.Left_UXCond23RateCenter;

% =======================================================
% (18)Left_UsaccXCond23_Start
% =======================================================
l_uxc23_s = sessdb('getvar', 'Left_UsaccXCond23_Start', sessionlist);
uxc_length = sessdb('getvar', 'UsaccXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(l_uxc23_s)
    mn.Left_UsaccXCond23_Start = concateXCond(sessionlist, l_uxc23_s, uxc_length, numcyc);
end % if

% (19) Left_UXCond23OnsetRate, Left_UXCond23OnsetRateMean, Left_UXCond23OnsetRateSEM
vars = {'Left_UXCond23OnsetRateMean'};
Left_UXCond23OnsetRate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    Left_UXCond23OnsetRate = cat(1, Left_UXCond23OnsetRate, dat.Left_UXCond23OnsetRateMean);
end % for
mn.Left_UXCond23OnsetRateMean = mean(Left_UXCond23OnsetRate);
mn.Left_UXCond23OnsetRateSEM = std(Left_UXCond23OnsetRate) / sqrt(numSess);
mn.Left_UXCond23OnsetRate = Left_UXCond23OnsetRate;

% =======================================================
% (20)Left_UsaccXCond23_end
% =======================================================
l_uxc23_e = sessdb('getvar', 'Left_UsaccXCond23_end', sessionlist);
uxc_length = sessdb('getvar', 'UsaccXCondLength', sessionlist);
numcyc = sessdb('getvar', 'NumberCycle', sessionlist);
if ~isempty(l_uxc23_e)
    mn.Left_UsaccXCond23_end = concateXCond(sessionlist, l_uxc23_e, uxc_length, numcyc);
end % if

% (21) Left_UXCond23OffsetRate, Left_UXCond23OffsetRateMean, Left_UXCond23OffsetRateSEM
vars = {'Left_UXCond23OffsetRateMean'};
Left_UXCond23OffsetRate = [];
for k = 1:numSess
    dat = CorruiDB.Getsessvars(sessionlist{k}, vars);
    Left_UXCond23OffsetRate = cat(1, Left_UXCond23OffsetRate, dat.Left_UXCond23OffsetRateMean);
end % for
mn.Left_UXCond23OffsetRateMean = mean(Left_UXCond23OffsetRate);
mn.Left_UXCond23OffsetRateSEM = std(Left_UXCond23OffsetRate) / sqrt(numSess);
mn.Left_UXCond23OffsetRate = Left_UXCond23OffsetRate;

% =======================================================
se = [];

end % function MSaccStat

% subroutines
function cell_out = mergeXCond(cell_in, length, numTrial)

[N, M] = size(cell_in);
L = length(1);
cell_out = {};
for m = 1:M
    Time_m = cell_in(:, m);
    TIME_MN = [];
    for n = 1:N
        Time_mn = Time_m{n};
        if n == 1
            T = 0;
        else
            T = sum(numTrial(1:(n-1)) * L);
        end 
        Time_p = Time_mn + T;
        TIME_MN = cat(1, TIME_MN, Time_p);
    end % for
    cell_out = cat(2, cell_out, TIME_MN);
end % for


end 

function m_xcond = concateXCond(sessions, xcond, xlength, numcyc)

XCOND = [];
Length = [];
NumCyc = [];
nSess = length(sessions);

for k = 1:nSess
    xcond_k = xcond.(sessions{k});
    XCOND = cat(1, XCOND, xcond_k);
    
    length_k = xlength.(sessions{k});
    Length = cat(1, Length, length_k);
    
    numcyc_k = numcyc.(sessions{k});
    NumCyc = cat(1, NumCyc, numcyc_k);
end % for

m_xcond = mergeXCond(XCOND, Length, NumCyc);

end % funciton


% [EOF]

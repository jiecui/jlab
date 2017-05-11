function [mn se] = AggMSaccStat( curr_exp, sessionlist, S)
% AGGMSACCSTAT gets statistics of microsaccade behavior in microsaccde-contrast experiment
%
% Syntax:
%   [mn se] = AggMSaccStat( curr_exp, sessionlist, S)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Sun 06/17/2012  5:34:13.050 PM
% $Revision: 0.1 $  $Date: Sun 06/17/2012  5:34:13.050 PM $
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

% get the variables from all the selected sessions
old_path = pwd;

% change to dbDirectory
dbdir = getpref('corrui','dbDirectory');
cd(dbdir)

% read the variable
% ----------------
numSess = length(sessionlist);  % number of sessions
% we check
% ==================
% (1) main sequence
% ==================
YMainSeq = struct('X', [], 'Y', []);
HMainSeq = struct('X', [], 'Y', []);
for k = 1:numSess
    dat_k = load([sessionlist{k} '_usacc_stat']);  % in arcmin
    usacc_stat_k = dat_k.dat;
    if strcmpi(sessionlist{k}(1:4), 'mscy') % Yoda
        YMainSeq.X = cat(1, YMainSeq.X, usacc_stat_k.MainSequence.X);
        YMainSeq.Y = cat(1, YMainSeq.Y, usacc_stat_k.MainSequence.Y);
    else
        HMainSeq.X = cat(1, HMainSeq.X, usacc_stat_k.MainSequence.X);
        HMainSeq.Y = cat(1, HMainSeq.Y, usacc_stat_k.MainSequence.Y);
    end % fi
end % for

% change back to old path
% -----------------------
cd(old_path)

% plot check
% ----------
X = [YMainSeq.X; HMainSeq.X];
Y = [YMainSeq.Y; HMainSeq.Y];
mainseqfit = fit(X, Y, 'poly1');

figure
plot(YMainSeq.X, YMainSeq.Y, 'r.', 'MarkerSize', 2)
hold on
plot(HMainSeq.X, HMainSeq.Y, 'b.', 'MarkerSize', 2)
plot(mainseqfit)

% Output
% -------
mn.MainSeq.Hellboy.X = HMainSeq.X;
mn.MainSeq.Hellboy.Y = HMainSeq.Y;
mn.MainSeq.Yoda.X = YMainSeq.X;
mn.MainSeq.Yoda.Y = YMainSeq.Y;

se = [];

end % function MSaccStat

% [EOF]

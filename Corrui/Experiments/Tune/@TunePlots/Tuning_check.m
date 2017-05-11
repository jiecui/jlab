function options = Tuning_check(current_tag, sname, S)
% TUNING_CHECK This function plots the tuning curves before and after and experiment for checking.
%
% Syntax:
%
% Input(s):
%   current_tag         - current tag
%   snames              - session names, in cells
%   S                   - options
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Tue 05/22/2012  4:34:55.397 PM
% $Revision: 0.2 $  $Date: Sat 03/15/2014  9:52:20.825 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ========================
% options
% ========================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        % options.Something   = { {'0','{1}'} };
        % options.normalization = {'{No}|Max %'};
        options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'BeforeExpTuneChunk', 'AfterExpTuneChunk', 'OrtTuneResponse'};
dat = CorruiDB.Getsessvars(sname, dat_var);

% ===================================
% draw the orientation tuning curves
% ===================================
th_b = dat.BeforeExpTuneChunk.TrueHits;
th_a = dat.AfterExpTuneChunk.TrueHits;

rohe_before = [repmat(th_b(1:18), 2, 1); th_b(1)];
rohe_after = [repmat(th_a(1:18), 2, 1); th_a(1)];
nr_before = rohe_before/max(rohe_before);   % normalization
nr_after = rohe_after/max(rohe_after);      % normalization

% theta = [90:-10:-80, -90:-10:-170, 180:-10:100, 90]'*pi/180;
theta = [0:10:170, -180:10:-10, 0]'*pi/180;

figure('name', sname)
mmpolar(theta, nr_before, '-b', ...
        theta, nr_after, '-r',...
        'LineWidth', 1.5, 'TTickDelta', 10, 'Style', 'compass')
legend('Before', 'After')
% title(sprintf('%s', sname))

% ===================================
% print statistic
% ===================================
delta_b = dat.OrtTuneResponse.HalfWinWidthBeforeExp;
dirt_b = dat.OrtTuneResponse.OrientationBeforeExp;
delta_a = dat.OrtTuneResponse.HalfWinWidthAfterExp;
dirt_a = dat.OrtTuneResponse.OrientationAfterExp;
c0 = dat.OrtTuneResponse.XCorr;

fprintf(sprintf('Orientation before exp = %g, Directionality before exp = %g.\n', dirt_b, delta_b));
fprintf(sprintf('Orientation after exp = %g, Directionality after exp = %g.\n', dirt_a, delta_a));
fprintf(sprintf('cross correlation coeff = %g.\n', c0));

end % function Plot_ABS_Example

% [EOF]

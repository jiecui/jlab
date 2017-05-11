function options = Plot_FRChange_consistency(current_tag, snames, S)
% PLOT_FRCHANGE_CONSISTENCY checks the consistency of cell firing rate.
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

% Copyright 2012 Richard J. Cui. Created: Mon 07/16/2012 10:39:36.819 AM
% $Revision: 0.1 $  $Date: Mon 07/16/2012 10:39:36.819 AM $
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
        % options.Condition_number = {1 '' [1 121]};
        options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'FRChange'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);

level = dat.FRChange.SlopeCILevel;
fobj = dat.FRChange.fitobj;
frate = dat.FRChange.FiringRate;
slop = dat.FRChange.Slope;
confint = dat.FRChange.ConfInt;

% ========================
% plot
% ========================
% plot raster
% -----------
T           = dat.FRChange.Raster.spiketime;
repeats     = dat.FRChange.Raster.repeats;
numCycle    = dat.FRChange.Raster.numCycle;
sig_len     = dat.FRChange.Raster.sigLength;
tran_time   = dat.FRChange.TranTime;

p = [402, 424, 253, 343];
figure('Position', p)
rasterplot(T, repeats * numCycle, sig_len, gca);
hold on
plot([tran_time, tran_time], ylim, 'b--', 'LineWidth', 2)
ylabel('Repeats')

% plot rate and the fit
% ---------------------
figure('name', sprintf('Firing rate consistency - %s', snames{1}));
N = length(frate);
plot(frate, 'b')
hold on
fith = plot(fobj); 
set(fith, 'color', [1 0 0], 'LineWidth', 2);
legend(fith, 'Firing rate trend')
xlim([1 N])
xlabel('Repeats')
ylabel('Firing rate (spikes/s)')

% print
% -------
cellname = snames{1};
fprintf(sprintf('Session %s\n', cellname))
fprintf(sprintf('Slope = %g\n', slop))
fprintf('CI level = %g\n', level)
fprintf(sprintf('lower bound = %g, upper bound = %g\n', confint(1), confint(2)));

end % function Plot_FRChange_consistency

% [EOF]

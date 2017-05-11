function options = Aggplot_compare_SCMT_index(current_tag, snames, S)
% Aggplot_compare_SCMT_index This function plots the indexes of step-contrast
%       responses and ms-triggered responses for comparison purpose
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

% Copyright 2012 Richard J. Cui. Created: Wed 06/13/2012  9:22:49.710 AM
% $Revision: 0.3 $  $Date: Sun 12/30/2012  9:19:59.911 AM $
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
    if ( strcmp( current_tag, 'get_options' ) )
        % step-contrast
        options.scp2index = { {'0','{1}'}, 'SC-P2 index' };
        options.scp2index_options.y_range = {[0 50] 'Y range (spk/s)' [0 1000]};

        % ms-triggered
        options.mtp1index = { {'0','{1}'}, 'MT-P1 index' };
        options.mtp1index_options.y_range = {[0 20] 'Y range (spk/s)' [0 1000]};
        
        % comparison
        options.compare_select = { {'0','{1}'}, 'Comparison' };
        options.compare_options.spkrate = { {'MT-P1 vs SC-P2' '{MT-P1 vs SC-S2}' 'MT-T1 vs SC-S2' 'MT-P2 vs SC-S2'}, 'Absolute spike rate' };
        options.compare_options.srdif   = { {'MT-P1 vs SC-P2' '{MT-P1 vs SC-S2}' 'MT-T1 vs SC-S2' 'MT-P2 vs SC-S2'}, 'Spike rate difference' };
        options.compare_options.perchg  = { {'MT-P1 vs SC-P2' '{MT-P1 vs SC-S2}' 'MT-T1 vs SC-S2' 'MT-P2 vs SC-S2'}, 'Percentage change' };
        options.compare_options.mi      = { {'MT-P1 vs SC-P2' '{MT-P1 vs SC-S2}' 'MT-T1 vs SC-S2' 'MT-P2 vs SC-S2'}, 'Modulation index' };
        return
    end
end

% =========================================================================
% get options
% =========================================================================
flag_p2index = S.Aggplot_compare_SCMT_index_options.scp2index;
p2_y_range = S.Aggplot_compare_SCMT_index_options.scp2index_options.y_range;

flag_mtp1index = S.Aggplot_compare_SCMT_index_options.mtp1index;
mtp1_y_range = S.Aggplot_compare_SCMT_index_options.mtp1index_options.y_range;

flag_compare = S.Aggplot_compare_SCMT_index_options.compare_select;
compare_spkrate = S.Aggplot_compare_SCMT_index_options.compare_options.spkrate;
compare_srdif = S.Aggplot_compare_SCMT_index_options.compare_options.srdif;
compare_perchg = S.Aggplot_compare_SCMT_index_options.compare_options.perchg;
compare_mi = S.Aggplot_compare_SCMT_index_options.compare_options.mi;

% =========================================================================
% draw indexes
% =========================================================================
% contrast-step indexes
% ---------------------
if flag_p2index
    % get data
    dat_var = {'SCP2Index'};
    dat = CorruiDB.Getsessvars(snames{1},dat_var);
    
    % *** Absolute spike rate ***
    % draw index as fun of condition
    idx_mean = dat.SCP2Index.SpikeRate.Mean * 1000;   % change unit to spk/s
    idx_sem  = dat.SCP2Index.SpikeRate.SEM * 1000;
    figname = 'SC-P2 spike rate';
    plotIdxMatrix(idx_mean, idx_sem, figname, p2_y_range)
    
    % draw index as fun of contrast diff
    idx_mean = dat.SCP2Index.SpikeRateContDiff.Mean * 1000;
    idx_sem  = dat.SCP2Index.SpikeRateContDiff.SEM * 1000;
    figname = 'SC-P2 spike rate - contrast difference';
    y_label = 'Spike rate (spikes/s)';
    plotIdxContDiff(idx_mean, idx_sem, figname, y_label, p2_y_range)
    
    % *** Spike rate difference ***
    % draw index as fun of condition
    idx_mean = dat.SCP2Index.SRDiff.Mean * 1000;   % change unit to spk/s
    idx_sem  = dat.SCP2Index.SRDiff.SEM * 1000;
    figname = 'SC-P2 spike rate difference';
    plotIdxMatrix(idx_mean, idx_sem, figname, p2_y_range)
    
    % draw index as fun of contrast diff
    idx_mean = dat.SCP2Index.SRDiffContDiff.Mean * 1000;
    idx_sem  = dat.SCP2Index.SRDiffContDiff.SEM * 1000;
    figname = 'SC-P2 spike rate difference- contrast difference';
    y_label = 'Spike rate difference (spikes/s)';
    plotIdxContDiff(idx_mean, idx_sem, figname, y_label, p2_y_range)
    
end % if

% ms-triggered indexes
% --------------------
if flag_mtp1index
    % get data
    dat_var = {'MTP1Index'};
    dat = CorruiDB.Getsessvars(snames{1}, dat_var);
    
    % *** Absolute spike rate ***
    idx_mean = dat.MTP1Index.SpikeRate.Mean * 1000; % unit spikes / sec
    idx_sem  = dat.MTP1Index.SpikeRate.SEM * 1000;
    figname = 'MT-P1 spike rate';
    y_label = 'Spike rate (spikes/s)';
    plotIdxContLevel(idx_mean, idx_sem, figname, y_label, mtp1_y_range)

    % *** Spike rate difference ***
    idx_mean = dat.MTP1Index.SRDiff.Mean * 1000; % unit spikes / sec
    idx_sem  = dat.MTP1Index.SRDiff.SEM * 1000;
    figname = 'MT-P1 spike rate difference';
    y_label = 'Spike rate difference (spikes/s)';
    plotIdxContLevel(idx_mean, idx_sem, figname, y_label, mtp1_y_range)
    
end % if

% comparison
% ----------
if flag_compare
    % *** spike rate ***
    x_label = 'Spike rate (spikes/s)';
    switch compare_spkrate
        case 'MT-P1 vs SC-P2'
            figname = 'Spike rate MT-P1 vs SC-P2';
            dat_var = {'MTP1Index', 'SCP2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);
            
            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.SpikeRate.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP1Index.SpikeRate.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';
            
            cont_diff = -100:10:100;
            scp2_mean = dat.SCP2Index.SpikeRateContDiff.Mean * 1000;
            scp2_sem  = dat.SCP2Index.SpikeRateContDiff.SEM * 1000;
            sr2 = [cont_diff; scp2_mean; scp2_sem]';
            y2_label = 'Contrast change (%)';
            
        case 'MT-P1 vs SC-S2'
            figname = 'Spike rate MT-P1 vs SC-S2';
            dat_var = {'MTP1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);
            
            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.SpikeRate.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP1Index.SpikeRate.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';
            
            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SpikeRateContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SpikeRateContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';
            
        case 'MT-T1 vs SC-S2'
            figname = 'Spike rate MT-T1 vs SC-S2';
            dat_var = {'MTT1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);
            
            cont_level = (0:10:100)';
            mtp1_mean = dat.MTT1Index.SpikeRate.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTT1Index.SpikeRate.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';
            
            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SpikeRateContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SpikeRateContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';            
                        
        case 'MT-P2 vs SC-S2'
            figname = 'Spike rate MT-P2 vs SC-S2';
            dat_var = {'MTP2Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);
            
            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP2Index.SpikeRate.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP2Index.SpikeRate.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';
            
            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SpikeRateContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SpikeRateContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';
    
    end % switch
    plotCompare(sr1, sr2, figname, x_label, y1_label, y2_label)

    % *** spike rate difference ***
    x_label = 'Spike rate difference (spikes/s)';
    switch compare_srdif
        case 'MT-P1 vs SC-P2'
            figname = 'Spike rate difference MT-P1 vs SC-P2';
            dat_var = {'MTP1Index', 'SCP2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.SRDiff.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP1Index.SRDiff.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scp2_mean = dat.SCP2Index.SRDiffContDiff.Mean * 1000;
            scp2_sem  = dat.SCP2Index.SRDiffContDiff.SEM * 1000;
            sr2 = [cont_diff; scp2_mean; scp2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-P1 vs SC-S2'
            figname = 'Spike rate difference MT-P1 vs SC-S2';
            dat_var = {'MTP1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.SRDiff.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP1Index.SRDiff.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SRDiffContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SRDiffContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-T1 vs SC-S2'
            figname = 'Spike rate difference MT-T1 vs SC-S2';
            dat_var = {'MTT1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);
            
            cont_level = (0:10:100)';
            mtp1_mean = dat.MTT1Index.SRDiff.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTT1Index.SRDiff.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';
            
            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SRDiffContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SRDiffContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-P2 vs SC-S2'
            figname = 'Spike rate difference MT-P2 vs SC-S2';
            dat_var = {'MTP2Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP2Index.SRDiff.Mean * 1000; % unit spikes / sec
            mtp1_sem  = dat.MTP2Index.SRDiff.SEM * 1000;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.SRDiffContDiff.Mean * 1000;
            scs2_sem  = dat.SCS2Index.SRDiffContDiff.SEM * 1000;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

    end % switch
    plotCompare(sr1, sr2, figname, x_label, y1_label, y2_label)

    % *** spike rate percentage change ***
    x_label = 'Spike rate percentage change (%)';
    switch compare_perchg
        case 'MT-P1 vs SC-P2'
            figname = 'Percentage change MT-P1 vs SC-P2';
            dat_var = {'MTP1Index', 'SCP2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.PerChange.Mean; % unit %
            mtp1_sem  = dat.MTP1Index.PerChange.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scp2_mean = dat.SCP2Index.PerChangeContDiff.Mean;
            scp2_sem  = dat.SCP2Index.PerChangeContDiff.SEM;
            sr2 = [cont_diff; scp2_mean; scp2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-P1 vs SC-S2'
            figname = 'Percentage change MT-P1 vs SC-S2';
            dat_var = {'MTP1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.PerChange.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTP1Index.PerChange.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.PerChangeContDiff.Mean;
            scs2_sem  = dat.SCS2Index.PerChangeContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';
            
        case 'MT-T1 vs SC-S2'
            figname = 'Percentage change MT-T1 vs SC-S2';
            dat_var = {'MTT1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTT1Index.PerChange.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTT1Index.PerChange.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.PerChangeContDiff.Mean;
            scs2_sem  = dat.SCS2Index.PerChangeContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-P2 vs SC-S2'
            figname = 'Percentage change MT-P2 vs SC-S2';
            dat_var = {'MTP2Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP2Index.PerChange.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTP2Index.PerChange.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.PerChangeContDiff.Mean;
            scs2_sem  = dat.SCS2Index.PerChangeContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

    end % switch
    plotCompare(sr1, sr2, figname, x_label, y1_label, y2_label)
    
    % *** modulation index ***
    x_label = 'Modulation index';
    switch compare_mi
        case 'MT-P1 vs SC-P2'
            figname = 'Modulation index MT-P1 vs SC-P2';
            dat_var = {'MTP1Index', 'SCP2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.ModuIndex.Mean; % arbitrary unit
            mtp1_sem  = dat.MTP1Index.ModuIndex.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scp2_mean = dat.SCP2Index.ModuIndexContDiff.Mean;
            scp2_sem  = dat.SCP2Index.ModuIndexContDiff.SEM;
            sr2 = [cont_diff; scp2_mean; scp2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-P1 vs SC-S2'
            figname = 'Modulation index MT-P1 vs SC-S2';
            dat_var = {'MTP1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP1Index.ModuIndex.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTP1Index.ModuIndex.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.ModuIndexContDiff.Mean;
            scs2_sem  = dat.SCS2Index.ModuIndexContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

        case 'MT-T1 vs SC-S2'
            figname = 'Modulation index MT-T1 vs SC-S2';
            dat_var = {'MTT1Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTT1Index.ModuIndex.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTT1Index.ModuIndex.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.ModuIndexContDiff.Mean;
            scs2_sem  = dat.SCS2Index.ModuIndexContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';
            
        case 'MT-P2 vs SC-S2'
            figname = 'Modulation index MT-P2 vs SC-S2';
            dat_var = {'MTP2Index', 'SCS2Index'};
            dat = CorruiDB.Getsessvars(snames{1}, dat_var);

            cont_level = (0:10:100)';
            mtp1_mean = dat.MTP2Index.ModuIndex.Mean; % arbitrary unit 
            mtp1_sem  = dat.MTP2Index.ModuIndex.SEM;
            sr1 = [cont_level, mtp1_mean, mtp1_sem];
            y1_label = 'Contrast (%)';

            cont_diff = -100:10:100;
            scs2_mean = dat.SCS2Index.ModuIndexContDiff.Mean;
            scs2_sem  = dat.SCS2Index.ModuIndexContDiff.SEM;
            sr2 = [cont_diff; scs2_mean; scs2_sem]';
            y2_label = 'Contrast change (%)';

    end % switch
    plotCompare(sr1, sr2, figname, x_label, y1_label, y2_label)

end % if

end % function AggCompare_SCMT_index

% =========================================================================
% subroutines
% =========================================================================
function plotCompare(idx1, idx2, figname, x_label, y1_label, y2_label)
% plot comparison of two indexes from ms-triggered and step-contrast
% responses
% 
% Input(s):
%   idx1        - 1st index = [variables, mean index, sem of index]
%   idx2        - 2nd index
%   figname     - figure name, summary of comparison
%   x_label     - index names
%   y1_label    - variable name of 1st index
%   y2_label    - variable name of 2nd index

x1_mean = idx1(:, 2);
x1_sem  = idx1(:, 3);
x1_up   = x1_mean + x1_sem;
x1_down = x1_mean - x1_sem;
y1 = idx1(:, 1);

x2_mean = idx2(:, 2);
x2_sem  = idx2(:, 3);
x2_up   = x2_mean + x2_sem;
x2_down = x2_mean - x2_sem;
y2 = idx2(:, 1);

figure('name', figname)
[ax,h1, h2] = plotyy(x1_mean, y1, x2_mean, y2);
xlabel(x_label)

% refine plot 1
% h1 = plot(x1_mean, y1);
% ax1 = gca;
hold(ax(1), 'on')
% hold(ax1, 'on')
set(h1, 'LineWidth', 2, 'Marker', 'o')
color1 = get(h1, 'Color');
plot(ax(1), x1_up, y1, x1_down, y1, 'Color', color1)
% plot(ax1, x1_up, y1, x1_down, y1, 'Color', color1)
set(ax(1), 'YDir', 'reverse')
set(get(ax(1), 'YLabel'), 'String', y1_label);
% set(get(ax1, 'YLabel'), 'String', y1_label);

% refine plot 2
% ax2 = axes('Position',get(ax1,'Position'),...
%            'XAxisLocation','top',...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'XColor','k','YColor','k');
% h2 = plot(x2_mean, y2);
hold(ax(2), 'on')
% hold(ax2, 'on')
set(h2, 'LineWidth', 2, 'Marker', 'o')
color2 = get(h2, 'Color');
plot(ax(2), x2_up, y2, x2_down, y2, 'Color', color2)
% plot(ax2, x2_up, y2, x2_down, y2, 'Color', color2)
set(ax(2), 'YDir', 'reverse')
set(get(ax(2), 'YLabel'), 'String', y2_label);
% set(get(ax2, 'YLabel'), 'String', y2_label);

% decide overlap interval
x1_min = min(x1_down);
x1_max = max(x1_up);
x2_min = min(x2_down);
x2_max = max(x2_up);
ints = range_intersection([x1_min, x1_max], [x2_min, x2_max]);

if isempty(ints)
    fprintf('No intersection is found when compared\n')
else
    fprintf('Lower = %f, higher = %f\n', ints(1), ints(2))
    plot(ax(1), ints(1) * ones(1, 2), ylim, 'r', ints(2) * ones(1, 2), ylim, 'r')
end % if

view(-90, 90)

end % fucntion

function plotIdxContLevel(idx_mean, idx_sem, figname, y_label, y_range)

cont = 0:10:100;

figure('name', figname)
errorbar(cont, idx_mean, idx_sem, 'Marker', '.')
xlim([-10 110])
ylim(y_range)

xlabel('Contrast (%)')
ylabel(y_label)

end 

function plotIdxMatrix(idx_mean, idx_sem, figname, y_range)

[m, n] = size(idx_mean);

figure('Name', figname)
for p = 1:n     % row - 1st contrast
    for q = 1:m % col - 2nd contrast
        k = (p - 1) * n + q;
        mean_k = idx_mean(p, q);
        sem_k  = idx_sem(p, q);
        
        if p < q        % increase contrast
            facecolor = 'g';
        elseif p == q   % same
            facecolor = 'y';
        elseif p > q    % decrease
            facecolor = 'r';
        end % if
        edgecolor = facecolor;
        
        subplot(m, n , k)
        bar(mean_k, 'BarWidth', 0.3, 'EdgeColor', edgecolor, 'FaceColor', facecolor)
        hold on
        errorbar(mean_k, sem_k, 'k');
        set(gca, 'XTick', [], 'YTick', [])
        set(gca, 'Box', 'off')
        ylim(y_range)
        drawnow
    end % for
end % for

end % function

function plotIdxContDiff(idx_mean, idx_sem, figname, y_label, y_range)

cont = -100:10:100;
zero_idx = cont == 0;
zero_mean = idx_mean(zero_idx);

figure('name', figname)
errorbar(cont, idx_mean, idx_sem, '.-')
ylim(y_range)
xlim([-110 110])
hold on
plot(xlim, [zero_mean, zero_mean], ':k')

ylabel(y_label)
xlabel('Contrast change (%)')

end % funciton
% [EOF]
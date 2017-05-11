function options = Aggplot_MT_index(current_tag, snames, S)
% AGGPLOT_MT_INDEX Indexes graphs of MS-triggered indexes
% 
% Description:
%       This function plots the indexes calculated for MS-triggered
%       responses.
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

% Copyright 2013-2014 Richard J. Cui. Created: Tue 01/15/2013  9:16:19.248 AM
% $Revision: 0.2 $  $Date: Mon 04/28/2014  4:29:17.340 PM $
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
        
        options.pmt1 = { {'0','{1}'}, 'MT-P1 index' };
        options.pmt2 = { {'0','{1}'}, 'MT-P2 index' };
        options.pmt2_tmt1_diff = { {'0','{1}'}, 'MT-P2-T1 spike rate diff' };
        return
    end
end

% =========================================================================
% get options
% =========================================================================
flag_pmt1 = S.Aggplot_MT_index_options.pmt1;
flag_pmt2 = S.Aggplot_MT_index_options.pmt2;
flag_p2_t1_diff = S.Aggplot_MT_index_options.pmt2_tmt1_diff;

% =========================================================================
% draw indexes
% =========================================================================
% Pmt1 indexes
% ---------------------
if flag_pmt1
    % get data
    dat_var = { 'MTP1Index' };
    dat = CorruiDB.Getsessvars(snames, dat_var);
    
    % *** Absolute spike rate ***
    cl = (0:10:100)';
    sr_mean = dat.MTP1Index.SpikeRate.Mean * 1000;
    sr_sem  = dat.MTP1Index.SpikeRate.SEM * 1000;
    str_idx = 'MTP1Index - spike rate';
    x_label = 'Contrast (%)';
    y_label = 'Spike rate (spikes/s)';
    str_title = 'P_{mt1}';
    
    plot_linear_corr(cl, sr_mean, sr_sem, str_idx, x_label, y_label, str_title)
    
    % *** Spike rate difference ***
    cl = (0:10:100)';
    srd_mean = dat.MTP1Index.SRDiff.Mean * 1000;
    srd_sem  = dat.MTP1Index.SRDiff.SEM * 1000;
    str_idx = 'MTP1Index - spike rate difference';
    x_label = 'Contrast (%)';
    y_label = 'Spike rate difference (spikes/s)';
    str_title = 'P_{mt1}';
    
    plot_linear_corr(cl, srd_mean, srd_sem, str_idx, x_label, y_label, str_title)

end % if

% Pmt2 indexes
% ---------------------
if flag_pmt2
    % get data
    dat_var = { 'MTP2Index' };
    dat = CorruiDB.Getsessvars(snames{1}, dat_var);

    % *** Absolute spike rate ***
    cl = (0:10:100)';
    sr_mean = dat.MTP2Index.SpikeRate.Mean * 1000;
    sr_sem  = dat.MTP2Index.SpikeRate.SEM * 1000;
    str_idx = 'MTP2Index - spike rate';
    x_label = 'Contrast (%)';
    y_label = 'Spike rate (spikes/s)';
    str_title = 'P_{mt2}';

    plot_linear_corr(cl, sr_mean, sr_sem, str_idx, x_label, y_label, str_title)
    
    % *** Spike rate difference ***
    cl = (0:10:100)';
    srd_mean = dat.MTP2Index.SRDiff.Mean * 1000;
    srd_sem  = dat.MTP2Index.SRDiff.SEM * 1000;
    str_idx = 'MTP2Index - spike rate difference';
    x_label = 'Contrast (%)';
    y_label = 'Spike rate difference (spikes/s)';
    str_title = 'P_{mt2}';
    
    plot_linear_corr(cl, srd_mean, srd_sem, str_idx, x_label, y_label, str_title)

end % if

% Pmt2 - Tmt1, spike rate difference
% -------------------------------------
if flag_p2_t1_diff
    
    % get data
    dat_var = { 'MTP2Index' 'MTT1Index' };
    dat = CorruiDB.Getsessvars(snames{1}, dat_var);

    % *** Spike rate difference ***
    p2 = dat.MTP2Index.SpikeRate.Cells;
    t1 = dat.MTT1Index.SpikeRate.Cells;
    d  = p2 - t1;
    N = size(d, 1);     % number of cells
    
    cl = (0:10:100)';
    d_mean = mean(d, 2) * 1000;
    d_sem = std(d, [], 2) / sqrt(N) * 1000;
    str_idx = 'MTP2, MTT1 spike rate difference';
    x_label = 'Conrast (%)';
    y_label = 'Spike rate difference (spikes/s)';
    str_title = 'P_{mt2} - T_{mt1}';
    
    plot_linear_corr(cl, d_mean, d_sem, str_idx, x_label, y_label, str_title)
end % if


end % function Aggplot_MT_index

% =========================================================================
% subroutines
% =========================================================================
function plot_linear_corr(x, y, er, str_idx, x_label, y_label, str_title)

[c, gof] = fit(x, y, 'poly1');
disp(str_idx)
disp('Model:')
disp(c)
disp('Goodness of fit:')
disp(gof)

[r, p] = corr(x, y);
fprintf('r = %g, p = %g\n', r, p)

figure
errorbar(x, y, er, 'o')
xlim([min(x), max(x)])
hold on
plot(c, 'r')
xlabel(x_label)
ylabel(y_label)
title(str_title)

end % function


% [EOF]
function out = Plot_mSaccConSig(current_tag, sname, S)
% PLOT_MSACCCONSIG plots information in mSaccConSig structure.
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
% See also getSessInfo.

% Copyright 2014 Richard J. Cui. Created: Fri 06/08/2012  4:22:08.402 PM
% $Revision: 0.3 $  $Date: Wed 02/19/2014  4:10:30.722 PM $
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
        
        options.Single_trial = { {'0','{1}'}, 'Show single trial' };
        options.Single_trial_options.Contrast_1st = {0 '* (%)' [0 100]};
        options.Single_trial_options.Contrast_2nd = {0 '* (%)' [0 100]};
        options.Single_trial_options.Cycle_number = {1 '' [1 10]};
        out = options;
        return
    end
end

% =========================================================================
% get data wanted
% =========================================================================
dat_var = {'mSaccConSig'};
dat = CorruiDB.Getsessvars(sname, dat_var);

mSaccConSig = dat.mSaccConSig;

flag_single = S.Plot_mSaccConSig_options.Single_trial;
cont1 = S.Plot_mSaccConSig_options.Single_trial_options.Contrast_1st;
cont2 = S.Plot_mSaccConSig_options.Single_trial_options.Contrast_2nd;
cyc_num = S.Plot_mSaccConSig_options.Single_trial_options.Cycle_number;

% =========================================================================
% plot
% =========================================================================
% Single trial
% ------------
if flag_single
    condnum = Cont2Condnum(cont1, cont2);
    stim_stage1 = mSaccConSig(condnum, 1);
    stim_stage2 = mSaccConSig(condnum, 2);
    stim_stage3 = mSaccConSig(condnum, 3);
    
    % time index
    t1 = stim_stage1.eye_position.time_index(:, cyc_num);
    t1_idx = t1 - t1(1) + 1;
    t2 = stim_stage2.eye_position.time_index(:, cyc_num);
    t2_idx = t2 - t2(1) + 1 + t1_idx(end);
    t3 = stim_stage3.eye_position.time_index(:, cyc_num);
    t3_idx = t3 - t3(1) + 1 + t2_idx(end);
    time = [t1_idx; t2_idx; t3_idx] - t1_idx(1);    % start form zero
    
    % eye positions
    ep1_x = stim_stage1.eye_position.signal(:, cyc_num, 1);
    ep1_y = stim_stage1.eye_position.signal(:, cyc_num, 2);
    ep2_x = stim_stage2.eye_position.signal(:, cyc_num, 1);
    ep2_y = stim_stage2.eye_position.signal(:, cyc_num, 2);
    ep3_x = stim_stage3.eye_position.signal(:, cyc_num, 1);
    ep3_y = stim_stage3.eye_position.signal(:, cyc_num, 2);
    
    ep_x = [ep1_x; ep2_x; ep3_x];
    ep_y = [ep1_y; ep2_y; ep3_y];
    
    % spike times
    spk1 = stim_stage1.spikes{cyc_num};
    if spk1 == 0
        spk1_idx = [];
    else
        spk1_idx = spk1 - t1(1) + 1;
    end 
    spk2 = stim_stage2.spikes{cyc_num};
    if spk2 == 0
        spk2_idx = [];
    else
        spk2_idx = spk2 - t2(1) + 1 + t1_idx(end);
    end % if
    spk3 = stim_stage3.spikes{cyc_num};
    if spk3 == 0 
        spk3_idx = [];
    else
        spk3_idx = spk3 - t3(1) + 1 + t2_idx(end);
    end % if
    
    spktimes  = [spk1_idx; spk2_idx; spk3_idx] - t1_idx(1);      % start from zero
    
    % plot
    figure
    subplot(2, 1, 1)
    plot(time, [ep_x, ep_y])
    axis tight
    set(gca, 'YLimMode', 'auto')
    hold on
    plot([t2_idx(1) - t1_idx(1), t2_idx(1) - t1_idx(1)], ylim, 'r:')
    plot([t3_idx(1) - t1_idx(1), t3_idx(1) - t1_idx(1)], ylim, 'r:')
    
    subplot(2, 1, 2)
    stem(spktimes, ones(length(spktimes), 1), 'Marker', 'None')
    xlim([time(1) time(end)])
    hold on
    plot([t2_idx(1) - t1_idx(1), t2_idx(1) - t1_idx(1)], ylim, 'r:')
    plot([t3_idx(1) - t1_idx(1), t3_idx(1) - t1_idx(1)], ylim, 'r:')

end % fi


end % function Plot_mSaccConSig

% [EOF]

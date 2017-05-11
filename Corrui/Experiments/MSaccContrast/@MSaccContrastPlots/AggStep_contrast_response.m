function options = AggStep_contrast_response(current_tag, snames, S)
% AGGSTEP_CONTRAST_RESPONSE This function plots the 
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
% $Revision: 0.1 $  $Date: Wed 06/13/2012  9:22:49.710 AM $
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
        options.max_y = {10 '' [-2 100] };
        options.min_y = {-1.5 '' [-2 100]};
        options.window_before_step_onset = {500 '' [0 2000]};
        options.window_after_step_onset = {1050 '' [0 2000]};
        options.Selected_trials = { {'0','{1}'} };
        options.All_trials = { {'0','{1}'} };
        options.Compare_trials = { {'0','{1}'} };
        options.Post_onset_FR_compare = { {'0','{1}'} };
        
        %         options = [];
        
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'ConEnvVars', 'StepDynamicFiringRate', 'StepNoExcludeFr', 'StepUsaccOnlyFr', ...
           'StepWinCenter', 'StepZ_AllFR', 'StepZ_DFR',...
           'PostOnsetFRForSelectedTrials', 'PostOnsetFRForAllTrials', ...
           'PostOnsetFRForUsaccOnly'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);

envvar  = dat.ConEnvVars;
dfr     = dat.StepDynamicFiringRate;
nefr    = dat.StepNoExcludeFr;
uofr    = dat.StepUsaccOnlyFr;
winc    = dat.StepWinCenter;
z_allfr = dat.StepZ_AllFR;
z_dfr   = dat.StepZ_DFR;

grattime = envvar.grattime;
min_y = S.AggStep_contrast_response_options.min_y;
max_y = S.AggStep_contrast_response_options.max_y;
wina  = S.AggStep_contrast_response_options.window_before_step_onset;
winb  = S.AggStep_contrast_response_options.window_after_step_onset;
Selected_trials = S.AggStep_contrast_response_options.Selected_trials;
All_trials = S.AggStep_contrast_response_options.All_trials;
Compare_trials = S.AggStep_contrast_response_options.Compare_trials;
Post_onset_FR_compare = S.AggStep_contrast_response_options.Post_onset_FR_compare;

PostOnsetFRForSelectedTrails = dat.PostOnsetFRForSelectedTrials;
PostOnsetFRForAllTrials = dat.PostOnsetFRForAllTrials;
PostOnsetFRForUsaccOnly = dat.PostOnsetFRForUsaccOnly;

% ========================
% plot step response
% ========================
% set contrast change point as time zero
step_winc = winc - grattime;

% no selection, all firing rate
% -----------------------------
% for k = 1:11
%     g_k = ((k-1)*11+1):(k*11);
%     nefr_k = nefr(:, g_k);
%     figure('Position', [1914, 141, 247, 734])
%     for m = 1:10
%         subplot(10,1,m), plot(step_winc, nefr_k(:,m),'b', 'LineWidth', 2);
%         xlim([-wina, winb])
%         hold on
%         ylim([min_y max_y])
%         plot([0, 0], ylim, 'r')
%         set(gca, 'Box', 'off')
%         if m ~= 10
%             set(gca, 'XTickLabel', [])
%         end % if
%     end % for
% end % for

if All_trials
plotFRmatrix(step_winc, nefr, wina, winb, min_y, max_y)
end

% selected trials
% ---------------
if Selected_trials
plotFRmatrix(step_winc, dfr, wina, winb, min_y, max_y)
end

% compare
% ---------
if Compare_trials
    compFRmatrix(step_winc, dfr, nefr, uofr, wina, winb, min_y, max_y)
end


% ---------------------------------------
% plot post-onset FR comparison
% ---------------------------------------
if Post_onset_FR_compare
    mSelectFr = PostOnsetFRForSelectedTrails.mean;
    semSelectFr = PostOnsetFRForSelectedTrails.sem;
    
    mAllFr = PostOnsetFRForAllTrials.mean;
    semAllFr = PostOnsetFRForAllTrials.sem;
    
    mUoFr = PostOnsetFRForUsaccOnly.mean;
    semUoFr = PostOnsetFRForUsaccOnly.sem;
    
    cont = 0:10:100;
    figure
    errorbar(cont, mSelectFr, semSelectFr, 'color', [0 0.5 0])
    hold on
    errorbar(cont, mAllFr, semAllFr, 'b')
    errorbar(cont, mUoFr, semUoFr, 'r')
    
    xlim([-5 105])
    plot(xlim, [0 0], 'r:')
end %if

end % function Plot_ABS_Example

% ========================
% subroutines
% ========================
function plotFRmatrix(step_winc, fr, wina, winb, min_y, max_y)

for k = 1:11
    g_k = ((k-1)*11+1):(k*11);
    fr_k = fr(:, g_k);
    figure('Position', [914, 141, 247, 734])
    for m = 1:11
        subplot(11,1,m), plot(step_winc, fr_k(:,m),'b', 'LineWidth', 2);
        xlim([-wina, winb])
        hold on
        ylim([min_y max_y])
        plot([0, 0], ylim, 'r')
        set(gca, 'Box', 'off')
        %         if m ~= 11
        %             set(gca, 'XTickLabel', [])
        %         end % if
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
        
    end % for
end % for

end % function

function compFRmatrix(step_winc, fr1, fr2, fr3, wina, winb, min_y, max_y)

for k = 1:11
    g_k = ((k-1)*11+1):(k*11);
    fr1_k = fr1(:, g_k);
    fr2_k = fr2(:, g_k);
    fr3_k = fr3(:, g_k);
    figure('Position', [243, 165, 247, 734])
    for m = 1:11
        subplot(11,1,m)
        plot(step_winc, fr1_k(:,m),'color', [0 0.5 0], 'LineWidth', 2);
        hold on
        plot(step_winc, fr2_k(:,m),'b', 'LineWidth', 2);
        plot(step_winc, fr3_k(:,m),'r', 'LineWidth', 2);
        
        xlim([-wina, winb])
        ylim([min_y max_y])
        plot([0, 0], ylim, 'r')
        set(gca, 'Box', 'off')
        %         if m ~= 11
        %             set(gca, 'XTickLabel', [])
        %         end % if
        set(gca, 'XTickLabel', [])
        set(gca, 'YTickLabel', [])
    end % for
end % for



end % function

% [EOF]
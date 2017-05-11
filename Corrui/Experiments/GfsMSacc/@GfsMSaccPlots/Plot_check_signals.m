function result_dat = Plot_check_signals(current_tag, sname, S)
% GFSMSACCPLOTS.PLOT_CHECK_SIGNALS plot signals to check them manually
%
% Syntax:
%   opt = aggplot_LFPSpectrum(current_tag, sname, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 07/09/2016 11:44:35.375 PM
% $ Revision: 0.1 $  $ Date: Sun 07/10/2016 10:23:22.690 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
	opt.Eye_samples = { {'0','{1}'} };
	opt.LFP_signals = { {'0','{1}'} };
	opt.MUA_signals = { {'0','{1}'} };

    result_dat = opt;
	return
end % if

% =========================================================================
% Get options and parameters
% =========================================================================
check_es  = S.([mfilename, '_options']).Eye_samples;
check_lfp = S.([mfilename, '_options']).LFP_signals;
check_mua = S.([mfilename, '_options']).MUA_signals;

% =========================================================================
% Get data
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);
sess_info = curr_exp.db.Getsessvar(sname, 'SessInfo');

% =========================================================================
% Plot
% =========================================================================
if check_es == true
    plot_check_eyesamples(curr_exp, sname, sess_info)
end % if

if check_lfp == true
    plot_check_lfp(curr_exp, sname, sess_info)
end % if

if check_mua == true
    plot_check_mua(curr_exp, sname, sess_info)
end % if

result_dat = [];

end % function Plot_check_signals

% =========================================================================
% Subroutines
% =========================================================================
function showES(es, fname, si)

trl_len = si.TrialLength;
tag_on  = si.TargetOnset;
sur_on  = tag_on + si.SurroundOnset;

% wave form
figure('Name', fname)
subplot(2, 1, 1)
plot(es.x)
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
xlim([1 trl_len])
title('X - Signal')
ylabel('Amplitude (dva)')


subplot(2, 1, 2)
plot(es.y)
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
title('Y - Signal')
xlim([1 trl_len])
xlabel('Time (ms)')
ylabel('Amplitude (dva)')

% image
figure('Name', fname)
subplot(2, 1, 1)
imagesc(es.x')
% colormap('jet')
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
title('X - Signal')
ylabel('Trials')

subplot(2, 1, 2)
imagesc(es.y')
% colormap('jet')
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
title('Y - Signal')
ylabel('Trials')
xlabel('Time (ms)')

end % funciton

function plot_check_eyesamples(curr_exp, sname, sess_info)

% SubjDisp
% --------
es_subjdis = curr_exp.db.Getsessvar(sname, 'EyesamplesSubjdisp');
showES(es_subjdis, 'Eye Samples SubjDisp', sess_info)

% SubjNoDisp
% --------
es_subjnodis = curr_exp.db.Getsessvar(sname, 'EyesamplesSubjnodisp');
showES(es_subjnodis, 'Eye Samples SubjNoDisp', sess_info)

end % function

function show1Chan(s, fname, si)

trl_len = si.TrialLength;
tag_on  = si.TargetOnset;
sur_on  = tag_on + si.SurroundOnset;

figure('Name', fname)

% wave form
subplot(2, 1, 1)
plot(s)
% colormap('jet')
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
xlim([1 trl_len])
xlabel('Time (ms)')
ylabel('Amplitude (\muV)')

% image
subplot(2, 1, 2)
imagesc(s')
hold on
plot([1 1]'*[tag_on, sur_on], ylim, 'LineWidth', 2)
xlabel('Time (ms)')
ylabel('Trials')

end % function

function showLfpMua(s, fname, sess_info)

num_ch = size(s, 2);
for k = 1:num_ch
    s_k = squeeze(s(:, k, :));
    fname_k = sprintf('%s Ch: %g', fname, k);
    show1Chan(s_k, fname_k, sess_info);
end % for

end % function

function plot_check_lfp(curr_exp, sname, sess_info)

% SubjDisp
% --------
lfp_subjdis = curr_exp.db.Getsessvar(sname, 'LfpSubjdisp');
showLfpMua(lfp_subjdis, 'LFP SubjDisp', sess_info)

% SubjNoDisp
% --------
lfp_subjnodis = curr_exp.db.Getsessvar(sname, 'LfpSubjnodisp');
showLfpMua(lfp_subjnodis, 'LFP SubjNoDisp', sess_info)

% PhysDisp
% --------
lfp_physdis = curr_exp.db.Getsessvar(sname, 'LfpPhysdisp');
showLfpMua(lfp_physdis, 'LFP PhysDisp', sess_info)

end % function

function plot_check_mua(curr_exp, sname, sess_info)

% SubjDisp
% --------
mua_subjdis = curr_exp.db.Getsessvar(sname, 'MuaSubjdisp');
showLfpMua(mua_subjdis, 'MUA SubjDisp', sess_info)

% SubjNoDisp
% --------
mua_subjnodis = curr_exp.db.Getsessvar(sname, 'MuaSubjnodisp');
showLfpMua(mua_subjnodis, 'MUA SubjNoDisp', sess_info)

% PhysDisp
% --------
mua_physdis = curr_exp.db.Getsessvar(sname, 'MuaPhysdisp');
showLfpMua(mua_physdis, 'MUA PhysDisp', sess_info)

end % function

% [EOF]

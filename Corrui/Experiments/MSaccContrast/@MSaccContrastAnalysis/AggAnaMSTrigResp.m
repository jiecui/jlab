function result_dat = AggAnaMSTrigResp(current_tag, name, S, dat)
% AGGANAMSTRIGRESP (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2013-2015 Richard J. Cui. Created: 05/01/2013 10:32:44.512 PM
% $Revision: 0.2 $  $Date: Sat 05/03/2014 11:32:50.343 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    %     opt.tfmethod = {'{affine}|lwm'};
    %     opt.Latency = {30 '* (ms)' [0 1000]};
    %     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
    %         % outside the fix grid more than SMThres * STDs will be discarded
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};
    
    %     opt.Usacc_rate_smoothing_Window_half_width = {100, '* (ms)', [1 2000]};     % 125
    % opt.Usacc_rate_option = {'Rate|{YN NPMovWin}|YN Locfit'};     

    opt.intv_selected = { {'{Whole signal}', 'Interval 1', 'Interval 2'}, 'Interested interval for modulation analysis' };
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'MSTriggeredContrastResponse', 'sessions'};
    
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% options
intv_selected = S.Stage_2_Options.([mfilename, '_options']).intv_selected;

% data
sessions = dat.sessions;
ms_trig_resp = dat.MSTriggeredContrastResponse;
spk_temp = ms_trig_resp{1}.SpikeRate;
nlevel = size(spk_temp, 1);
num_cell = length(sessions);

signif_level = zeros(nlevel, num_cell);
for k = 1:num_cell
    siglevel_k = ms_trig_resp{k}.Modulation.SigLevel;
    signif_level(:, k) = siglevel_k(:);
end % for

% modulation index
mod_idx = getModulateIndex(num_cell, ms_trig_resp, intv_selected);

[supp_enha_idx, mass_center, distance, cell_idx_close_mc] = pairModIdx(mod_idx, signif_level);

% spike rate
[spk_cell, spk, spk_norm_cell, spk_norm] = getSpikeRate(num_cell, ms_trig_resp);    % spk_cell: spike rate from all cell, spk: mean and sem
[spk_sig, spk_not_sig, spk_norm_sig, spk_norm_not_sig] = getSigSpikeRate(spk_cell, spk_norm_cell, signif_level);

% other paras
winc = ms_trig_resp{1}.SpikeRateWinCenter;
win_width = ms_trig_resp{1}.Paras.win_width;
pre_ms = ms_trig_resp{1}.Paras.pre_ms;
pre_ms_intv = round(pre_ms + win_width / 2);
post_ms = ms_trig_resp{1}.Paras.post_ms;
post_ms_intv = round(post_ms + win_width / 2);

% =========================================================================
% commit
% =========================================================================
result_dat.Modulation.SignificantCell = signif_level;   % 11 x 31
result_dat.Modulation.SuppEnhaIndex = supp_enha_idx;    % 11 x 2 x 31
result_dat.Modulation.MassCenter = mass_center;     % 11 x 3 x 2 = levels x sig, not, all] x [supp, enha]
result_dat.Modulation.MC2EqualDist = distance;      % 11 x 3
result_dat.Modulation.CellClosestMassCenter = cell_idx_close_mc; % 11 x 3 = [sig, not, all]

result_dat.SpikeRateWinCenter = winc;
result_dat.SpikeRate = spk_cell;
result_dat.SpikeRateMean = spk(:, :, 1);
result_dat.SpikeRateSEM = spk(:, :, 2);

result_dat.SpikeRateSigModulatedMean = spk_sig(:, :, 1);
result_dat.SpikeRateSigModulatedSEM = spk_sig(:, :, 2);
result_dat.SpikeRateNotSigModulatedMean = spk_not_sig(:, :, 1);
result_dat.SpikeRateNotSigModulatedSEM = spk_not_sig(:, :, 2);

result_dat.SpikeRate_Norm = spk_norm_cell;
result_dat.SpikeRateMean_Norm = spk_norm(:, :, 1);
result_dat.SpikeRateSEM_Norm = spk_norm(:, :, 2);

result_dat.SpikeRateSigModulatedMean_Norm = spk_norm_sig(:, :, 1);
result_dat.SpikeRateSigModulatedSEM_Norm = spk_norm_sig(:, :, 2);
result_dat.SpikeRateNotSigModulatedMean_Norm = spk_norm_not_sig(:, :, 1);
result_dat.SpikeRateNotSigModulatedSEM_Norm = spk_norm_not_sig(:, :, 2);

result_dat.PreMSIntv = pre_ms_intv;
result_dat.PostMSIntv = post_ms_intv;

end % function AggAnaMSTrigResp

% =========================================================================
% subroutines
% =========================================================================
function fr_sig = getFRSig(sig, fr)

sig_spk = fr(:, sig);
sig_spk_mean = mean(sig_spk, 2);
sig_spk_sem = std(sig_spk, [], 2) / sqrt(sum(sig));
fr_sig = cat(2, sig_spk_mean, sig_spk_sem);

end

function [spk_sig, spk_not_sig] = sig_or_not_sig(sig, spk)

spk_sig = getFRSig(sig, spk);
spk_not_sig = getFRSig(~sig, spk);

end

function [spk_sig, spk_not_sig, spk_norm_sig, spk_norm_not_sig] = getSigSpikeRate(spk_cell, spk_norm_cell, signif_level)

nlevel = size(spk_cell, 1);
spk_sig = [];
spk_not_sig = [];
spk_norm_sig = [];
spk_norm_not_sig = [];
for k = 1:nlevel
   
    sig_k = logical(signif_level(k, :));
    
    spk_k = squeeze(spk_cell(k, :, :));
    [spk_sig_k, spk_not_sig_k] = sig_or_not_sig(sig_k, spk_k);
    spk_sig = cat(3, spk_sig, spk_sig_k);
    spk_not_sig = cat(3, spk_not_sig, spk_not_sig_k);
    
    spk_norm_k = squeeze(spk_norm_cell(k, :, :));
    [spk_norm_sig_k, spk_norm_not_sig_k] = sig_or_not_sig(sig_k, spk_norm_k);
    spk_norm_sig = cat(3, spk_norm_sig, spk_norm_sig_k);
    spk_norm_not_sig = cat(3, spk_norm_not_sig, spk_norm_not_sig_k);

end
spk_sig = permute(spk_sig, [3,1,2]);
spk_not_sig = permute(spk_not_sig, [3,1,2]);
spk_norm_sig = permute(spk_norm_sig, [3,1,2]);
spk_norm_not_sig = permute(spk_norm_not_sig, [3,1,2]);

end

function [sr_cell, spike_rate, sr_norm_cell, spike_rate_norm] = getSpikeRate(num_cell, ms_trig_resp)
% sr_cell       - spike rate of all cell
% spike_rate    - mean and sem

sr_cell = [];
sr_norm_cell = [];
for k = 1:num_cell
    sr_k = ms_trig_resp{k}.SpikeRate;
    sr_norm_k = ms_trig_resp{k}.SpikeRateNormalized;
    
    sr_cell = cat(3, sr_cell, sr_k);
    sr_norm_cell = cat(3, sr_norm_cell, sr_norm_k);
end % for

% replace NaN to zero
sr_cell(isnan(sr_cell)) = 0;
sr_mean = mean(sr_cell, 3);
sr_sem = std(sr_cell, [], 3)/sqrt(num_cell);
spike_rate = cat(3, sr_mean, sr_sem);

% replace NaN to zero
sr_norm_cell(isnan(sr_norm_cell)) = 0;
sr_mean_norm = mean(sr_norm_cell, 3);
sr_sem_norm = std(sr_norm_cell, [], 3) / sqrt(num_cell);
spike_rate_norm = cat(3, sr_mean_norm, sr_sem_norm);

end

function idx_pair = getIndexPair(mod_struct)

num_cell = length(mod_struct);
idx_pair = [];
for k = 1:num_cell
    supp_idx_k = mod_struct(k).Suppression.Index;
    enha_idx_k = mod_struct(k).Enhancement.Index;
    idx_pair_k = [supp_idx_k(:), enha_idx_k(:)];
    
    idx_pair = cat(3, idx_pair, idx_pair_k);
end % for

end

function [mass_center, distance] = getMassCenter(supp_enha_idx, signif_level)
% distance : distance between mass center and equale line

nlevel = size(supp_enha_idx, 1);
mass_center = [];
distance = [];
for k = 1:nlevel
    idx_pair_k = squeeze(supp_enha_idx(k, :, :));
    sig_k = logical(signif_level(k, :));
    
    % all
    mc_all = mean(idx_pair_k, 2);
    dis_all = diff(mc_all) / sqrt(2); % minus --> suppression
    
    % significant
    mc_sig = mean(idx_pair_k(:, sig_k), 2);
    dis_sig = diff(mc_sig) / sqrt(2);
    
    % not significant
    mc_not = mean(idx_pair_k(:, ~sig_k), 2);
    dis_not = diff(mc_not) / sqrt(2);
    
    mass_center = cat(3, mass_center, [mc_sig, mc_not, mc_all]);
    distance = cat(1, distance, [dis_sig, dis_not, dis_all]);
    
    
end % for

mass_center = permute(mass_center, [3, 2, 1]);

end

function cell_idx = getCellIndexCloseMC(idx_pair, mc, signif_level)

nlevel = size(idx_pair, 1);
num_cell = size(idx_pair, 3);
cell_idx = zeros(nlevel, 3);
for k = 1:nlevel
    idx_pair_k = squeeze(idx_pair(k, :, :)).';  % cell x 2
    sig_k = logical(signif_level(k, :));
    mc_k = squeeze(mc(k, :, :));
    
    % sig
    sig_seq = find(sig_k);
    dif = idx_pair_k(sig_k, :) - repmat(mc_k(1,:), [sum(sig_k), 1]);
    dist = hypot(dif(:, 1), dif(:, 2));
    [~, sig_min_idx] = min(dist);
    sig_cell_seq = sig_seq(sig_min_idx);
    
    % not
    not_seq = find(~sig_k);
    dif = idx_pair_k(~sig_k, :) - repmat(mc_k(2,:), [sum(~sig_k), 1]);
    dist = hypot(dif(:, 1), dif(:, 2));
    [~, not_min_idx] = min(dist);
    not_cell_seq = not_seq(not_min_idx);
    
    % all
    dif = idx_pair_k - repmat(mc_k(3,:), [num_cell, 1]);
    dist = hypot(dif(:, 1), dif(:, 2));
    [~, all_min_seq] = min(dist);
    
    if ~(isempty(sig_cell_seq) || isempty(not_cell_seq) || isempty(all_min_seq))
        cell_idx(k, :) = [sig_cell_seq, not_cell_seq, all_min_seq];
    else
        cell_idx(k, :) = [NaN, NaN, NaN];
    end
end

end

function [supp_enha_idx, mass_center, distance, cell_idx_close_mc] = pairModIdx(mod_idx, signif_level)

% index pair
supp_enha_idx = getIndexPair(mod_idx);

% mass center of each level
[mass_center, distance] = getMassCenter(supp_enha_idx, signif_level);   % 11 x 3 x 2 = [significant, not, all]

% cell index that closest to mass center
cell_idx_close_mc = getCellIndexCloseMC(supp_enha_idx, mass_center, signif_level);   % 11 x 3 = [significant, not, all]

end 


function mod_idx = getModulateIndex(num_cell, ms_trig_resp, intv_selected)

mod_idx = [];

for k = 1:num_cell
    mod_idx_k = ms_trig_resp{k}.Modulation.ModIndex;
    
    switch intv_selected
        case 'Whole signal'
            mod_idx_k = mod_idx_k.WholeSignal;
        case 'Interval 1'
            mod_idx_k = mod_idx_k.Interval1;
        case 'Interval 2'
             mod_idx_k = mod_idx_k.Interval2;
    end % switch
    
    mod_idx = cat(2, mod_idx, mod_idx_k);
end % for


end



% [EOF]

function [imported_data, stage0_data] = stage0process(this, sname, options)
% GFSMSACC.STAGE0PROCESS PreProcess trial infomation in Stage 0
%
% Syntax:
%
% Input(s):
%   this        - GfsMsacc object
%   sname       - get session name
%   options     - stage 0 options
% 
% Output:
% 
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Thu 07/07/2016  8:00:58.609 PM
% $Revision: 0.2 $  $Date: Tue 08/02/2016  1:06:19.132 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Prepare data for processing
% =========================================================================
% get the options
% ---------------
rm_spk = options.Stage_0_Options.rm_mua_spk;
rms_options = options.Stage_0_Options.Remove_MUA_spikes_options;

% get the variables from the imported data
% ---------------------------------------------
vars = {'info'};
imported_data = this.db.Getsessvars( sname, vars );

% -- process trial infomation -- 
checksigs_data = processTrial( this, sname );

% -- remove big spikes in MUA --
if rm_spk == true
    cprintf('Text', '\t-->Checking Spikes in MUA... ')
    mua_data.SubjDisp   = checksigs_data.MuaSubjdisp;
    mua_data.SubjNoDisp = checksigs_data.MuaSubjnodisp;
    mua_data.PhysDisp   = checksigs_data.MuaPhysdisp;
    
    rmmuaspikes_data = rmMUASpikes( mua_data, rms_options );
    cprintf('Comments', 'Done.\n')
else
    rmmuaspikes_data = [];
end % if

% results
stage0_data = mergestructs(checksigs_data, rmmuaspikes_data);

end % function stage0process

% =========================================================================
% subroutines
% =========================================================================
function spks = find_mua_big_spks(mua, thrs)
% find abnormal spike artifacts in MUA
% 
% Inputs:
%   mua         - MUA in sig_len x channels
%   thrs        - threshold in STD
% 
% Outputs:
%   spks        - identified big spikes in 2 x N array, where 1st col. is
%                 the index of channel and 2nd col. is the position of the
%                 peak.

num_chs = size(mua, 2);

% find peaks
% ----------
pks_yn = false(size(mua));
for k = 1:num_chs
    mua_k = mua(:, k);
    [~, locs_k] = findpeaks(mua_k);
    pks_yn(locs_k, k) = true;
end % for

% find above-threshold peaks
% --------------------------
pk_val = mua .* pks_yn;
large_pks_yn = false(size(mua));
sd = std(mua);
for k = 1:num_chs
    large_pks_yn(:, k) = pk_val(:, k) > thrs * sd(k);
end % for

% determine spikes
% ----------------
% (1) must have an above-threshold peak at a time instant
a = sum(large_pks_yn, 2);
lgpk_pos = find(a > 0);    % if large peak at that time position
% (2) at least two peaks at that position across channels
num_lgpks = numel(lgpk_pos);  % number of large peaks
spikes = [];      % time x channel
for k = 1:num_lgpks
    pos_k = lgpk_pos(k);
    pksyn_k = pks_yn(pos_k, :);
    ch_k = find(pksyn_k > 0);
    num_ch_k = numel(ch_k);
    if num_ch_k >= 2
        % cprintf('Keywords', 'MUA spikes under %s for trial % d at %d ms in channels %s\n',...
        %     cond_str, trl, pos_k, num2str(ch_k))
        for j = 1:num_ch_k
            spikes = cat(1, spikes, [pos_k, ch_k(j)]);
        end % for
    end % if
end % for
% sort according to channels
if isempty(spikes) == true
    spks = spikes;
else
    spikes_ch = spikes(:, 2);
    [s_ch, ch_idx] = sort(spikes_ch);
    spks = [s_ch, spikes(ch_idx, 1)];
end % if

end % function

function rmmua_1ch = rm_spks_one_ch(mua_1ch, pos)
% remove spikes in one channel of mua

rwidth = 4;     % peak width set at samples

sig_len = length(mua_1ch);
rmmua_1ch = mua_1ch;
for k = 1:numel(pos)
    % remove one spike at a time
    pos_k = pos(k);
    switch pos_k
        case {1, 2}
            r_k = 1:rwidth;     % spike position range
        case {sig_len - 1, sig_len - 2}
            r_k = sig_len - (rwidth - 1):sig_len;
        otherwise
            r_k = pos_k - 1:pos_k + (rwidth - 2);
    end % switch
    % randamly select a segment from residual mua
    res_k = mua_1ch;
    res_k(r_k) = [];
    p_k = randi(length(res_k) - rwidth + 1);
    subs_k = res_k(p_k:p_k + rwidth - 1);     
    % use the subsitute to eliminate the spike
    rmmua_1ch(r_k) = subs_k;
end % for

end % function

function rm_mua = rm_mua_spks(mua, spks)
% remove MUA spikes
% 
% Input(s):
%   mua         - MUA signals [sig_len, channels]
%   spks        - spikes positions [channel, time instants]
% 
% Output(s):
%   rm_mua      - spike removed MUA

rm_mua = mua;

if isempty(spks) == false
    chs = unique(spks(:, 1));
    for k = 1:numel(chs)
        ch_k = chs(k);
        pos_k = spks(spks(:, 1) == ch_k, 2);
        rm_mua_k = rm_spks_one_ch(mua(:, ch_k), pos_k);
        rm_mua(:, ch_k) = rm_mua_k;
    end % for
end % if

end % function

function rms_cond = rm_mua_spk_cond(mua, thrs)
% remove spikes of MUA under a specific condition

rms_cond = zeros(size(mua));

num_trls = size(mua, 3);    % signal length, number of channels, number of trials
% hw = waitbar(0, sprintf('Checking MUA spikes under %s...', cond_str));
for k = 1:num_trls
    % waitbar(k / num_trls, hw);
    mua_k = squeeze(mua(:, :, k));
    spks_k = find_mua_big_spks(mua_k, thrs);
    rms_mua_k = rm_mua_spks(mua_k, spks_k);     % spikes removed mua
    rms_cond(:, :, k) = rms_mua_k;
end % for
% delete(hw)

end % function

function new_mua = rmMUASpikes( mua_data, opt )
% remove big spikes in MUA

thrs = opt.threshold;   % criterion of 'big' spikes, number of STD

% SubjDisp
% --------
mua_subjdisp = mua_data.SubjDisp;
rms_subjdisp = rm_mua_spk_cond(mua_subjdisp, thrs);

% SubjNoDisp
% --------
mua_subjnodisp = mua_data.SubjNoDisp;
rms_subjnodisp = rm_mua_spk_cond(mua_subjnodisp, thrs);

% PhysDisp
% --------
mua_physdisp = mua_data.PhysDisp;
rms_physdisp = rm_mua_spk_cond(mua_physdisp, thrs);

% commit
% ------
new_mua.MuaSubjdisp    = rms_subjdisp;  % spike removed MUA
new_mua.MuaSubjnodisp  = rms_subjnodisp;
new_mua.MuaPhysdisp    = rms_physdisp;

end % function

function out_es = checkEyeSamples(this, sname, gms_trl)

trl_len     = gms_trl.TrialLength;
trl_num_subjdisp = gms_trl.SubjDispTrialNumber;

cprintf('Text', '\t-->Checking EyeSamples... ')
% extract data
es = this.db.Getsessvar(sname, 'EyeSamples');
if isfield(es, 'SubjDisp')
    es_subjdisp = es.SubjDisp;
else
    es_subjdisp = [];
    cprintf('SystemCommands', 'EyeSamples has no SubjDisp, ')
end % if

if isfield(es, 'SubjNoDisp')
    es_subjnodisp = es.SubjNoDisp;
else
    es_subjnodisp = [];
    cprintf('SystemCommands', 'EyeSamples has no SubjDisp, ')
end % if

% checking signal/channel info
if ~isempty(es_subjdisp)
    [es_len_x, es_trlnum_x] = size(es_subjdisp.x);
    if es_len_x ~= trl_len
        cprintf('SystemCommands', 'EyeSample SubjDisp X length is not consistent, ')
    end % if
    if es_trlnum_x ~= trl_num_subjdisp
        cprintf('SystemCommands', 'EyeSample SubjDisp X trial number is not consistent, ')
    end % if
    [es_len_y, es_trlnum_y] = size(es_subjdisp.y);
    if es_len_y ~= trl_len
        cprintf('SystemCommands', 'EyeSample SubjDisp Y length is not consistent, ')
    end % if
    if es_trlnum_y ~= trl_num_subjdisp
        cprintf('SystemCommands', 'EyeSample SubjDisp Y trial number is not consistent, ')
    end % if
end % if

if ~isempty(es_subjnodisp)
    es_len_x = size(es_subjnodisp.x, 1);
    if es_len_x ~= trl_len
        cprintf('SystemCommands', 'EyeSample SubjNoDisp X length is not consistent, ')
    end % if
    es_len_y = size(es_subjnodisp.y, 1);
    if es_len_y ~= trl_len
        cprintf('SystemCommands', 'EyeSample SubjNoDisp Y length is not consistent, ')
    end % if
end % if

cprintf('Comments', 'Done.\n')
out_es.EyesamplesSubjdisp   = es_subjdisp;
out_es.EyesamplesSubjnodisp = es_subjnodisp;

end % function

function out_lfp = checkLFP(this, sname, gms_trl)

trl_len     = gms_trl.TrialLength;
num_chan    = gms_trl.ChannelNumber;
trl_num_subjdisp = gms_trl.SubjDispTrialNumber;

cprintf('Text', '\t-->Checking LFP... ')
% extract data
lfp = this.db.Getsessvar(sname, 'LFP');
if isfield(lfp, 'SubjDisp')
    lfp_subjdisp = lfp.SubjDisp;
else
    lfp_subjdisp = [];
    cprintf('SystemCommands', 'LFP has no SubjDisp, ')
end % if

if isfield(lfp, 'SubjNoDisp')
    lfp_subjnodisp = lfp.SubjNoDisp;
else
    lfp_subjnodisp = [];
    cprintf('SystemCommands', 'LFP has no SubjDisp, ')
end % if

if isfield(lfp, 'PhysDisp')
    lfp_physdisp = lfp.PhysDisp;
else
    lfp_physdisp = [];
    cprintf('SystemCommands', 'LFP has no PhysDisp, ')
end % if

% checking signal/channel info
if ~isempty(lfp_subjdisp)
    [lfp_len, lfp_chnum, lfp_trlnum] = size(lfp_subjdisp);
    if lfp_len ~= trl_len
        cprintf('SystemCommands', 'LFP SubjDisp length is not consistent, ')
    end % if
    if lfp_chnum ~= num_chan
        cprintf('SystemCommands', 'LFP SubjDisp channel number is not consistent, ')
    end % if
    if lfp_trlnum ~= trl_num_subjdisp
        cprintf('SystemCommands', 'LFP SubjDisp trial number is not consistent, ')
    end % if
    checkDeadChan(lfp_subjdisp, 'LFP SubjDisp')
end % if

if ~isempty(lfp_subjnodisp)
    [lfp_len, lfp_chnum, ~] = size(lfp_subjnodisp);
    if lfp_len ~= trl_len
        cprintf('SystemCommands', 'LFP SubjNoDisp length is not consistent, ')
    end % if
    if lfp_chnum ~= num_chan
        cprintf('SystemCommands', 'LFP SubjNoDisp channel number is not consistent, ')
    end % if
    checkDeadChan(lfp_subjnodisp, 'LFP SubjNoDisp')
end % if

if ~isempty(lfp_physdisp)
    [lfp_len, lfp_chnum, ~] = size(lfp_physdisp);
    if lfp_len ~= trl_len
        cprintf('SystemCommands', 'LFP PhysDisp length is not consistent, ')
    end % if
    if lfp_chnum ~= num_chan
        cprintf('SystemCommands', 'LFP PhysDisp channel number is not consistent, ')
    end % if
    checkDeadChan(lfp_physdisp, 'LFP PhysDisp')
end % if

cprintf('Comments', 'Done.\n')
out_lfp.LfpSubjdisp   = lfp_subjdisp;
out_lfp.LfpSubjnodisp = lfp_subjnodisp;
out_lfp.LfpPhysdisp   = lfp_physdisp;

end % function

function out_mua = checkMUA(this, sname, gms_trl)

trl_len     = gms_trl.TrialLength;
num_chan    = gms_trl.ChannelNumber;
trl_num_subjdisp = gms_trl.SubjDispTrialNumber;

cprintf('Text', '\t-->Checking MUA... ')
% extract data
mua = this.db.Getsessvar(sname, 'MUA');
if isfield(mua, 'SubjDisp')
    mua_subjdisp = mua.SubjDisp;
else
    mua_subjdisp = [];
    cprintf('SystemCommands', 'MUA has no SubjDisp, ')
end % if

if isfield(mua, 'SubjNoDisp')
    mua_subjnodisp = mua.SubjNoDisp;
else
    mua_subjnodisp = [];
    cprintf('SystemCommands', 'MUA has no SubjDisp, ')
end % if

if isfield(mua, 'PhysDisp')
    mua_physdisp = mua.PhysDisp;
else
    mua_physdisp = [];
    cprintf('SystemCommands', 'MUA has no PhysDisp, ')
end % if

% checking signal/channel info
if ~isempty(mua_subjdisp)
    [mua_len, mua_chnum, mua_trlnum] = size(mua_subjdisp);
    if mua_len ~= trl_len
        cprintf('SystemCommands', 'MUA SubjDisp length is not consistent, ')
    end % if
    if mua_chnum ~= num_chan
        cprintf('SystemCommands', 'MUA SubjDisp channel number is not consistent, ')
    end % if
    if mua_trlnum ~= trl_num_subjdisp
        cprintf('SystemCommands', 'MUA SubjDisp trial number is not consistent, ')
    end % if
    checkDeadChan(mua_subjdisp, 'MUA SubjDisp')
end % if

if ~isempty(mua_subjnodisp)
    [mua_len, mua_chnum, ~] = size(mua_subjnodisp);
    if mua_len ~= trl_len
        cprintf('SystemCommands', 'MUA SubjNoDisp length is not consistent, ')
    end % if
    if mua_chnum ~= num_chan
        cprintf('SystemCommands', 'MUA SubjNoDisp channel number is not consistent, ')
    end % if
    checkDeadChan(mua_subjnodisp, 'MUA SubjNoDisp')
end % if

if ~isempty(mua_physdisp)
    [mua_len, mua_chnum, ~] = size(mua_physdisp);
    if mua_len ~= trl_len
        cprintf('SystemCommands', 'MUA PhysDisp length is not consistent, ')
    end % if
    if mua_chnum ~= num_chan
        cprintf('SystemCommands', 'MUA PhysDisp channel number is not consistent, ')
    end % if
    checkDeadChan(mua_physdisp, 'MUA PhysDisp')
end % if

cprintf('Comments', 'Done.\n')
out_mua.MuaSubjdisp   = mua_subjdisp;
out_mua.MuaSubjnodisp = mua_subjnodisp;
out_mua.MuaPhysdisp   = mua_physdisp;

end % function

function checkDeadChan(s, type_cond)

num_ch = size(s, 2);
for k = 1:num_ch
    c_k = squeeze(s(:, k, :));
    std_k = std(c_k);
    d_k = find(std_k < .2);
    
    if ~isempty(d_k)
        cprintf('SystemCommands', '\nExtremely low signals in %s at Channel %d and Trials %s, ',...
            type_cond, k, num2str(d_k))
    end %
end % for

end % function

function out_dat = processTrial(this, sname)
% Process trial infomation and check data
% 
% Input:
%   in_dat      - data structure of input
% 
% Output:
%   out_dat     - data structure of output

% get trial info
gms_trl = GMSTrial(this, sname);
out_trl.samplerate = gms_trl.samplerate;

% =========================================================================
% process EyeSamples
% =========================================================================
out_es = checkEyeSamples(this, sname, gms_trl);

% =========================================================================
% process LFP
% =========================================================================
out_lfp = checkLFP(this, sname, gms_trl);

% =========================================================================
% process MUA
% =========================================================================
out_mua = checkMUA(this, sname, gms_trl);

% =========================================================================
% commit
% =========================================================================
out_dat = mergestructs( out_trl, out_es, out_lfp, out_mua );

end %funciton

% [EOF]

function result_dat = AggMTIndex1(current_tag, name, S, dat)
% AGGMTINDEX1 Indexes of MS-triggered responses with method 1 (archaic)
% 
% Description:
%   This function calculates various indexes to characterize
%   microsaccade-triggered (MT) neural responses.  This is the first try
%   and an old agrithm. Specifically, the indexes are calculated using
%   averaged spike rate of individual cell at each contrast level.  Peak is
%   simply picked as the max in the given interval.  Trough is the min in
%   the given interval, and sustained rate is the average in the given
%   interval.
%
% Syntax:
%   result_dat = AggMTIndex(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Thu 12/27/2012  5:31:06.844 PM
% $Revision: 0.2 $  $Date: Mon 12/31/2012  8:58:02.262 AM $
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
% Note: all intv are relative to MS onset
%   s1      - steady-state response before the MS
%   s1_intv - s1 is assumed to take place in s1_intv
% 
%   p1      - 1st peak after MS 
%   p1_intv - p1 is assummed to take place in the interval of p1_intv (ms);
%             time is relative to the onset of MS
%   t1      - 1st trough after MS
%   t1_intv -
%   p2      - 2nd peak after MS
%   p2_intv - 
%   s2      -
%   s2_intv -

if strcmpi(current_tag,'get_options')
    opt.intv.s1 = {[-150 0] 'S1 interval (ms)' [-500 0]};   % for steady-state 1
    opt.intv.p1 = {[25 75] 'P1 interval (ms)' [0 200]};     % interval for checking peak 1
    opt.intv.t1 = {[50 150] 'T1 interval (ms)' [1 500]};    % time from onset of contrast 2nd
    opt.intv.p2 = {[150 200] 'P2 interval (ms)' [1 500]};   % time from onset of contrast 2nd
    opt.intv.s2 = {[250 350] 'S2 interval (ms)' [1 500]};
    
    opt.p1_index.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.p1_index.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.p1_index.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.p1_index.mi         = { {'0','{1}'}, 'Modulation index'};

    opt.t1_index.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.t1_index.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.t1_index.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.t1_index.mi         = { {'0','{1}'}, 'Modulation index'};

    opt.p2_index.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.p2_index.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.p2_index.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.p2_index.mi         = { {'0','{1}'}, 'Modulation index'};
    
    opt.s2_index.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.s2_index.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.s2_index.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.s2_index.mi         = { {'0','{1}'}, 'Modulation index'};
    
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'UsaccTriggeredSpikeRate' 'SpikeRateWinCenter' ...
                'PreMSIntv'};
    result_dat = dat_var;
    return
end % if


% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------
s1_intv = S.Stage_2_Options.AggMTIndex1_options.intv.s1;
p1_intv = S.Stage_2_Options.AggMTIndex1_options.intv.p1;
t1_intv = S.Stage_2_Options.AggMTIndex1_options.intv.t1;
p2_intv = S.Stage_2_Options.AggMTIndex1_options.intv.p2;
% s2_intv = S.Stage_2_Options.AggMTIndex1_options.intv.s2;

% options for cal p1 indexes
p1_index_spkrate = S.Stage_2_Options.AggMTIndex1_options.p1_index.spkrate;
p1_index_ratediff = S.Stage_2_Options.AggMTIndex1_options.p1_index.ratediff;
p1_index_perchg = S.Stage_2_Options.AggMTIndex1_options.p1_index.perchg;
p1_index_mi = S.Stage_2_Options.AggMTIndex1_options.p1_index.mi;

% options for cal t1 indexes
t1_index_spkrate = S.Stage_2_Options.AggMTIndex1_options.t1_index.spkrate;
t1_index_ratediff = S.Stage_2_Options.AggMTIndex1_options.t1_index.ratediff;
t1_index_perchg = S.Stage_2_Options.AggMTIndex1_options.t1_index.perchg;
t1_index_mi = S.Stage_2_Options.AggMTIndex1_options.t1_index.mi;

% options for cal p2 indexes
p2_index_spkrate = S.Stage_2_Options.AggMTIndex1_options.p2_index.spkrate;
p2_index_ratediff = S.Stage_2_Options.AggMTIndex1_options.p2_index.ratediff;
p2_index_perchg = S.Stage_2_Options.AggMTIndex1_options.p2_index.perchg;
p2_index_mi = S.Stage_2_Options.AggMTIndex1_options.p2_index.mi;

% options for cal s2 indexes
s2_index_spkrate = S.Stage_2_Options.AggMTIndex1_options.s2_index.spkrate;
% s2_index_ratediff = S.Stage_2_Options.AggMTIndex1_options.s2_index.ratediff;
% s2_index_perchg = S.Stage_2_Options.AggMTIndex1_options.s2_index.perchg;
% s2_index_mi = S.Stage_2_Options.AggMTIndex1_options.s2_index.mi;

% get the data
% -------------
sr = dat.UsaccTriggeredSpikeRate;      % spike rate, contrast x signal x cells
sr_cent = dat.SpikeRateWinCenter;
pre_ms = dat.PreMSIntv;

% get the base spike rate
% -----------------------
intv = s1_intv + pre_ms - 1;
base_s1 = getSteadyBase(sr, intv, sr_cent);

% feature type
% -------------
%   flag_type   - feature type: 0 = steady-state, 1 = peak, 2 = trough
% type_sustained = 0;
type_peak = 1;
type_trougth = 2;

% +++++++++++++++++++++++
% MT-P1 indexes (peak 1)
% +++++++++++++++++++++++
p1_absintv = p1_intv + pre_ms - 1;
flag_type = type_peak;

% *** spike rate ***
if p1_index_spkrate
    % function of condition
    [p1_sr, p1_sr_mean, p1_sr_sem] = getIdxSpikeRate(sr, p1_absintv, sr_cent, flag_type);
    
end % if

% *** spike rate difference ***
if p1_index_ratediff
    [p1_srdif, p1_srdif_mean, p1_srdif_sem] = getIdxSRDiff(sr, p1_absintv, sr_cent, base_s1, flag_type);
end % if

% *** percentage change ***
if p1_index_perchg
        [p1_pg, p1_pg_mean, p1_pg_sem] = getIdxPerchg(sr, p1_absintv, sr_cent, base_s1, flag_type);
end % if

% *** modulation index ***
if p1_index_mi
        [p1_mi, p1_mi_mean, p1_mi_sem] = getIdxMI(sr, p1_absintv, sr_cent, base_s1, flag_type);
end % if

% ++++++++++++++++++++++++++++++
% MT-T1 indexes (trough 1)
% ++++++++++++++++++++++++++++++
t1_absintv = t1_intv + pre_ms - 1;
flag_type = type_trougth;

% *** spike rate ***
if t1_index_spkrate
    % function of condition
    [t1_sr, t1_sr_mean, t1_sr_sem] = getIdxSpikeRate(sr, t1_absintv, sr_cent, flag_type);    
end % if

% *** spike rate difference ***
if t1_index_ratediff
    [t1_srdif, t1_srdif_mean, t1_srdif_sem] = getIdxSRDiff(sr, t1_absintv, sr_cent, base_s1, flag_type);
end % if

% *** percentage change ***
if t1_index_perchg
    [t1_pg, t1_pg_mean, t1_pg_sem] = getIdxPerchg(sr, t1_absintv, sr_cent, base_s1, flag_type);
end % if

% *** modulation index ***
if t1_index_mi
    [t1_mi, t1_mi_mean, t1_mi_sem] = getIdxMI(sr, t1_absintv, sr_cent, base_s1, flag_type);
end % if

% +++++++++++++++++++++++
% MT-P2 indexes (peak 2)
% +++++++++++++++++++++++
p2_absintv = p2_intv + pre_ms - 1;
flag_type = type_peak;

% *** spike rate ***
if p2_index_spkrate
    % function of condition
    [p2_sr, p2_sr_mean, p2_sr_sem] = getIdxSpikeRate(sr, p2_absintv, sr_cent, flag_type);
end % if

% *** spike rate difference ***
if p2_index_ratediff
    [p2_srdif, p2_srdif_mean, p2_srdif_sem] = getIdxSRDiff(sr, p2_absintv, sr_cent, base_s1, flag_type);
end % if

% *** percentage change ***
if p2_index_perchg
        [p2_pg, p2_pg_mean, p2_pg_sem] = getIdxPerchg(sr, p2_absintv, sr_cent, base_s1, flag_type);
end % if

% *** modulation index ***
if p2_index_mi
        [p2_mi, p2_mi_mean, p2_mi_sem] = getIdxMI(sr, p2_absintv, sr_cent, base_s1, flag_type);
end % if

% ++++++++++++++++++++++++++++++
% MT-S2 indexes (sustained 2)
% ++++++++++++++++++++++++++++++
if s2_index_spkrate
    
end % if


% =========================================================================
% commit results
% =========================================================================
% P1
result_dat.MTP1Index.SpikeRate.Cells = p1_sr;
result_dat.MTP1Index.SpikeRate.Mean  = p1_sr_mean;
result_dat.MTP1Index.SpikeRate.SEM   = p1_sr_sem;

result_dat.MTP1Index.SRDiff.Cells = p1_srdif;
result_dat.MTP1Index.SRDiff.Mean  = p1_srdif_mean;
result_dat.MTP1Index.SRDiff.SEM   = p1_srdif_sem;

result_dat.MTP1Index.PerChange.Cells = p1_pg;
result_dat.MTP1Index.PerChange.Mean  = p1_pg_mean;
result_dat.MTP1Index.PerChange.SEM   = p1_pg_sem;

result_dat.MTP1Index.ModuIndex.Cells = p1_mi;
result_dat.MTP1Index.ModuIndex.Mean  = p1_mi_mean;
result_dat.MTP1Index.ModuIndex.SEM   = p1_mi_sem;

% T1
result_dat.MTT1Index.SpikeRate.Cells = t1_sr;
result_dat.MTT1Index.SpikeRate.Mean  = t1_sr_mean;
result_dat.MTT1Index.SpikeRate.SEM   = t1_sr_sem;

result_dat.MTT1Index.SRDiff.Cells = t1_srdif;
result_dat.MTT1Index.SRDiff.Mean  = t1_srdif_mean;
result_dat.MTT1Index.SRDiff.SEM   = t1_srdif_sem;

result_dat.MTT1Index.PerChange.Cells = t1_pg;
result_dat.MTT1Index.PerChange.Mean  = t1_pg_mean;
result_dat.MTT1Index.PerChange.SEM   = t1_pg_sem;

result_dat.MTT1Index.ModuIndex.Cells = t1_mi;
result_dat.MTT1Index.ModuIndex.Mean  = t1_mi_mean;
result_dat.MTT1Index.ModuIndex.SEM   = t1_mi_sem;

% P2
result_dat.MTP2Index.SpikeRate.Cells = p2_sr;
result_dat.MTP2Index.SpikeRate.Mean  = p2_sr_mean;
result_dat.MTP2Index.SpikeRate.SEM   = p2_sr_sem;

result_dat.MTP2Index.SRDiff.Cells = p2_srdif;
result_dat.MTP2Index.SRDiff.Mean  = p2_srdif_mean;
result_dat.MTP2Index.SRDiff.SEM   = p2_srdif_sem;

result_dat.MTP2Index.PerChange.Cells = p2_pg;
result_dat.MTP2Index.PerChange.Mean  = p2_pg_mean;
result_dat.MTP2Index.PerChange.SEM   = p2_pg_sem;

result_dat.MTP2Index.ModuIndex.Cells = p2_mi;
result_dat.MTP2Index.ModuIndex.Mean  = p2_mi_mean;
result_dat.MTP2Index.ModuIndex.SEM   = p2_mi_sem;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [mi, mi_mean, mi_sem] = getIdxMI(sr_in, intv, time, basesr, flag_type)
% get modulation index of peak spike rate
% 
%   sr_in   - contrast levels x signal x cells
%   basesr  - base spike rate = contrast levels x cells
%   flag_type   - feature type: 0 = steady-state, 1 = peak, 2 = trough
% 
% Output(s)
%   mi      - percetage change = contrast levels x cells
%   mi_mean -
%   mi_sem  -

N = size(sr_in, 3);

sr_dif = getIdxSRDiff(sr_in, intv, time, basesr, flag_type);

mi = sr_dif ./ (sr_dif + 2*(basesr + eps));
mi_mean = mean(mi, 2);
mi_sem  = std(mi, [] , 2) / sqrt(N);

end % function


function [pg, pg_mean, pg_sem] = getIdxPerchg(sr_in, intv, time, basesr, flag_type)
% get percetage change of spike rate
% 
%   sr_in   - contrast levels x signal x cells
%   basesr  - base spike rate = contrast levels x cells
%   flag_type   - feature type: 0 = steady-state, 1 = peak, 2 = trough
% 
% Output(s)
%   pg      - percetage change = contrast levels x cells
%   pg_mean -
%   pg-sem  -

N = size(sr_in, 3);

sr_dif = getIdxSRDiff(sr_in, intv, time, basesr, flag_type);

pg = sr_dif ./ (basesr + eps)* 100;
pg_mean = mean(pg, 2);
pg_sem  = std(pg, [] , 2) / sqrt(N);

end % function

function [sr, sr_mean, sr_sem] = getIdxSRDiff(sr_in, intv, time, basesr, flag_type)
% get spike rate difference as the index
% 
%   sr_in   - contrast levels x signal x cells
%   basesr  - base spike rate = contrast levels x cells
%   flag_type   - feature type: 0 = steady-state, 1 = peak, 2 = trough
% 
% Outputs
%   sr      - spike rate = contrast levels x cells
%   sr_mean - mean across cells
%   sr_sem  - SEM across cells

sig_len = size(sr_in, 2);
b = repmat(basesr, [1 1 sig_len]);
bsr = permute(b, [1 3 2]);
sr_diff = sr_in - bsr;

[sr, sr_mean, sr_sem] = getIdxSpikeRate(sr_diff, intv, time, flag_type);

end % function

function [sr, sr_mean, sr_sem] = getIdxSpikeRate(sr_in, intv, time, flag_type)
% get spike rate as the index
% 
%   sr_in       - contrast levels x signal x cells
%   flag_type   - feature type: 0 = sustained, 1 = peak, 2 = trough
% 
% Outputs
%   sr      - spike rate = contrast levels x cells
%   sr_mean - mean across cells
%   sr_sem  - SEM across cells

N = size(sr_in, 3);         % number of cells
idx = time >= intv(1) & time <= intv(2);

if flag_type == 0   % sustained
    sr = squeeze( mean(sr_in(:, idx, :), 2) );      % contrast levels x cells
elseif flag_type == 1   % peak
    sr = squeeze( max(sr_in(:, idx, :), [], 2) );   % contrast levels x cells
elseif flag_type == 2   % trough
    sr = squeeze( min(sr_in(:, idx, :), [], 2) );   % contrast levels x cells
end % if

sr_mean = mean( sr, 2 );
sr_sem = std(sr, [], 2) / sqrt(N);

end % function

function baserate = getSteadyBase(sr, intv, time)
% use average spike rate in 'intv' as base rate
% 
% sr = contrast levels x signals x cells
% 
% Outputs
%   baserate = contrast levels x cells

idx = time >= intv(1) & time <= intv(2);
base_intv = sr(:, idx, :);

baserate = squeeze( mean(base_intv, 2) );

end % funciton

% [EOF]

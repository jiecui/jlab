function result_dat = AggSCIndex(current_tag, name, S, dat)
% AGGSCINDEX Indexes of step-contrast responses
% 
% Description:
%   This function calculates various indexes to characterize the neural
%   activity in response to Step Contrast (SC) change.
%
% Syntax:
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created:Sat 12/22/2012  6:54:34.194 PM
% $Revision: 0.1 $  $Date: Sat 12/22/2012  6:54:34.194 PM $
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
% Note:
%   p1      - peak response to the 1st contrast
%   p1_intv - p1 is assummed to take place in the interval of p1_intv (ms);
%             time is relative to the onset of 1st contrast
%   s1      - steady-state response to the 1st contrast
%   s1_intv - s1 is assumed to take place in s1_intv
%   p2      - to the 2nd contrast
%   p2_intv - time relative to the onset of 2nd contrast
%   s2
%   s2_intv

if strcmpi(current_tag,'get_options')
    opt.intv.p1 = {[1 200] 'P1 interval (ms)' [1 500]};         % interval for checking peak 1
    opt.intv.s1 = {[800 1300] 'S1 interval (ms)' [500 1300]};   % for steady-state 1
    opt.intv.p2 = {[1 200] 'P2 interval (ms)' [1 500]};         % time from onset of 2nd contrast 
    opt.intv.s2 = {[800 1300] 'S2 interval (ms)' [500 1300]};   % time from onset of 2nd contrast
    
    opt.p2_index.base = {'P1|{S1}', 'P2 index base'};
    opt.p2_index.type.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.p2_index.type.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.p2_index.type.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.p2_index.type.mi   = { {'0','{1}'}, 'Modulation index'};
    
    opt.s2_index.base = {'P1|{S1}', 'S2 index base'};
    opt.s2_index.type.spkrate    = { {'0','{1}'}, 'Spike rate'};
    opt.s2_index.type.ratediff   = { {'0','{1}'}, 'Rate difference'};
    opt.s2_index.type.perchg     = { {'0','{1}'}, 'Percent change'};
    opt.s2_index.type.mi   = { {'0','{1}'}, 'Modulation index'};
    
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'FXCond23Rate' 'FXCond23RateCenter' };
    result_dat = dat_var;
    return
end % if

grattime = 1300;    % stimulus presentation time (ms)

% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------
p1_intv = S.Stage_2_Options.AggSCIndex_options.intv.p1;
s1_intv = S.Stage_2_Options.AggSCIndex_options.intv.s1;
p2_intv = S.Stage_2_Options.AggSCIndex_options.intv.p2;
s2_intv = S.Stage_2_Options.AggSCIndex_options.intv.s2;

% options for cal p2 indexes
p2_index_base = S.Stage_2_Options.AggSCIndex_options.p2_index.base;
p2_index_spkrate = S.Stage_2_Options.AggSCIndex_options.p2_index.type.spkrate;
p2_index_ratediff = S.Stage_2_Options.AggSCIndex_options.p2_index.type.ratediff;
p2_index_perchg = S.Stage_2_Options.AggSCIndex_options.p2_index.type.perchg;
p2_index_mi = S.Stage_2_Options.AggSCIndex_options.p2_index.type.mi;

% options for cal s2 indexes
s2_index_base = S.Stage_2_Options.AggSCIndex_options.s2_index.base;
s2_index_spkrate = S.Stage_2_Options.AggSCIndex_options.s2_index.type.spkrate;
s2_index_ratediff = S.Stage_2_Options.AggSCIndex_options.s2_index.type.ratediff;
s2_index_perchg = S.Stage_2_Options.AggSCIndex_options.s2_index.type.perchg;
s2_index_mi = S.Stage_2_Options.AggSCIndex_options.s2_index.type.mi;

% get the data
% -------------
sr = dat.FXCond23Rate;      % spike rate
sr_cent = dat.FXCond23RateCenter;

% ++++++++++++++++++
% SC-P2 indexes
% ++++++++++++++++++
% get the base spike rate
switch p2_index_base
    case 'P1'   % use peak 1 spike rate
        intv = p1_intv;
        p2_base = getPeakBase(sr, intv, sr_cent);
    case 'S1'
        intv = s1_intv;
        p2_base = getSteadyBase(sr, intv, sr_cent);
end % switch

% get p2 absolute intv
p2_absintv = p2_intv + grattime - 1;
flag_peak = true;

% *** spike rate ***
if p2_index_spkrate
    % function of condition
    [p2_sr, p2_sr_mean, p2_sr_sem] = getIdxSpikeRate(sr, p2_absintv, sr_cent, flag_peak);
    % function of difference of contrasts
    [p2_srd, p2_srd_mean, p2_srd_sem] = getIdxSRDiffCont(sr, p2_absintv, sr_cent, flag_peak);
end % if

% *** spike rate difference ***
if p2_index_ratediff
    % function of condition
    [p2_srdif, p2_srdif_mean, p2_srdif_sem] = getIdxSpikeRateDiff(sr, p2_absintv, sr_cent, p2_base, flag_peak);
    % function of difference of contrasts
    [p2_srdifd, p2_srdifd_mean, p2_srdifd_sem] = getIdxSRDiffDiffCont(sr, p2_absintv, sr_cent, p2_base, flag_peak);
end % if

% *** spike rate percetage change ***
if p2_index_perchg
    % function of condition
    [p2_pg, p2_pg_mean, p2_pg_sem] = getIdxPerchg(sr, p2_absintv, sr_cent, p2_base, flag_peak);
    % function of difference of contrasts
    [p2_pgd, p2_pgd_mean, p2_pgd_sem] = getIdxPerchgDiffCont(sr, p2_absintv, sr_cent, p2_base, flag_peak);
    
end % if

% *** spike rate modulation index ***
if p2_index_mi
    % function of condition
    [p2_mi, p2_mi_mean, p2_mi_sem] = getIdxMI(sr, p2_absintv, sr_cent, p2_base, flag_peak);
    % function of difference of contrasts
    [p2_mid, p2_mid_mean, p2_mid_sem] = getIdxMIDiffCont(sr, p2_absintv, sr_cent, p2_base, flag_peak);
    
end % if


% ++++++++++++++++++++++++++++++++
% MT-S2 indexes (steady-state 2)
% ++++++++++++++++++++++++++++++++
% get the base spike rate
switch s2_index_base
    case 'P1'   % use peak 1 spike rate
        intv = p1_intv;
        s2_base = getPeakBase(sr, intv, sr_cent);
    case 'S1'
        intv = s1_intv;
        s2_base = getSteadyBase(sr, intv, sr_cent);
end % switch

% get s2 absolute intv
s2_absintv = s2_intv + grattime - 1;
flag_peak = false;

% *** spike rate ***
if s2_index_spkrate
    % function of condition
    [s2_sr, s2_sr_mean, s2_sr_sem] = getIdxSpikeRate(sr, s2_absintv, sr_cent, flag_peak);
    % function of difference of contrasts
    [s2_srd, s2_srd_mean, s2_srd_sem] = getIdxSRDiffCont(sr, s2_absintv, sr_cent, flag_peak);  
end % if

% *** spike rate difference ***
if s2_index_ratediff
    % function of condition
    [s2_srdif, s2_srdif_mean, s2_srdif_sem] = getIdxSpikeRateDiff(sr, s2_absintv, sr_cent, s2_base, flag_peak);
    % function of difference of contrasts
    [s2_srdifd, s2_srdifd_mean, s2_srdifd_sem] = getIdxSRDiffDiffCont(sr, s2_absintv, sr_cent, s2_base, flag_peak);
end % if

% *** spike rate percetage change ***
if s2_index_perchg
    % function of condition
    [s2_pg, s2_pg_mean, s2_pg_sem] = getIdxPerchg(sr, s2_absintv, sr_cent, s2_base, flag_peak);
    % function of difference of contrasts
    [s2_pgd, s2_pgd_mean, s2_pgd_sem] = getIdxPerchgDiffCont(sr, s2_absintv, sr_cent, s2_base, flag_peak);
    
end % if

% *** spike rate modulation index ***
if s2_index_mi
    % function of condition
    [s2_mi, s2_mi_mean, s2_mi_sem] = getIdxMI(sr, s2_absintv, sr_cent, s2_base, flag_peak);
    % function of difference of contrasts
    [s2_mid, s2_mid_mean, s2_mid_sem] = getIdxMIDiffCont(sr, s2_absintv, sr_cent, s2_base, flag_peak);
    
end % if

% =====================
% commit results
% =====================
% P2
result_dat.SCP2Index.SpikeRate.Cells = p2_sr;
result_dat.SCP2Index.SpikeRate.Mean  = p2_sr_mean;
result_dat.SCP2Index.SpikeRate.SEM   = p2_sr_sem;
result_dat.SCP2Index.SpikeRateContDiff.Cells = p2_srd;    % as a funciton of contrast difference
result_dat.SCP2Index.SpikeRateContDiff.Mean  = p2_srd_mean;
result_dat.SCP2Index.SpikeRateContDiff.SEM   = p2_srd_sem;

result_dat.SCP2Index.SRDiff.Cells = p2_srdif;
result_dat.SCP2Index.SRDiff.Mean  = p2_srdif_mean;
result_dat.SCP2Index.SRDiff.SEM   = p2_srdif_sem;
result_dat.SCP2Index.SRDiffContDiff.Cells = p2_srdifd;    % as a funciton of contrast difference
result_dat.SCP2Index.SRDiffContDiff.Mean  = p2_srdifd_mean;
result_dat.SCP2Index.SRDiffContDiff.SEM   = p2_srdifd_sem;

result_dat.SCP2Index.PerChange.Cells = p2_pg;
result_dat.SCP2Index.PerChange.Mean  = p2_pg_mean;
result_dat.SCP2Index.PerChange.SEM   = p2_pg_sem;
result_dat.SCP2Index.PerChangeContDiff.Cells = p2_pgd;    % as a funciton of contrast difference
result_dat.SCP2Index.PerChangeContDiff.Mean  = p2_pgd_mean;
result_dat.SCP2Index.PerChangeContDiff.SEM   = p2_pgd_sem;

result_dat.SCP2Index.ModuIndex.Cells = p2_mi;
result_dat.SCP2Index.ModuIndex.Mean  = p2_mi_mean;
result_dat.SCP2Index.ModuIndex.SEM   = p2_mi_sem;
result_dat.SCP2Index.ModuIndexContDiff.Cells = p2_mid;    % as a funciton of contrast difference
result_dat.SCP2Index.ModuIndexContDiff.Mean  = p2_mid_mean;
result_dat.SCP2Index.ModuIndexContDiff.SEM   = p2_mid_sem;

% S2
result_dat.SCS2Index.SpikeRate.Cells = s2_sr;
result_dat.SCS2Index.SpikeRate.Mean  = s2_sr_mean;
result_dat.SCS2Index.SpikeRate.SEM   = s2_sr_sem;
result_dat.SCS2Index.SpikeRateContDiff.Cells = s2_srd;    % as a funciton of contrast difference
result_dat.SCS2Index.SpikeRateContDiff.Mean  = s2_srd_mean;
result_dat.SCS2Index.SpikeRateContDiff.SEM   = s2_srd_sem;

result_dat.SCS2Index.SRDiff.Cells = s2_srdif;
result_dat.SCS2Index.SRDiff.Mean  = s2_srdif_mean;
result_dat.SCS2Index.SRDiff.SEM   = s2_srdif_sem;
result_dat.SCS2Index.SRDiffContDiff.Cells = s2_srdifd;    % as a funciton of contrast difference
result_dat.SCS2Index.SRDiffContDiff.Mean  = s2_srdifd_mean;
result_dat.SCS2Index.SRDiffContDiff.SEM   = s2_srdifd_sem;

result_dat.SCS2Index.PerChange.Cells = s2_pg;
result_dat.SCS2Index.PerChange.Mean  = s2_pg_mean;
result_dat.SCS2Index.PerChange.SEM   = s2_pg_sem;
result_dat.SCS2Index.PerChangeContDiff.Cells = s2_pgd;    % as a funciton of contrast difference
result_dat.SCS2Index.PerChangeContDiff.Mean  = s2_pgd_mean;
result_dat.SCS2Index.PerChangeContDiff.SEM   = s2_pgd_sem;

result_dat.SCS2Index.ModuIndex.Cells = s2_mi;
result_dat.SCS2Index.ModuIndex.Mean  = s2_mi_mean;
result_dat.SCS2Index.ModuIndex.SEM   = s2_mi_sem;
result_dat.SCS2Index.ModuIndexContDiff.Cells = s2_mid;    % as a funciton of contrast difference
result_dat.SCS2Index.ModuIndexContDiff.Mean  = s2_mid_mean;
result_dat.SCS2Index.ModuIndexContDiff.SEM   = s2_mid_sem;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [mi, mi_mean, mi_sem] = getIdxMI(sr_in, intv, time, basesr, flag_peak)

numlevels = 11;
sr_dif = getIdxSpikeRateDiff(sr_in, intv, time, basesr, flag_peak);

N = size(sr_dif, 3);
a = reshape(basesr, [N, numlevels, numlevels]);
bsr = permute(a, [3 2 1]);  % base spike rate

mi = sr_dif ./ (sr_dif + 2*(bsr + eps));   % 1st cont x 2nd cont x cells
mi_mean = mean(mi, 3);
mi_sem  = std(mi, [], 3) / sqrt(N);

end % funciton

function [mid, mid_mean, mid_sem] = getIdxMIDiffCont(sr_in, intv, time, basesr, flag_peak)

mi = getIdxMI( sr_in, intv, time, basesr, flag_peak );  % 1st cont x 2nd cont x cells

[M, ~, N] = size(mi);    % N = number of cells
mid = zeros(N, 2*M - 1);
for p = 1:N     % cell by cell
    mi_p = mi(:, :, p);
    for q = 1: 2*M - 1
        k = q - M;  % diag by diag
        diag_k = diag(mi_p, k);
        mid(p, q) = mean(diag_k);
    end % for
end %for

mid_mean = mean(mid);
mid_sem = std(mid) / sqrt(N);

end % function

function [pgd, pgd_mean, pgd_sem] = getIdxPerchgDiffCont(sr_in, intv, time, basesr, flag_peak)

pg = getIdxPerchg( sr_in, intv, time, basesr, flag_peak );  % 1st cont x 2nd cont x cells

[M, ~, N] = size(pg);    % N = number of cells
pgd = zeros(N, 2*M - 1);
for p = 1:N     % cell by cell
    pg_p = pg(:, :, p);
    for q = 1: 2*M - 1
        k = q - M;  % diag by diag
        diag_k = diag(pg_p, k);
        pgd(p, q) = mean(diag_k);
    end % for
end %for

pgd_mean = mean(pgd);
pgd_sem = std(pgd) / sqrt(N);

end % function

function [pg, pg_mean, pg_sem] = getIdxPerchg(sr_in, intv, time, basesr, flag_peak)

numlevels = 11;
sr_dif = getIdxSpikeRateDiff(sr_in, intv, time, basesr, flag_peak);

N = size(sr_dif, 3);
a = reshape(basesr, [N, numlevels, numlevels]);
bsr = permute(a, [3 2 1]);  % base spike rate

pg = sr_dif ./ (bsr + eps) * 100;   % 1st cont x 2nd cont x cells
pg_mean = mean(pg, 3);
pg_sem  = std(pg, [], 3) / sqrt(N);

end % funciton

function [sr, sr_mean, sr_sem] = getIdxSRDiffDiffCont(sr_in, intv, time, basesr, flag_peak)
% get index of spike rate difference as a funciton of contrast change
% 
% output
%   sr      - cells x spike rate of different contrast increase (-100%
%             -90%,..., 0%, 10%, ..., 100%, from contrast 1 to contrast
%             2nd)

sig_len = size(sr_in, 2);
b = repmat(basesr, [1, 1, sig_len]);
bsr = permute(b, [1 3 2]);  % base spike rate
sr_diff = sr_in - bsr;

[sr, sr_mean, sr_sem] = getIdxSRDiffCont(sr_diff, intv, time, flag_peak);

end % function

function [sr, sr_mean, sr_sem] = getIdxSpikeRateDiff(sr_in, intv, time, basesr, flag_peak)
% get spike rate difference as the index
% 
% Input(s)
%   sr_in   - cell x signal x conditions
%   intv    - peak interval, relative to the beginning of signal
%   time    - time of each data point
%   basesr  - baseline spike rate
% 
% Output(s)
%   sr      - spike rate, 1st contrast x 2nd contrast x cells
%   sr_mean - mean across cells
%   sr_sem  - SEM across cells

sig_len = size(sr_in, 2);
b = repmat(basesr, [1,1, sig_len]);
bsr = permute(b, [1 3 2]);  % base spike rate
sr_diff = sr_in - bsr;

[sr, sr_mean, sr_sem] = getIdxSpikeRate(sr_diff, intv, time, flag_peak);

end % function


function [sr, sr_mean, sr_sem] = getIdxSRDiffCont(sr_in, intv, time, flag_peak)
% get index of spike rate as a funciton of contrast change
% 
% output
%   sr      - cells x spike rate of different contrast increase (-100%
%             -90%,..., 0%, 10%, ..., 100%, from contrast 1 to contrast
%             2nd)

sr_idx = getIdxSpikeRate( sr_in, intv, time, flag_peak );  % 1st cont x 2nd cont x cells

[M, ~, N] = size(sr_idx);    % number of cells
sr = zeros(N, 2*M - 1);
for p = 1:N     % cell by cell
    sr_idx_p = sr_idx(:, :, p);
    for q = 1: 2*M - 1
        k = q - M;  % diag by diag
        diag_k = diag(sr_idx_p, k);
        sr(p, q) = mean(diag_k);
    end % for
end %for

sr_mean = mean(sr);
sr_sem = std(sr) / sqrt(N);

end % function

function [sr, sr_mean, sr_sem] = getIdxSpikeRate(sr_in, intv, time, flag_peak)
% get peak spike rate as the index
% 
%   sr_in   - cell x signal x conditions
%   flag_peak - true = peak; false = steady-state
% 
% Outputs
%   sr      - spike rate, 1st contrast x 2nd contrast x cells
%   sr_mean - mean across cells
%   sr_sem  - SEM across cells

levelnum = 11;      % number of contrast numbers

N = size(sr_in, 1);         % number of cells
idx = time >= intv(1) & time <= intv(2);

if flag_peak
    spkrate = squeeze( max(sr_in(:, idx, :), [], 2) );  % cell x conditions
else
    spkrate = squeeze( mean(sr_in(:, idx, :), 2) );     % cell x conditions
end % if

spkrate = reshape(spkrate', levelnum, levelnum, N);     % 11 (cont 2) x 11 (cont 1st) x cells
sr = permute(spkrate, [2 1 3]);  % cont 1st x cont 2nd x cells
sr_mean = mean( sr, 3 );
sr_sem = std(sr, [], 3) / sqrt(N);

end % function

function baserate = getSteadyBase(sr, intv, time)
% use average spike rate in 'intv' as base rate

idx = time >= intv(1) & time <= intv(2);
base_intv = sr(:, idx, :);

baserate = squeeze( mean(base_intv, 2) );

end % funciton

function baserate = getPeakBase(sr, intv, time)
% use peak spike rate as the base rate
% 
% inputs
%   sr      - spike rate of each cell, cell x signal length x condition
%   intv    - interval for looking for peak
%   time    - time point for signal
% 
% outputs
%   baserate - cell x conditions

idx = time >= intv(1) & time <= intv(2);
peak_intv = sr(:, idx, :);

baserate = squeeze( max(peak_intv, [], 2) );

end 
% [EOF]

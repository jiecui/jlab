function newsessions = blocks2session(blocks, opt, do_waitbar)
% MSACCCONTRAST.BLOCKS2SESSION conbines different blocks in a session into one
%
% Syntax:
%   dat = combine_sessions(sessions)
%
% Input(s):
%   blocks      - 2 x N cells, N session and 2 blocks names for each session
%   opt         - options
%
% Output(s):
%   dat         - .variable names
%
% Example:
%
% See also .

% Copyright 2013-2016 Richard J. Cui. Created: Fri 04/26/2013 11:58:44.893 AM
% $Revision: 0.7 $  $Date: Thu 06/16/2016  5:28:34.207 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if ~exist('do_waitbar', 'var')
    do_waitbar = true;
end % if

N = size(blocks, 2);    % get the number of sessions
newsessions = opt.newsessions;

if do_waitbar
    wh = waitbar(0, 'Combining blocks, please wait...');
end % if

% combine session by session
for k = 1:N
    
    if do_waitbar
        waitbar(k / N, wh)
    end % if
    
    blocks_k = blocks(:, k);
    opt_k.newsession = newsessions{k};
    
    news_k = blocks2session_single(blocks_k, opt_k);
    newsessions{k} = news_k;
end % for

if do_waitbar
    close(wh)
end % if

end % funciton

% =========================================================================
% subroutines
% =========================================================================
function new_session_name = blocks2session_single(blocks, opt)

% =========================================================================
% options
% =========================================================================
new_session_name = opt.newsession;

% check names
if ischar(blocks)
    blocks = {blocks};
end
nBlocks = length(blocks);
if nBlocks < 2
    error('combine_sessions:nSessChk', 'The number of data blocks must be more than one.')
end % if


% =========================================================================
% combine variables
% =========================================================================
fprintf('+++++++++ Combining data blocks for Session %s ++++++++++\n', new_session_name)

dat = CorruiDB.Getsessvars(blocks{1}, {'enum'});
enum = dat.enum;

% write comment
% --------------
comment = sprintf('Combined from %s and %s.', blocks{1}, blocks{2});

% create 'info' information
% -------------------------
info.import.date = datestr(now, 'mm/dd/yyyy HH:MM:SS');
info.process_stage_0.date = '---';
info.process_stage_1.date = '---';
info.process_stage_2.date = '---';

% analysis of trial numbers
% --------------------------
trlnum = zeros(nBlocks, 1);
trlcyc = zeros(nBlocks, 1);

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'trialMatrix', 'NumberCycle' });
    trlm_k = dat.trialMatrix;
    trlnum(k) = size(trlm_k, 2);
    trlcyc(k) = dat.NumberCycle;
end % for
trlnum_add = cumsum([0; trlnum]);
trlcyc_add = cumsum([0; trlcyc]);

% analysis time stamps
% --------------------
start_ts = zeros(nBlocks, 1);
end_ts = zeros(nBlocks, 1);
ts_length = zeros(nBlocks, 1);
ts = [];
for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'timestamps'});
    ts_k = dat.timestamps;
    start_ts(k) = ts_k(1);
    end_ts(k) = ts_k(end);
    ts_length(k) = length(ts_k);
    
    ts = cat(1, ts, ts_k(:));
end % for

next_start = start_ts(2:end);
last_end = end_ts(1:end-1);
if sum(next_start - last_end < 0)
    warning('Time stamps are overlapped.')
end % fi

idx_add = cumsum([0; ts_length]);    % increamental values for indexes

% -----------------------
% spiketimes
% -----------------------
spiketimes = [];

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'spiketimes'});
    st_k = dat.spiketimes;
    
    time_idx = st_k(:, enum.spiketimes.timeindex);
    time_idx_k = time_idx + idx_add(k);
    st_k(:, enum.spiketimes.timeindex) = time_idx_k;
    
    trl_num = st_k(:, enum.spiketimes.trial_number);
    trl_num_idx = trl_num > 0;
    trl_num_add = trl_num(trl_num_idx) + trlnum_add(k);
    trl_num(trl_num_idx) = trl_num_add;
    st_k(:, enum.spiketimes.trial_number) = trl_num;
    
    trl_cyc = st_k(:, enum.spiketimes.cycle_index);
    trl_cyc_idx = trl_cyc > 0;
    trl_cyc_add = trl_cyc(trl_cyc_idx) + trlcyc_add(k);
    trl_cyc(trl_cyc_idx) = trl_cyc_add;
    st_k(:, enum.spiketimes.cycle_index) = trl_cyc;
    
    spiketimes = cat(1, spiketimes, st_k);
end % for

% --------
% NumberCycle
% ---------
NumberCycle = 0;

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'NumberCycle'});
    nc_k = dat.NumberCycle;
    
    NumberCycle = NumberCycle + nc_k;
end % for

% ----------------
% CondInCycle
% ----------------
condincyc = zeros(nBlocks, 121);

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'CondInCycle'});
    condincyc_k = dat.CondInCycle;
    condincyc(k, :) = condincyc_k;
end % for

if sum(diff(condincyc)) ~= 0
    error('Condition in cycles are not consistent between blocks.')
else
    CondInCycle = condincyc(1, :);
end

% --------
% NumberCondition
% ---------
ncond = zeros(nBlocks, 1);

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'NumberCondition'});
    ncond_k = dat.NumberCondition;
    ncond(k) = ncond_k;
end % for

if sum(diff(ncond)) ~= 0
   error('Number of conditions are not consistent between blocks.') 
else
    NumberCondition = ncond(1);
end
% --------
% samplerate
% ---------
sprt = zeros(nBlocks, 1);

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'samplerate'});
    sprt_k = dat.samplerate;
    sprt(k) = sprt_k;
end % for

if sum(diff(sprt)) > 0
   warning('Smplerates are not consistent between blocks. Use the copy in the first block.') 
end

samplerate = sprt(1);

% --------
% grattime
% ---------
gt = zeros(nBlocks, 1);

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'grattime'});
    gt_k = dat.grattime;
    gt(k) = gt_k;
end % for

if sum(diff(gt)) > 0
   warning('Grattimes are not consistent between blocks. Use the copy in the first block.') 
end

grattime = gt(1);

% -------------
% LastConChunk
% -------------
dat = CorruiDB.Getsessvars(blocks{nBlocks}, {'LastConChunk'});
lastconchunk = dat.LastConChunk;

% ------------------------
% Before/AfterExpTuneChunk
% ------------------------
dat = CorruiDB.Getsessvars(blocks{1}, {'BeforeExpTuneChunk'});
before_tun = dat.BeforeExpTuneChunk;

dat = CorruiDB.Getsessvars(blocks{nBlocks}, {'AfterExpTuneChunk'});
after_tun = dat.AfterExpTuneChunk;

% ------------------
% usacc_props
% ------------------
left_usacc_props = combUsaccProps(enum, idx_add, trlnum_add, blocks, 'left_usacc_props');
right_usacc_props = combUsaccProps(enum, idx_add, trlnum_add, blocks, 'right_usacc_props');

% ------------------
% trialMatrix
% ------------------
trialMatrix = [];
idx_interest = [enum.trialMatrix.trialStage1StartIndex, ...
                enum.trialMatrix.trialStopIndex, ...
                enum.trialMatrix.trialStage1StartIndex, ...
                enum.trialMatrix.trialStage2StartIndex, ...
                enum.trialMatrix.trialStage3StartIndex];
            
for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'trialMatrix'});
    trlm_k = dat.trialMatrix;
    
    time_idx = trlm_k(idx_interest, :);
    time_idx_add = time_idx + idx_add(k);
    trlm_k(idx_interest, :) = time_idx_add;
    
    trialMatrix = cat(2, trialMatrix, trlm_k);
    
end % for

% --------------------
% trial_props
% --------------------
trial_props = [];
idx_interest = [enum.trial_props.start_index, ...
                enum.trial_props.end_index
               ];

for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, {'trial_props'});
    trlp_k = dat.trial_props;
    
    time_idx = trlp_k(:, idx_interest);
    time_idx_add = time_idx + idx_add(k);
    trlp_k(:, idx_interest) = time_idx_add;

    trl_num = trlp_k(:, enum.trial_props.ntrial);
    trl_num_add = trl_num + trlnum_add(k);
    trlp_k(:, enum.trial_props.ntrial) = trl_num_add;
    
    trial_props = cat(1, trial_props, trlp_k);
end % for
           
% --------------------
% enum: merge
% --------------------
vars = {'enum'};
a = cell(nBlocks, 1);
for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, vars);
    a{k} = dat.enum;
end % for

enum = a{1};
for k = 2:nBlocks
    enum = mergestructs(enum, a{k});
end % for

% =========================================================================
% save the dat
% =========================================================================
data = [];
curr_tag                = mfilename('class');
% data.internalTag = curr_tag;

data.comment            = comment;
data.info               = info;
data.timestamps         = ts;
data.enum               = enum;
data.spiketimes         = spiketimes;
data.NumberCycle        = NumberCycle;
data.CondInCycle        = CondInCycle;
data.NumberCondition    = NumberCondition;
data.samplerate         = samplerate;
data.grattime           = grattime;
data.LastConChunk       = lastconchunk;
data.left_usacc_props   = left_usacc_props;
data.right_usacc_props  = right_usacc_props;
data.trialMatrix        = trialMatrix;
data.trial_props        = trial_props;
data.BeforeExpTuneChunk = before_tun;
data.AfterExpTuneChunk  = after_tun;
data.internalTag        = curr_tag;

CorruiDB.Addsessvars(new_session_name, data, 'unlock')

disp('+++++++++ done ++++++++++')

end % function blocks2session

function combined_usacc_props = combUsaccProps(enum, idx_add, trlnum_add, blocks, usacc_props_name)

var = {usacc_props_name};

combined_usacc_props = [];
nBlocks = length(blocks);
for k = 1:nBlocks
    block_k = blocks{k};
    dat = CorruiDB.Getsessvars(block_k, var);
    if isfield(dat, usacc_props_name)
        up_k = dat.(usacc_props_name);
        
        % increase index
        trlnum_add_k = trlnum_add(k);
        ntrial_k = up_k(:, enum.usacc_props.ntrial);
        ntrial_idx = ntrial_k > 0;
        ntrial_add = ntrial_k(ntrial_idx) + trlnum_add_k;
        ntrial_k(ntrial_idx) = ntrial_add;
        up_k(:, enum.usacc_props.ntrial) = ntrial_k;
        
        idx_add_k = idx_add(k);
        start_idx = up_k(:, enum.usacc_props.start_index);
        start_idx_k = start_idx + idx_add_k;
        up_k(:, enum.usacc_props.start_index) = start_idx_k;
        
        end_idx = up_k(:, enum.usacc_props.end_index);
        end_idx_k = end_idx + idx_add_k;
        up_k(:, enum.usacc_props.end_index) = end_idx_k;
    else
        up_k = [];
    end % if
    
    combined_usacc_props = cat(1, combined_usacc_props, up_k);
    
end % for

end


% [EOF]

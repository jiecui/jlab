function newsessions = mergeData(this, blocks, opt, do_waitbar)
% GFSMSACC.MERGEDATA conbines different data type into one session
%
% Syntax:
%   newsessions = mergeData(blocks, opt, do_waitbar)
%
% Input(s):
%   blocks      - data type names in cells
%   opt         - options
%
% Output(s):
%   newsessions  - new session names of merged data type
%
% Example:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Wed 06/15/2016 10:23:27.155 PM
% $Revision: 0.6 $  $Date: TFri 07/08/2016  8:47:04.498 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if ~exist('do_waitbar', 'var')
    do_waitbar = true;
end % if

N = size(blocks, 2);
newsessions = opt.newsessions;

if do_waitbar
    wh = waitbar(0, 'Merging data types, please wait...');
end % if

for k = 1:N
    
    if do_waitbar
        waitbar(k / N, wh)
    end % if
    
    blocks_k = blocks(:, k);
    opt_k.newsession = newsessions{k};
    
    news_k = merge2datatype_single(this, blocks_k, opt_k);
    newsessions{k} = news_k;
end % for

if do_waitbar
    close(wh)
end % if

end % funciton

% =========================================================================
% subroutines
% =========================================================================
function new_session_name = merge2datatype_single(this, blocks, opt)

% =========================================================================
% options
% =========================================================================
new_session_name = opt.newsession;

% check names
if ischar(blocks)
    blocks = {blocks};
end
nBlocks = length(blocks);
if nBlocks ~= 2
    error('mergeData:merge2datatype_single',...
        'Invalid number of data types in a single block.')
end % if


% =========================================================================
% Merge variables
% =========================================================================
cprintf('Keywords', '+++++++++ Merging data types for Session %s ++++++++++\n',...
    this.SessName2UserSessName(new_session_name))

% internal tag
% ------------
curr_tag = mfilename('class');

% write comment
% --------------
sess_a = blocks{1};
sess_b = blocks{2};
if ~isempty(sess_a) && isempty(sess_b)      % Only Type A available
    comment = sprintf('Converted from %s.', this.SessName2UserSessName(sess_a));
elseif isempty(sess_a) && ~isempty(sess_b)  % Only Type B available
    comment = sprintf('Converted from %s.', this.SessName2UserSessName(sess_b));
elseif ~isempty(sess_a) && ~isempty(sess_b)   % Both Type A & B availble
    comment = sprintf('Merged from %s & %s.',...
        this.SessName2UserSessName(sess_a), this.SessName2UserSessName(sess_b));
else
    comment = 'In valid sessions.';
end % if

% merge other variables
% ---------------------
if ~isempty(sess_a) && isempty(sess_b)      % Only Type A available
    data = mergeTypeA(sess_a);
elseif isempty(sess_a) && ~isempty(sess_b)  % Only Type B available
    data = mergeTypeB(sess_b);
elseif ~isempty(sess_a) && ~isempty(sess_b) % Both Type A & B availble
    data = mergeTypeAB(sess_a, sess_b);
end % if

% create 'info' information
% -------------------------
vars = fieldnames(data);
info.import.variables = vars;
info.import.date = datestr(now, 'mm/dd/yyyy HH:MM:SS');
info.process_stage_0.date = '---';
info.process_stage_1.date = '---';
info.process_stage_2.date = '---';

% =========================================================================
% save the data
% =========================================================================
data.comment            = comment;
data.info               = info;
data.internalTag        = curr_tag;

CorruiDB.Addsessvars(new_session_name, data, 'unlock')

cprintf('Keywords', '+++++++++ done ++++++++++\n')

end % function blocks2session

% =========================================================================
% subroutines
% =========================================================================
function mg_var = mergeVars1Sess(sess, var, fmerge, varargin)
% from single session

if iscell(sess) == true
    sess = sess{1};
end % if
dat = CorruiDB.Getsessvars(sess, {var});
if isfield(dat, var)
    cprintf('Text', 'Merging %s... ', var)
    dat_var = dat.(var);
    mg_var = fmerge(dat_var, varargin{:});
    cprintf('Comments', 'O.K.!\n')
else
    mg_var = [];
    cprintf('SystemCommands', 'No %s available.\n', var)
end % if

end % function

function mg_var = mergeVars2Sess(sess, var, fmerge, varargin)
% from two sessions

dat_a = CorruiDB.Getsessvars(sess{1}, {var});
dat_b = CorruiDB.Getsessvars(sess{2}, {var});
if isfield(dat_a, var) && isfield(dat_b, var)
    cprintf('Text', 'Merging %s... ', var)
    dat_var_a = dat_a.(var);
    dat_var_b = dat_b.(var);
    mg_var = fmerge(dat_var_a, dat_var_b, varargin{:});
    cprintf('Comments', 'O.K.!\n')
elseif ~isfield(dat_a, var) && isfield(dat_b, var)
    cprintf('Text', 'Merging %s... ', var)
    dat_var_a = [];
    dat_var_b = dat_b.(var);
    mg_var = fmerge(dat_var_a, dat_var_b, varargin{:});
    cprintf('Comments', 'O.K.!\n') 
elseif isfield(dat_a, var) && ~isfield(dat_b, var)
    cprintf('Text', 'Merging %s... ', var)
    dat_var_a = dat_a.(var);
    dat_var_b = [];
    mg_var = fmerge(dat_var_a, dat_var_b, varargin{:});
    cprintf('Comments', 'O.K.!\n')  
else
    error('GfsMSacc:mergeData:mergeVars2Sess', 'Unknown varialbe.')
end % if

end % function

function mg_var = mergeVars(sess, var, fmerge, varargin)
% merge variables
% 
% Inputs:
%   sess        - session names
%   var         - variable name
%   fmerge      - function handle to merge vars
%   varargin    - other input arguments for fmerge
% 
% Outputs:
%   mg_var      - merged variable

if ischar(sess) == true || numel(sess) == 1
    mg_var = mergeVars1Sess(sess, var, fmerge, varargin{:});
elseif numel(sess) == 2
    mg_var = mergeVars2Sess(sess, var, fmerge, varargin{:});
else
    error('GfsMSacc:mergeData:mergeVars', 'Too many sessions.')
end % if

end % function

function mg_lock = mergeLock(dat_lock, varargin)

mg_lock = dat_lock;

end % function

function mg_lock = mergeLockAB(dat_lock_a, dat_lock_b, varargin)

if ~isempty(dat_lock_a) && isempty(dat_lock_b)
    mg_lock = dat_lock_a;
elseif isempty(dat_lock_a) && ~isempty(dat_lock_b)
    mg_lock = dat_lock_b;
elseif ~isempty(dat_lock_a) && ~isempty(dat_lock_b)
    mg_lock = dat_lock_b;   % if both, use type B
else
    mg_lock = [];
    cprintf('SystemCommands', 'No lock available, ')
end % if

end % function

function mg_si = mergeSessInfoA(dat_si, varargin)

si_fields = { 'MonkeyID',...        % monkey_id
    'RelLatShort',...     % short latency of level release relative to surround onset (< 1000 ms)
    'RelLatAll',...       % all latency of level release (< 10,000 ms)
    'TrialLength',...     % trial length (ms)
    'TargetOnset',...     % target onset (ms) relative to trial start
    'SurroundOnset',...   % surround onset (ms) relative to target onset
    'MaskOnset',...       % target mask onset (ms) relative to surround onset (?)
    'TargetPos'           % target position (dva)
    };

for k = 1:numel(si_fields)
    si_fields_k = si_fields{k};
    if isfield(dat_si, si_fields_k)
        mg_si.(si_fields_k) = dat_si.(si_fields_k);
        if isempty(mg_si.(si_fields_k)) == true
            cprintf('SystemCommands', 'No %s available, ', si_fields_k)
        end % if
    else
        mg_si.(si_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', si_fields_k)
    end % if
    
end % for

end % function

function mg_si = mergeSessInfoB(dat_si, varargin)

si_fields = { 'MonkeyID',...        % monkey_id
    'RelLatShort',...     % short latency of level release (< 1000 ms)
    'RelLatAll',...       % all latency of level release (< 10,000 ms)
    'TrialLength',...     % trial length (ms)
    'TargetOnset',...     % target onset (ms) relative to trial start
    'SurroundOnset',...   % surround onset (ms) relative to target onset
    'MaskOnset',...       % target mask onset (ms) relative to surround onset (?)
    'TargetPos'           % target position (dva)
    };

for k = 1:numel(si_fields)
    si_fields_k = si_fields{k};
    if isfield(dat_si, si_fields_k)
        dat_si_k = dat_si.(si_fields_k);
        switch si_fields_k
            case 'RelLatAll'
                d_k = dat_si_k(dat_si_k < 10000);     % choose those < 10000 ms
            case 'TrialLength'  % 3200 ->2800
                d_k = 2800;     
            case 'TargetOnset'
                d_k = 600;
            otherwise
                d_k = dat_si_k;
        end % switch
        if isempty(d_k) == true
            cprintf('SystemCommands', 'No %s available, ', si_fields_k)
            switch si_fields_k
                case 'SurroundOnset'
                    d_k = 1400;
                    cprintf('Keywords', 'Set at %d ms, ', d_k)
            end % switch
        end % if
        mg_si.(si_fields_k) = d_k;
    else
        cprintf('SystemCommands', 'No %s available, ', si_fields_k)
        switch si_fields_k
            case 'SurroundOnset'
                mg_si.(si_fields_k) = 1400;
                cprintf('Keywords', 'Set at %d ms, ', 1400)
            otherwise
                mg_si.(si_fields_k) = [];
        end % switch
    end % if
end % for

end % function

function mg_si = mergeSessInfoAB(dat_si_a, dat_si_b, varargin)
% check and merge two types of data

si_fields = { 'MonkeyID',...        % monkey_id
    'RelLatShort',...     % short latency of level release (< 1000 ms)
    'RelLatAll',...       % all latency of level release (< 10,000 ms)
    'TrialLength',...     % trial length (ms)
    'TargetOnset',...     % target onset (ms) relative to trial start
    'SurroundOnset',...   % surround onset (ms) relative to target onset
    'MaskOnset',...       % target mask onset (ms) relative to surround onset (?)
    'TargetPos'           % target position (dva)
    };

if ~isempty(dat_si_a) && isempty(dat_si_b)      % only type A
    mg_si = mergeSessInfoA(dat_si_a, varargin{:});
elseif isempty(dat_si_a) && ~isempty(dat_si_b)  % only type B
    mg_si = mergeSessInfoB(dat_si_b, varargin{:});
elseif ~isempty(dat_si_a) && ~isempty(dat_si_b)
    for k = 1:numel(si_fields)
        si_fields_k = si_fields{k};
        if isfield(dat_si_a, si_fields_k) && isfield(dat_si_b, si_fields_k)
            d_ak = dat_si_a.(si_fields_k);
            d_bk = dat_si_b.(si_fields_k);
            switch si_fields_k
                case 'MonkeyID'
                    if strcmp(d_ak, d_bk) == true
                        d_k = d_ak;
                    else
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'MonkeyID is not consistent.')
                    end % if
                case 'RelLatShort'
                    if norm(d_ak - d_bk) == 0
                        d_k = d_ak;
                    else
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'RelLatShort is not consistent.')                        
                    end % if
                case 'RelLatAll'
                    d_bk = d_bk(d_bk < 10000);     % choose those < 10000 ms
                    if norm(d_ak - d_bk) ~= 0
                        cprintf('SystemCommands', 'RelLatAll is not consistent, ')
                    end % if
                    d_k = d_ak;     % use type A
                case 'TrialLength'  % 3200 ->2800
                    if d_ak ~= 2800
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'Type A TrialLength is not correct.')
                    end % if
                    if d_bk ~= 3200
                        cprintf('SystemCommands', 'Type B TrialLength is wired, ')
                    end % if
                    d_k = d_ak;
                case 'TargetOnset'
                    if d_ak ~= 600
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'Type A TargetOnset is not correct.')
                    end % if
                    if d_bk ~= 800
                        cprintf('SystemCommands', 'Type B TargetOnset is wired, ')
                    end % if
                    d_k = d_ak;
                case 'SurroundOnset'
                    if norm(d_ak - d_bk) > 1
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'SurroundOnset is not consistent.')
                    end % if
                    d_k = d_ak;
                case 'MaskOnset'
                    if norm(d_ak - d_bk) > 1
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'MaskOnset is not consistent.')
                    end % if
                    d_k = d_ak;
                case 'TargetPos'
                    if norm(d_ak - d_bk) > 1
                        error('GfsMSacc:mergeData:mergeSessInfoAB',...
                            'TargetPos is not consistent.')
                    end % if
                    d_k = d_ak;
                otherwise
                    d_k = [];
            end % switch
            mg_si.(si_fields_k) = d_k;
        elseif isfield(dat_si_a, si_fields_k) && ~isfield(dat_si_b, si_fields_k)
            mg_si.(si_fields_k) = dat_si_a.(si_fields_k);
        elseif ~isfield(dat_si_a, si_fields_k) && isfield(dat_si_b, si_fields_k)
            mg_si.(si_fields_k) = dat_si_b.(si_fields_k);
        else
            mg_si.(si_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', si_fields_k)
        end % if
    end % for
else
    mg_si = [];
    cprintf('SystemCommands', 'No SessInfo available, ')
end % if

end % function

function mg_es = mergeEyeSampleA(dat_es, varargin)

es_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp'        % target not disppear subjectively
    };

for k = 1:numel(es_fields)
    es_fields_k = es_fields{k};
    if isfield(dat_es, es_fields_k)
        mg_es.(es_fields_k) = dat_es.(es_fields_k);
    else
        mg_es.(es_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', es_fields_k)
    end % if
    
end % for

end % function

function mg_es = mergeEyeSampleB(dat_es, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3195) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

es_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp'        % target not disppear subjectively
    };

for k = 1:numel(es_fields)
    es_fields_k = es_fields{k};
    if isfield(dat_es, es_fields_k)
        d_k = dat_es.(es_fields_k);
        d_k.x = d_k.x(t_idx, :);
        d_k.y = d_k.y(t_idx, :);
        
        mg_es.(es_fields_k) = d_k;
    else
        mg_es.(es_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', es_fields_k)
    end % if
    
end % for

end % function

function mg_es = mergeEyeSampleAB(dat_es_a, dat_es_b, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3195) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

es_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp'        % target not disppear subjectively
    };

if ~isempty(dat_es_a) && isempty(dat_es_b)
    mg_es = mergeEyeSampleA(dat_es_a, varargin);
elseif isempty(dat_es_a) && ~isempty(dat_es_b)
    mg_es = mergeEyeSampleA(dat_es_b, varargin);    
else
    for k = 1:numel(es_fields)
        es_fields_k = es_fields{k};
        if isfield(dat_es_a, es_fields_k) && ~isfield(dat_es_b, es_fields_k)
            mg_es.(es_fields_k) = dat_es_a(es_fields_k);
        elseif ~isfield(dat_es_a, es_fields_k) && isfield(dat_es_b, es_fields_k)
            d_k = dat_es_b.(es_fields_k);
            d_k.x = d_k.x(t_idx, :);
            d_k.y = d_k.y(t_idx, :);
            mg_es.(es_fields_k) = d_k;
        elseif isfield(dat_es_a, es_fields_k) && isfield(dat_es_b, es_fields_k)
            d_ak = dat_es_a.(es_fields_k);
            
            d_bk = dat_es_b.(es_fields_k);
            d_bk.x = d_bk.x(t_idx, :);
            d_bk.y = d_bk.y(t_idx, :);
            
            % validate data
            if norm(d_ak.x - d_bk.x) ~= 0 || norm(d_ak.y - d_bk.y) ~= 0
                error('GfsMSacc:mergeData:mergeEyeSampleAB',...
                    '%s of EyeSample is not consistent.', es_fields_k)
            end % if
            mg_es.(es_fields_k) = d_ak;
        else
            mg_es.(es_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', es_fields_k)
        end % if
        
    end % for
end % if

end % function

function mg_ci = mergeChanInfo(dat_ci, varargin)

ci_fields = { 'CorAreaID',...       % cortical area ID
    'ElectrodNum',...     % number of electrode
    'GridIndex'...        % grid indexes
    };

for k = 1:numel(ci_fields)
    ci_fields_k = ci_fields{k};
    if isfield(dat_ci, ci_fields_k)
        mg_ci.(ci_fields_k) = dat_ci.(ci_fields_k);
    else
        mg_ci.(ci_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', ci_fields_k)
    end % if
end % for

end % function

function mg_ci = mergeChanInfoAB(dat_ci_a, dat_ci_b, varargin)

ci_fields = { 'CorAreaID',...       % cortical area ID
    'ElectrodNum',...     % number of electrode
    'GridIndex'...        % grid indexes
    };

if ~isempty(dat_ci_a) && isempty(dat_ci_b)
    mg_ci = mergeChanInfo(dat_ci_a, varargin);
elseif isempty(dat_ci_a) && ~isempty(dat_ci_b)
    mg_ci = mergeChanInfo(dat_ci_b, varargin);
else
    for k = 1:numel(ci_fields)
        ci_fields_k = ci_fields{k};
        if isfield(dat_ci_a, ci_fields_k) && isfield(dat_ci_b, ci_fields_k)
            d_ak = dat_ci_a.(ci_fields_k);
            d_bk = dat_ci_b.(ci_fields_k);
            if norm(d_ak - d_bk) ~= 0
                cprintf('SystemCommands', '%s is not consistent, ', ci_fields_k)
            end % if
            mg_ci.(ci_fields_k) = d_ak;
        else
            mg_ci.(ci_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', ci_fields_k)
        end % if
    end % for
end % if

end % function

function mg_lfp = mergeLfpA(dat_lfp, varargin)

lfp_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

for k = 1:numel(lfp_fields)
    lfp_fields_k = lfp_fields{k};
    if isfield(dat_lfp, lfp_fields_k)
        mg_lfp.(lfp_fields_k) = dat_lfp.(lfp_fields_k);
    else
        mg_lfp.(lfp_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', lfp_fields_k)
    end % if
    
end % for

end % function

function mg_lfp = mergeLfpB(dat_lfp, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3200) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

lfp_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

for k = 1:numel(lfp_fields)
    lfp_fields_k = lfp_fields{k};
    if isfield(dat_lfp, lfp_fields_k)
        d_k = dat_lfp.(lfp_fields_k);
        d_k = d_k(t_idx, :, :);
        
        mg_lfp.(lfp_fields_k) = d_k;
    else
        mg_lfp.(lfp_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', lfp_fields_k)
    end % if
    
end % for

end % function

function mg_lfp = mergeLfpAB(dat_lfp_a, dat_lfp_b, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3200) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

lfp_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

if ~isempty(dat_lfp_a) && isempty(dat_lfp_b)
    mg_lfp = mergeLfpA(dat_lfp_a, varargin);
elseif isempty(dat_lfp_a) && ~isempty(dat_lfp_b)
    mg_lfp = mergeLfpB(dat_lfp_b, varargin);
else
    for k = 1:numel(lfp_fields)
        lfp_fields_k = lfp_fields{k};
        if isfield(dat_lfp_a, lfp_fields_k) && ~isfield(dat_lfp_b, lfp_fields_k)
            mg_lfp.(lfp_fields_k) = dat_lfp_a(lfp_fields_k);
        elseif ~isfield(dat_lfp_a, lfp_fields_k) && isfield(dat_lfp_b, lfp_fields_k)
            d_k = dat_lfp_b.(lfp_fields_k);
            d_k = d_k(t_idx, :, :);
            mg_lfp.(lfp_fields_k) = d_k;
        elseif isfield(dat_lfp_a, lfp_fields_k) && isfield(dat_lfp_b, lfp_fields_k)
            d_ak = dat_lfp_a.(lfp_fields_k);
            
            d_bk = dat_lfp_b.(lfp_fields_k);
            d_bk = d_bk(t_idx, :, :);
            
            % validate data
            if numel(d_ak(:)) == numel(d_bk(:))
                if norm(d_ak(:) - d_bk(:)) ~= 0
                    error('GfsMSacc:mergeData:mergeEyeSampleAB',...
                        '%s of LFP is not consistent.', lfp_fields_k)
                end % if
            else
                cprintf('SystemCommands',...
                    '%s of LFP is not consistent, Use Type A, ', lfp_fields_k)
            end % if
            mg_lfp.(lfp_fields_k) = d_ak;
        else
            mg_lfp.(lfp_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', lfp_fields_k)
        end % if
        
    end % for
end % if

end % function

function mg_mua = mergeMuaA(dat_mua, varargin)

mua_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

for k = 1:numel(mua_fields)
    mua_fields_k = mua_fields{k};
    if isfield(dat_mua, mua_fields_k)
        mg_mua.(mua_fields_k) = dat_mua.(mua_fields_k);
    else
        mg_mua.(mua_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', mua_fields_k)
    end % if
    
end % for

end % function

function mg_mua = mergeMuaB(dat_mua, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3200) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

mua_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

for k = 1:numel(mua_fields)
    mua_fields_k = mua_fields{k};
    if isfield(dat_mua, mua_fields_k)
        d_k = dat_mua.(mua_fields_k);
        d_k = d_k(t_idx, :, :);
        
        mg_mua.(mua_fields_k) = d_k;
    else
        mg_mua.(mua_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', mua_fields_k)
    end % if
    
end % for

end % function

function mg_mua = mergeMuaAB(dat_mua_a, dat_mua_b, varargin)

trl_len = varargin{1};
tag_on  = varargin{2};

tb = (1:3200) - 800;
t_idx = tb > -tag_on & tb <= trl_len - tag_on;

mua_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp',...    % target not disppear subjectively
    'PhysDisp'          % target physically removed after surround onset
    };

if ~isempty(dat_mua_a) && isempty(dat_mua_b)
    mg_mua = mergeMuaA(dat_mua_a, varargin);
elseif isempty(dat_mua_a) && ~isempty(dat_mua_b)
    mg_mua = mergeMuaB(dat_mua_b, varargin);
else
    for k = 1:numel(mua_fields)
        mua_fields_k = mua_fields{k};
        if isfield(dat_mua_a, mua_fields_k) && ~isfield(dat_mua_b, mua_fields_k)
            mg_mua.(mua_fields_k) = dat_mua_a(mua_fields_k);
        elseif ~isfield(dat_mua_a, mua_fields_k) && isfield(dat_mua_b, mua_fields_k)
            d_k = dat_mua_b.(mua_fields_k);
            d_k = d_k(t_idx, :, :);
            mg_mua.(mua_fields_k) = d_k;
        elseif isfield(dat_mua_a, mua_fields_k) && isfield(dat_mua_b, mua_fields_k)
            d_ak = dat_mua_a.(mua_fields_k);
            
            d_bk = dat_mua_b.(mua_fields_k);
            d_bk = d_bk(t_idx, :, :);
            
            % validate data
            if numel(d_ak(:)) == numel(d_bk(:))
                if norm(d_ak(:) - d_bk(:)) ~= 0
                    error('GfsMSacc:mergeData:mergeEyeSampleAB',...
                        '%s of MUA is not consistent.', mua_fields_k)
                end % if
            else
                cprintf('SystemCommands',...
                    '%s of MUA is not consistent, Use Type A, ', mua_fields_k)
            end % if
            mg_mua.(mua_fields_k) = d_ak;
        else
            mg_mua.(mua_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', mua_fields_k)
        end % if
    end % if
end % for

end % function

function mg_mwblp = mergeMwblp(dat_mwblp, varargin)

blp_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp'        % target not disppear subjectively
    };

for k = 1:numel(blp_fields)
    blp_fields_k = blp_fields{k};
    if isfield(dat_mwblp, blp_fields_k)
        mg_mwblp.(blp_fields_k) = dat_mwblp.(blp_fields_k);
    else
        mg_mwblp.(blp_fields_k) = [];
        cprintf('SystemCommands', 'No %s available, ', blp_fields_k)
    end % if
    
end % for

end % function

function mg_mwblp = mergeMwblpAB(dat_mwblp_a, dat_mwblp_b, varargin)

blp_fields = { 'SubjDisp',...    % target disppear subjectively
    'SubjNoDisp'        % target not disppear subjectively
    };

if ~isempty(dat_mwblp_a) && isempty(dat_mwblp_b)
    mg_mwblp = mergeMwblp(dat_mwblp_a, varargin);
elseif isempty(dat_mwblp_a) && ~isempty(dat_mwblp_b)
    mg_mwblp = mergeMwblp(dat_mwblp_b, varargin);
else
    for k = 1:numel(blp_fields)
        blp_fields_k = blp_fields{k};
        if isfield(dat_mwblp_a, blp_fields_k) && isfield(dat_mwblp_b, blp_fields_k)
            mg_mwblp.(blp_fields_k) = dat_mwblp_a.(blp_fields_k);
        else
            mg_mwblp.(blp_fields_k) = [];
            cprintf('SystemCommands', 'No %s available, ', blp_fields_k)
        end % if
        
    end % for
end % if

end % function


function data = mergeTypeA(sess)
% Only Type A data available

dat_lock = mergeVars(sess, 'lock', @mergeLock);     % lock variable
sess_info = mergeVars(sess, 'SessInfo', @mergeSessInfoA);   % SessInfo
ch_info = mergeVars(sess, 'ChannelInfo', @mergeChanInfo);   % ChannelInfo
eye_samp = mergeVars(sess, 'EyeSamples', @mergeEyeSampleA); % EyeSamples
lfp = mergeVars(sess, 'LFP', @mergeLfpA);       % LFP
mua = mergeVars(sess, 'MUA', @mergeMuaA);       % MUA
mwblp = mergeVars(sess, 'mwblp', @mergeMwblp);  % Mwblp

% -------
% commit 
% -------
data.lock           = dat_lock;
data.SessInfo       = sess_info;
data.ChannelInfo    = ch_info;
data.EyeSamples     = eye_samp;
data.LFP            = lfp;
data.MUA            = mua;
data.mwblp          = mwblp;

end % function

function data = mergeTypeB(sess)
% Only Type B data available

dat_lock = mergeVars(sess, 'lock', @mergeLock);     % lock variable
sess_info = mergeVars(sess, 'SessInfo', @mergeSessInfoB);   % SessInfo
ch_info = mergeVars(sess, 'ChannelInfo', @mergeChanInfo);   % ChannelInfo
eye_samp = mergeVars(sess, 'EyeSamples', @mergeEyeSampleB,...
    sess_info.TrialLength, sess_info.TargetOnset); % EyeSamples
lfp = mergeVars(sess, 'LFP', @mergeLfpB,...
    sess_info.TrialLength, sess_info.TargetOnset); % LFP
mua = mergeVars(sess, 'MUA', @mergeMuaB,...
    sess_info.TrialLength, sess_info.TargetOnset); % MUA
mwblp = mergeVars(sess, 'mwblp', @mergeMwblp);  % Mwblp

% -------
% commit 
% -------
data.lock           = dat_lock;
data.SessInfo       = sess_info;
data.ChannelInfo    = ch_info;
data.EyeSamples     = eye_samp;
data.LFP            = lfp;
data.MUA            = mua;
data.mwblp          = mwblp;

end % function

function data = mergeTypeAB(sess_a, sess_b)
% Both types of data are avilable

sess = {sess_a, sess_b};
dat_lock = mergeVars(sess, 'lock', @mergeLockAB);   % lock variable
sess_info = mergeVars(sess, 'SessInfo', @mergeSessInfoAB);  % SessInfo
ch_info = mergeVars(sess, 'ChannelInfo', @mergeChanInfoAB); % ChannelInfo
eye_samp = mergeVars(sess, 'EyeSamples', @mergeEyeSampleAB,...
    sess_info.TrialLength, sess_info.TargetOnset);  % EyeSamples
lfp = mergeVars(sess, 'LFP', @mergeLfpAB,...
    sess_info.TrialLength, sess_info.TargetOnset);  % LFP
mua = mergeVars(sess, 'MUA', @mergeMuaAB,...
    sess_info.TrialLength, sess_info.TargetOnset);  % MUA
mwblp = mergeVars(sess, 'mwblp', @mergeMwblpAB);    % Mwblp

% -------
% commit 
% -------
data.lock           = dat_lock;
data.SessInfo       = sess_info;
data.ChannelInfo    = ch_info;
data.EyeSamples     = eye_samp;
data.LFP            = lfp;
data.MUA            = mua;
data.mwblp          = mwblp;

end % function

% [EOF]

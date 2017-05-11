function gfsms_exp = GFSImportMAT(pathname, filename, values)
% GFSIMPORTMAT import data from GfsMSacc experiments
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Thu 06/02/2016  5:37:08.804 PM
% $Revision: 0.4 $  $Date: Thu 07/07/2016  9:49:50.647 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% load data in
% ------------
if strcmp(pathname(end), filesep) == true
    wholename = [pathname, filename];
else
    wholename = [pathname, filesep, filename];
end % if
    
switch values.sess_type
    case 'A'    % 1904 data set
        gfsms_exp = importDatasetA( wholename, values );
    case 'B'    % 2006 data set
        gfsms_exp = importDatasetB( wholename, values );
    otherwise
        error('GfsMSacc:importExp', 'Unknow dataset type.')
end % switch

end % function GFSImportMAT

% =========================================================================
% subroutines
% =========================================================================
function gfsms_exp = importDatasetA( wholename, values )
% import data from type A dataset - 1904

cprintf('Keywords', 'Inputing channel/session information...')
load(wholename)

% get channel information
% ------------------------
cha_info.CorAreaID      = values.area_code;     % cortical areal id
cha_info.ElectrodNum    = values.eled_num;      % electrode numbers
cha_info.GridIndex      = values.grid_idx;      % electrode grid index

% get session information
% -----------------------
sess_info.MonkeyID  = values.monkey_id;     % name of the monkey
sess_info.SessType  = values.sess_type;     % session type: A - 1904 or B - 2006

sess_info.RelLatShort   = AddInfo.rellat_short;         % level release latency - short (usu. < 1000 ms)
sess_info.RelLatAll     = AddInfo.rellat_TrigplusSpont; % all latency of level release, including both those triggered by invisibility and spontanously
sess_info.TrialLength   = AddInfo.pre + AddInfo.post;   % trial length (ms)
sess_info.TargetOnset   = AddInfo.targOnset;    % target onset time (ms)
sess_info.SurroundOnset = AddInfo.suronset;     % surround onset time (ms)
sess_info.MaskOnset     = AddInfo.maskonset;    % ?

% target onset time
target_onset = sess_info.TargetOnset;
pre = AddInfo.pre;
if target_onset - pre ~= 0
    cprintf('Errors', '\nWarning: Target onset time is not consistent\n') 
else
    cprintf('Comments', ' O.K.\n')
end % if

% eye traces
% ----------
cprintf('Keywords', 'Inputing eye traces...')
if exist('SAC', 'var')
    % get data
    eye_samples.SubjDisp.x   = cell2mat( SAC.raw_hori_ncdis );   % signal x trials, horizontal eye traces for subjective disappear
    eye_samples.SubjDisp.y   = cell2mat( SAC.raw_verti_ncdis );  % vertical eye traces for subjective disappear
    
    eye_samples.SubjNoDisp.x = cell2mat( SAC.raw_hori_ncNodis );
    eye_samples.SubjNoDisp.y = cell2mat( SAC.raw_verti_ncNodis );
    
    % check trial numbers & signal length
    num_trl = numel(sess_info.RelLatShort);
    eye_numtrl_subjdis_x    = size(eye_samples.SubjDisp.x, 2);
    eye_numtrl_subjdis_y    = size(eye_samples.SubjDisp.y, 2);
    
    trl_len     = sess_info.TrialLength;
    eye_len_subjdis_x   = size(eye_samples.SubjDisp.x, 1);
    eye_len_subjdis_y   = size(eye_samples.SubjDisp.y, 1);
    eye_len_subjnodis_x = size(eye_samples.SubjNoDisp.x, 1);
    eye_len_subjnodis_y = size(eye_samples.SubjNoDisp.y, 1);
    
    if sum(abs([eye_numtrl_subjdis_x, eye_numtrl_subjdis_y] - num_trl)) ~= 0
        cprintf('Errors', '\nWarning: Number of trials of SAC is not consistent\n')
    elseif sum([eye_len_subjdis_x, eye_len_subjdis_y, ...
            eye_len_subjnodis_x, eye_len_subjnodis_y] - trl_len)
        cprintf('Errors', '\nWarning: Signal length of SAC is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No SAC eye signals available.\n')
    eye_samples = [];
end % if

% LFP signals
% -----------
cprintf('Keywords', 'Inputing LFP signals...')
if exist('LFPs', 'var')
    % get data
    lfp.SubjDisp    = LFPs.subjdis;     % signals x channels x trials
    lfp.SubjNoDisp  = LFPs.subjNodis;   % signals x channels x trials
    lfp.PhysDisp    = LFPs.physdis;     
    
    % check signal length, number of trials & number of channels
    trl_len     = sess_info.TrialLength;
    lfp_len_subjdis     = size(lfp.SubjDisp, 1);
    lfp_len_subjNodis   = size(lfp.SubjNoDisp, 1);
    lfp_len_physdis     = size(lfp.PhysDisp, 1);
    
    num_trl = numel(sess_info.RelLatShort);
    lfp_numtrl_subjdis   = size(lfp.SubjDisp, 3);

    num_electrodes      = numel(cha_info.ElectrodNum);
    lfp_numch_subjdis   = size(lfp.SubjDisp, 2);
    lfp_numch_subjnodis = size(lfp.SubjNoDisp, 2);
    lfp_numch_physdis   = size(lfp.PhysDisp, 2);
    
    if sum(abs([lfp_len_subjdis, lfp_len_subjNodis, lfp_len_physdis] - trl_len)) ~= 0
        cprintf('Errors', '\nWarning: Signal length of LFP is not consistent\n')
    elseif lfp_numtrl_subjdis - num_trl ~= 0
        cprintf('Errors', '\nWarning: Number of trials of LFP is not consistent\n')
    elseif sum(abs([lfp_numch_subjdis, lfp_numch_subjnodis, lfp_numch_physdis] - num_electrodes)) ~= 0
        cprintf('Errors', '\nWarning: Number of channels of LFP is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No LFP signals available.\n')
    lfp = [];    
end % if

% MUA signals
% -----------
cprintf('Keywords', 'Inputing MUA signals...')
if exist('MUAs', 'var')
    % get data
    mua.SubjDisp    = MUAs.subjdis;
    mua.SubjNoDisp  = MUAs.subjNodis;
    mua.PhysDisp    = MUAs.physdis;
    
    % check signal length, number of trials & number of channels
    trl_len     = sess_info.TrialLength;
    mua_len_subjdis     = size(mua.SubjDisp, 1);
    mua_len_subjNodis   = size(mua.SubjNoDisp, 1);

    num_trl = numel(sess_info.RelLatShort);
    mua_numtrl_subjdis  = size(mua.SubjDisp, 3);
    mua_len_physdis     = size(mua.PhysDisp, 1);

    num_electrodes      = numel(cha_info.ElectrodNum);
    mua_numch_subjdis   = size(mua.SubjDisp, 2);
    mua_numch_subjnodis = size(mua.SubjNoDisp, 2);
    mua_numch_physdis   = size(mua.PhysDisp, 2);

    if sum(abs([mua_len_subjdis, mua_len_subjNodis, mua_len_physdis] - trl_len)) ~= 0
        cprintf('Errors', '\nWarning: Signal length of MUA is not consistent\n')
    elseif mua_numtrl_subjdis - num_trl ~= 0
        cprintf('Errors', '\nWarning: Number of trials of MUA is not consistent\n')
    elseif sum(abs([mua_numch_subjdis, mua_numch_subjnodis, mua_numch_physdis] - num_electrodes)) ~= 0
        cprintf('Errors', '\nWarning: Number of channels of MUA is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
    
else
    cprintf('Errors', '\nWarning: No MUA signals available.\n')
    mua = [];
end % if

% commit
% ------
gfsms_exp.ChannelInfo   = cha_info;
gfsms_exp.SessInfo      = sess_info;
gfsms_exp.EyeSamples    = eye_samples;
gfsms_exp.LFP           = lfp;
gfsms_exp.MUA           = mua;

end % function

function gfsms_exp = importDatasetB( wholename, values )
% import data from type B dataset - 2006

cprintf('Keywords', 'Inputing channel/session information...')
load(wholename)

% get channel information
% ------------------------
cha_info.CorAreaID      = values.area_code;     % cortical areal id
cha_info.ElectrodNum    = values.eled_num;      % electrode numbers
cha_info.GridIndex      = values.grid_idx;      % electrode grid index

% get session information
% -----------------------
sess_info.MonkeyID  = values.monkey_id;     % name of the monkey
sess_info.SessType  = values.sess_type;     % session type: A - 1904 or B - 2006

sess_info.RelLatShort   = AddInfo.rellat_short;         % level release latency - short (usu. < 1000 ms)
sess_info.RelLatAll     = AddInfo.rellat_all;   % all latency of level release, including both those triggered by invisibility and spontanously
sess_info.TrialLength   = AddInfo.pre + AddInfo.post;   % trial length (ms)
sess_info.TargetOnset   = AddInfo.pre;          % assume target onset time (ms) = pre time
if exist('AddInfo.suronset', 'var')
    sess_info.SurroundOnset = AddInfo.suronset;     % surround onset time (ms)
else
    cprintf('Errors', '\nWarning: No surround onset information.\n')
    sess_info.SurroundOnset = [];
end % if
if exist('tagpos', 'var')
    sess_info.TargetPos     = tagpos;               % target position in dva
else
    cprintf('Errors', '\nWarning: No target position information.\n')
    sess_info.TargetPos     = [];
end % if

% target onset time
target_onset = sess_info.TargetOnset;
pre = AddInfo.pre;
if target_onset - pre ~= 0
    cprintf('Errors', '\nWarning: Target onset time is not consistent\n')  
elseif ~isempty(sess_info.SurroundOnset) && ~isempty(sess_info.TargetPos)
    cprintf('Comments', ' O.K.\n')
end % if

% eye traces
% ----------
cprintf('Keywords', 'Inputing eye traces...')
if exist('SACON', 'var')
    % get data
    eye_samples.SubjDisp.x   = SACON.rHor_subjdis;      % signal x trials, horizontal eye traces for subjective disappear
    eye_samples.SubjDisp.y   = SACON.rVert_subjdis;     % vertical eye traces for subjective disappear
    
    eye_samples.SubjNoDisp.x = SACON.rHor_nosubjdis;
    eye_samples.SubjNoDisp.y = SACON.rVert_nosubjdis;

    % check trial numbers & signal length
    num_trl = numel(sess_info.RelLatShort);
    eye_numtrl_subjdis_x    = size(eye_samples.SubjDisp.x, 2);
    eye_numtrl_subjdis_y    = size(eye_samples.SubjDisp.y, 2);

    trl_len     = sess_info.TrialLength;
    eye_len_subjdis_x   = size(eye_samples.SubjDisp.x, 1);
    eye_len_subjdis_y   = size(eye_samples.SubjDisp.y, 1);
    eye_len_subjnodis_x = size(eye_samples.SubjNoDisp.x, 1);
    eye_len_subjnodis_y = size(eye_samples.SubjNoDisp.y, 1);

    if sum(abs([eye_numtrl_subjdis_x, eye_numtrl_subjdis_y] - num_trl)) ~= 0
        cprintf('Errors', '\nWarning: Number of trials of SACON is not consistent\n')
    elseif sum(abs([eye_len_subjdis_x, eye_len_subjdis_y, ...
            eye_len_subjnodis_x, eye_len_subjnodis_y] - trl_len)) ~= 0
        cprintf('Errors', '\nWarning: Signal length of SACON is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No SACON eye signals available.\n')
    eye_samples = [];    
end % if


% LFP signals
% -----------
cprintf('Keywords', 'Inputing LFP signals...')
if exist('LFP', 'var')
    % get data
    lfp.SubjDisp    = LFP.subjdis;     % signals x channels x trials
    lfp.SubjNoDisp  = LFP.subjNodis;   % signals x channels x trials
    lfp.PhysDisp    = LFP.physdis;
    
    % check signal length, number of trials & number of channels
    trl_len             = sess_info.TrialLength;
    lfp_len_subjdis     = size(lfp.SubjDisp, 1);
    lfp_len_subjNodis   = size(lfp.SubjNoDisp, 1);
    lfp_len_physdis     = size(lfp.PhysDisp, 1);

    num_trl = numel(sess_info.RelLatShort);
    lfp_numtrl_subjdis      = size(lfp.SubjDisp, 3);
    
    num_electrodes      = numel(cha_info.ElectrodNum);
    lfp_numch_subjdis   = size(lfp.SubjDisp, 2);
    lfp_numch_subjnodis = size(lfp.SubjNoDisp, 2);
    lfp_numch_phydis    = size(lfp.PhysDisp, 2);
    
    if sum(abs([lfp_len_subjdis, lfp_len_subjNodis, lfp_len_physdis] - trl_len)) ~= 0
        cprintf('Errors', '\nWarning: Signal length of LFP is not consistent\n')
    elseif lfp_numtrl_subjdis - num_trl ~= 0
        cprintf('Errors', '\nWarning: Number of trials of LFP is not consistent\n')
    elseif sum(abs([lfp_numch_subjdis, lfp_numch_subjnodis, lfp_numch_phydis] - num_electrodes)) ~= 0
        cprintf('Errors', '\nWarning: Number of channels of LFP is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No LFP signals available.\n')
    lfp = [];        
end % if

% MUA signals
% -----------
cprintf('Keywords', 'Inputing MUA signals...')
if exist('MUA', 'var') > 0
    % get data
    mua.SubjDisp    = MUA.subjdis;
    mua.SubjNoDisp  = MUA.subjNodis;
    mua.PhysDisp    = MUA.physdis;
    
    % check signal length, number of trials & number of channels
    trl_len             = sess_info.TrialLength;
    mua_len_subjdis     = size(mua.SubjDisp, 1);
    mua_len_subjNodis   = size(mua.SubjNoDisp, 1);
    mua_len_physdis     = size(mua.PhysDisp, 1);
    
    num_trl = numel(sess_info.RelLatShort);
    mua_numtrl_subjdis  = size(mua.SubjDisp, 3);
    
    num_electrodes      = numel(cha_info.ElectrodNum);
    mua_numch_subjdis   = size(mua.SubjDisp, 2);
    mua_numch_subjnodis = size(mua.SubjNoDisp, 2);
    mua_numch_physdis   = size(mua.PhysDisp, 2);

    if sum(abs([mua_len_subjdis, mua_len_subjNodis, mua_len_physdis] - trl_len)) ~= 0
        cprintf('Errors', '\nWarning: Signal length of MUA is not consistent\n')
    elseif mua_numtrl_subjdis - num_trl ~= 0
        cprintf('Errors', '\nWarning: Number of trials of MUA is not consistent\n')
    elseif sum(abs([mua_numch_subjdis, mua_numch_subjnodis, mua_numch_physdis] - num_electrodes)) ~= 0
        cprintf('Errors', '\nWarning: Number of channels of MUA is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No MUA for the session.\n')
    mua = [];
end % if

% MW-BLP signals
% --------------
cprintf('Keywords', 'Inputing MW-BLP signals...')
if exist('BLP', 'var')
    % get data
    mwblp.SubjDisp      = BLP.subjdis;      % channel x trial x signal x band
    mwblp.SubjNoDisp    = BLP.subjNodis;
    mwblp.PhysDisp      = BLP.physdis;
    
    % check number of trials & number of channels
    num_electrodes      = numel(cha_info.ElectrodNum);
    mwblp_numch_subjdis    = size(mwblp.SubjDisp, 1);
    mwblp_numch_subjnodis  = size(mwblp.SubjNoDisp, 1);
    mwblp_numch_physdis    = size(mwblp.PhysDisp, 1);
    
    num_trl = numel(sess_info.RelLatShort);
    mwblp_numtrl_subjdis    = size(mwblp.SubjDisp, 2);
    
    if sum(abs([mwblp_numch_subjdis, mwblp_numch_subjnodis, mwblp_numch_physdis] - num_electrodes)) ~= 0
        cprintf('Errors', '\nWarning: Number of channels of MW-BLP is not consistent\n')
    elseif mwblp_numtrl_subjdis - num_trl ~= 0
        cprintf('Errors', '\nWarning: Number of trials of MW-BLP is not consistent\n')
    else
        cprintf('Comments', ' O.K.\n')
    end % if
else
    cprintf('Errors', '\nWarning: No MW-BLP signals available.\n')
    mwblp = [];
end % if


% commit
gfsms_exp.ChannelInfo   = cha_info;
gfsms_exp.SessInfo      = sess_info;
gfsms_exp.EyeSamples    = eye_samples;
gfsms_exp.LFP           = lfp;
gfsms_exp.MUA           = mua;
gfsms_exp.mwblp         = mwblp;

end % function

% [EOF]

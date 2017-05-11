function [chan, eye_samples, lfp, mua] = gms_trial_valid_index( this )
% GMSTRIAL.GMS_TRIAL_VALID_INDEX get valid trial indexes
%
% Syntax:
%
% Input(s):
%
% Output(s):
%   chan        - channels
%   eye_samples
%   lfp
%   mua
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 07/15/2016 11:13:42.173 PM
% $Revision: 0.2 $  $Date: Fri 07/29/2016  5:28:36.084 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% get session name
sname = this.sname;
eye_samples = struct('SubjDisp', [], 'SubjNoDisp', []);

switch sname
    % ---------
    % Dali - D
    % ---------
    case{'GMSD120304'}
        % parameters
        num_trl.subjdisp    = 5;
        num_trl.subjnodisp  = 39;
        num_trl.physdisp    = 28;
        num_chs             = 9;
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSD130304'}
        % parameters
        num_trl.subjdisp    = 18;
        num_trl.subjnodisp  = 17;
        num_trl.physdisp    = 34;
        num_chs             = 10;
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSD160304'}
        % parameters
        num_trl.subjdisp    = 83;
        num_trl.subjnodisp  = 4;
        num_trl.physdisp    = 84;
        num_chs             = 9; % channel number in data
        
        % channel validation
        chan = [true(1, 9), false]; % channel number indicated is 10; get rid of one arbitrarily
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {2, [73, 74, 78, 79];
                               4, [75, 76];
                               8, [72, 81:83]};
        inval_subjnodisp    = {};
        inval_physdisp      = {2, [78, 81, 83];
                               4, [79, 82, 84];
                               6, 77;
                               8, 80};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSD180304'}
        % parameters
        num_trl.subjdisp    = 27;
        num_trl.subjnodisp  = 34;
        num_trl.physdisp    = 60;
        num_chs             = 10; % channel number in data
        
        % channel validation
        chan = true(1, num_chs); 
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {3, 60};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSD190304'}
        % parameters
        num_trl.subjdisp    = 15;
        num_trl.subjnodisp  = 31;
        num_trl.physdisp    = 63;
        num_chs             = 8; % channel number in data
        
        % channel validation
        chan = true(1, num_chs); 
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {5, 1:num_trl.subjdisp};
        inval_subjnodisp    = {5, 1:num_trl.subjnodisp};
        inval_physdisp      = {5, 1:num_trl.physdisp};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSD200304'}
        % parameters
        num_trl.subjdisp    = 17;
        num_trl.subjnodisp  = 36;
        num_trl.physdisp    = 66;
        num_chs             = 7;
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSD210304'}
        % parameters
        num_trl.subjdisp    = 20;
        num_trl.subjnodisp  = 45;
        num_trl.physdisp    = 69;
        num_chs             = 8; % 9 indicated, but only 8 in signals
        
        % channel validation
        chan = [true(1, num_chs), false];
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSD220304'}
        % parameters
        num_trl.subjdisp    = 6;
        num_trl.subjnodisp  = 43;
        num_trl.physdisp    = 30;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % ---------
        % Ernst - E
        % ---------
    case{'GMSE020503'}
        % parameters
        num_trl.subjdisp    = 60;
        num_trl.subjnodisp  = 31;
        num_trl.physdisp    = 84;
        num_chs             = 12; % 13 indicared
        
        % channel validation
        chan = [true(1, num_chs), false];
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {1, [50, 60];
                               3, [45, 47, 48, 51, 58];
                               4, 53;
                               6, 46;
                               7, 59};
        inval_subjnodisp    = {6, 29;
                               9, 31};
        inval_physdisp      = {1, [67, 77, 84];
                               2, 68;
                               3, [69, 78];
                               4, [73, 76, 83];
                               5, 62;
                               6, 74;
                               7, [70, 75];
                               8, [63, 66, 71, 81];
                               9, [65, 82]};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
                
    case{'GMSE040603'}
        % parameters
        num_trl.subjdisp    = 24;
        num_trl.subjnodisp  = 64;
        num_trl.physdisp    = 55;
        num_chs             = 15; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE060603'}
        % parameters
        num_trl.subjdisp    = 84;
        num_trl.subjnodisp  = 16;
        num_trl.physdisp    = 54;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {2, [82, 84];
                               4, 81;
                               6, 80;
                               7, 83};
        inval_subjnodisp    = {7, 16};
        inval_physdisp      = {5, 54;
                               9, 51;
                               10, 53};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        inval_subjdisp      = {2, [82, 84];
                               4, 81;
                               6, 1:80;
                               7, 83;
                               8, [82, 84];
                               10, 81};
        inval_subjnodisp    = {6, 1:15;
                               7, 16};
        inval_physdisp      = {2, 51;
                               3, 53;
                               5, 54;
                               6, 1:52;
                               9, 51;
                               10, 53;
                               11, 54};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE080603'}
        % parameters
        num_trl.subjdisp    = 33;
        num_trl.subjnodisp  = 19;
        num_trl.physdisp    = 48;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE100603'}
        % parameters
        num_trl.subjdisp    = 25;
        num_trl.subjnodisp  = 30;
        num_trl.physdisp    = 65;
        num_chs             = 11; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE110403'}
        % parameters
        num_trl.subjdisp    = 55;
        num_trl.subjnodisp  = 17;
        num_trl.physdisp    = 25;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE120403'}
        % parameters
        num_trl.subjdisp    = 38;
        num_trl.subjnodisp  = 6;
        num_trl.physdisp    = 20;
        num_chs             = 11; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE120603'}
        % parameters
        num_trl.subjdisp    = 8;
        num_trl.subjnodisp  = 42;
        num_trl.physdisp    = 49;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSE130403'}
        % parameters
        num_trl.subjdisp    = 11;
        num_trl.subjnodisp  = 21;
        num_trl.physdisp    = 13;
        num_chs             = 11; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE140303'}
        % parameters
        num_trl.subjdisp    = 30;
        num_trl.subjnodisp  = 29;
        num_trl.physdisp    = 20;
        num_chs             = 11; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE150403'}
        % parameters
        num_trl.subjdisp    = 32;
        num_trl.subjnodisp  = 3;
        num_trl.physdisp    = 11;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE160403'}
        % parameters
        num_trl.subjdisp    = 21;
        num_trl.subjnodisp  = 12;
        num_trl.physdisp    = 11;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE170403'}
        % parameters
        num_trl.subjdisp    = 21;
        num_trl.subjnodisp  = 12;
        num_trl.physdisp    = 11;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {10, 37;
                               11, 36};
        inval_subjnodisp    = {4, 2};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE180403'}
        % parameters
        num_trl.subjdisp    = 37;
        num_trl.subjnodisp  = 9;
        num_trl.physdisp    = 19;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE190403'}
        % parameters
        num_trl.subjdisp    = 18;
        num_trl.subjnodisp  = 43;
        num_trl.physdisp    = 24;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE200403'}
        % parameters
        num_trl.subjdisp    = 10;
        num_trl.subjnodisp  = 16;
        num_trl.physdisp    = 11;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE200903'}
        % parameters
        num_trl.subjdisp    = 7;
        num_trl.subjnodisp  = 66;
        num_trl.physdisp    = 36;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {3, 7};
        inval_subjnodisp    = {1, 64;
                               2, 60;
                               3, [58, 65];
                               4, 63;
                               5, 59;
                               6, [57, 61];
                               7, 66;
                               9, 63;
                               10, [54, 56]};
        inval_physdisp      = {1, 34;
                               2, 36;
                               5, 27;
                               8, [28, 30, 32];
                               9, [26, 31, 33, 35];
                               10, 29};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE220403'}
        % parameters
        num_trl.subjdisp    = 21;
        num_trl.subjnodisp  = 29;
        num_trl.physdisp    = 19;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE230403'}
        % parameters
        num_trl.subjdisp    = 23;
        num_trl.subjnodisp  = 69;
        num_trl.physdisp    = 19;
        num_chs             = 8; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE240403'}
        % parameters
        num_trl.subjdisp    = 22;
        num_trl.subjnodisp  = 48;
        num_trl.physdisp    = 26;
        num_chs             = 12; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {3, 21;
                               4, 22};
        inval_subjnodisp    = {3, [45, 46];
                               4, 44;
                               8, 47};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        inval_subjdisp      = {3, 21;
                               4, 22;
                               6, 1;
                               7, 1:6;
                               8, 1:8;
                               9, 1:9;
                               10, 1:10;
                               11, 1:11;
                               12, 1:6};
        inval_subjnodisp    = {3, [45, 46];
                               6, [1, 44];
                               7, 1:4;
                               8, [1:8, 47];
                               9, 1:13;
                               10, 1:14;
                               11, [1:16, 48]};
        inval_physdisp      = {6, 1;
                               7, 1:3;
                               8, 1:9;
                               9, 1:10;
                               10, 1:11;
                               11, 1:12;
                               12, 1:2};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE250903'}
        % parameters
        num_trl.subjdisp    = 5;
        num_trl.subjnodisp  = 56;
        num_trl.physdisp    = 57;
        num_chs             = 1; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {4, 5};
        inval_subjnodisp    = {4, [52, 53];
                               8, [51, 54, 55]};
        inval_physdisp      = {4, [48, 39, 52, 56, 57];
                               8, [47, 50, 51]};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE260403'}
        % parameters
        num_trl.subjdisp    = 53;
        num_trl.subjnodisp  = 34;
        num_trl.physdisp    = 42;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE270403'}
        % parameters
        num_trl.subjdisp    = 37;
        num_trl.subjnodisp  = 32;
        num_trl.physdisp    = 48;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE270503'}
        % parameters
        num_trl.subjdisp    = 32;
        num_trl.subjnodisp  = 66;
        num_trl.physdisp    = 61;
        num_chs             = 10; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {5, [31, 32];
                               8, 30};
        inval_subjnodisp    = {2, 66;
                               3, 63;
                               7, 64};
        inval_physdisp      = {4, 60;
                               7, 59;
                               8, 61};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE270903'}
        % parameters
        num_trl.subjdisp    = 34;
        num_trl.subjnodisp  = 35;
        num_trl.physdisp    = 60;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {5, 20;
                               6, 20;
                               7, 20;
                               8, 20;
                               9, 20};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE280403'}
        % parameters
        num_trl.subjdisp    = 34;
        num_trl.subjnodisp  = 35;
        num_trl.physdisp    = 60;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE290403'}
        % parameters
        num_trl.subjdisp    = 38;
        num_trl.subjnodisp  = 44;
        num_trl.physdisp    = 45;
        num_chs             = 9; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {5, [37, 38];
                               6, [37, 38];
                               8, 1:36;
                               9, 1:34};
        inval_subjnodisp    = {1, 43;
                               2, 43;
                               3, [41, 42];
                               4, [41, 42];
                               5, 44;
                               6, 44;
                               8, 1:40;
                               9, 1:39};
        inval_physdisp      = {1, 40:42;
                               2, 40:42;
                               3, 44;
                               4, 44;
                               6, [43, 45];
                               7, [43 45];
                               8, [1:39, 43, 45];
                               9, 1:35};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        inval_subjdisp      = {4, [37, 38];
                               5, [37, 38];
                               8, 1:36;
                               9, 1:34};
        inval_subjnodisp    = {1, 43;
                               2, 41:43;
                               3, [41, 42];
                               4, [41, 42, 44];
                               5, 44;
                               6, 44;
                               8, 1:40;
                               9, 1:39};
        inval_physdisp      = {1, 40:42;
                               2, 40:44;
                               3, 44;
                               4, 44;
                               6, [43, 45];
                               7, [43, 45];
                               8, [1:39, 43, 45];
                               9, 1:35};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE300903'}
        % parameters
        num_trl.subjdisp    = 23;
        num_trl.subjnodisp  = 31;
        num_trl.physdisp    = 45;
        num_chs             = 14; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {11, 31};
        inval_physdisp      = {9, 45;
                               11, 43;
                               14, 44};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

    case{'GMSE310503'}
        % parameters
        num_trl.subjdisp    = 73;
        num_trl.subjnodisp  = 20;
        num_trl.physdisp    = 49;
        num_chs             = 5; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);

        % ---------
        % Wally - W
        % ---------
    case{'GMSW010404'}
        % parameters
        num_trl.subjdisp    = 24;
        num_trl.subjnodisp  = 71;
        num_trl.physdisp    = 46;
        num_chs             = 6; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW020104'}
        % parameters
        num_trl.subjdisp    = 36;
        num_trl.subjnodisp  = 20;
        num_trl.physdisp    = 43;
        num_chs             = 4; 
        
        % channel validation
        chan = [true(1, num_chs), false(1, 5)];
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW040104'}
        % parameters
        num_trl.subjdisp    = 13;
        num_trl.subjnodisp  = 54;
        num_trl.physdisp    = 47;
        num_chs             = 5; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW040404'}
        % parameters
        num_trl.subjdisp    = 29;
        num_trl.subjnodisp  = 56;
        num_trl.physdisp    = 59;
        num_chs             = 5; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW060204'}
        % parameters
        num_trl.subjdisp    = 35;
        num_trl.subjnodisp  = 25;
        num_trl.physdisp    = 57;
        num_chs             = 4; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW070204'}
        % parameters
        num_trl.subjdisp    = 9;
        num_trl.subjnodisp  = 41;
        num_trl.physdisp    = 52;
        num_chs             = 4; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW090204'}
        % parameters
        num_trl.subjdisp    = 36;
        num_trl.subjnodisp  = 34;
        num_trl.physdisp    = 38;
        num_chs             = 5; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW170204'}
        % parameters
        num_trl.subjdisp    = 10;
        num_trl.subjnodisp  = 50;
        num_trl.physdisp    = 74;
        num_chs             = 4; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW190104'}
        % parameters
        num_trl.subjdisp    = 3;
        num_trl.subjnodisp  = 33;
        num_trl.physdisp    = 21;
        num_chs             = 4; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    case{'GMSW270104'}
        % parameters
        num_trl.subjdisp    = 76;
        num_trl.subjnodisp  = 32;
        num_trl.physdisp    = 78;
        num_chs             = 3; 
        
        % channel validation
        chan = true(1, num_chs);
        
        % eye samples trial validation
        eye_samples.SubjDisp    = true(1, num_trl.subjdisp);
        eye_samples.SubjNoDisp  = true(1, num_trl.subjnodisp);
        
        % LFP trials
        inval_subjdisp      = {};
        inval_subjnodisp    = {};
        inval_physdisp      = {};
        sig_inval.subjdisp      = inval_subjdisp;
        sig_inval.subjnodisp    = inval_subjnodisp;
        sig_inval.physdisp      = inval_physdisp;
        lfp = makeValSigTable(num_chs, num_trl, sig_inval);

        % MUA trials
        mua = makeValSigTable(num_chs, num_trl, sig_inval);
        
    otherwise
        cprintf('Errors', 'Unknown session %s.\n', sname)
        chan = [];
        eye_samples = [];
        lfp = [];
        mua = [];
end % switch

end % function gms_trial_valid_index

% =========================================================================
% Subroutines
% =========================================================================
function val_sig = makeValSigTable(num_ch, num_trl, sig_inval)

val_sig = struct('SubjDisp', table, 'SubjNoDisp', table, 'PhysDisp', table);

val_sig.SubjDisp    = makeValidTable(num_ch, num_trl.subjdisp, sig_inval.subjdisp);
val_sig.SubjNoDisp  = makeValidTable(num_ch, num_trl.subjnodisp, sig_inval.subjnodisp);
val_sig.PhysDisp    = makeValidTable(num_ch, num_trl.physdisp, sig_inval.physdisp);

end % function

function val_table = makeValidTable(num_ch, num_trl, inval_index)

% create valid table
a = true(num_trl, num_ch);
row_names = cell(1, num_trl);
for k = 1:num_trl
    row_names{k} = sprintf('T%d', k);
end % for
var_names = cell(1, num_ch);
for k = 1:num_ch
    var_names{k} = sprintf('C%d', k);
end % for

t = array2table(a, 'VariableNames', var_names, 'RowNames', row_names);

% set invalid indexes
if ~isempty(inval_index)
    num_inval_ch = size(inval_index, 1);
    for k = 1:num_inval_ch
        inval_k = inval_index(k, :);
        t.(inval_k{1})(inval_k{2})= false;
    end % for
end % if

val_table = t;

end % function

% [EOF]

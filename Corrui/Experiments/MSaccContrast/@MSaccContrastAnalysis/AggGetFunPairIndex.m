function result_dat = AggGetFunPairIndex(current_tag, sname, S, dat)
% AGGGETFUNPAIRINDEX Function between two indexes
% 
% Description:
%   This function gets numberically a function between two indexes of
%   neural activity, one from ms-triggered actvity and the other
%   step-contrast change.
%
% Syntax:
%   result_dat = AggGetFunPairIndex(current_tag, sname, S, dat)
% 
% Input(s):
%   sname       - session name
%
% Output(s):
%   result_dat  
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Tue 01/01/2013 12:57:27.484 PM
% $Revision: 0.2 $  $Date: Fri 01/04/2013  8:33:31.253 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters and options
% =========================================================================
if strcmpi(current_tag,'get_options')
    opt.index_type = { {'Spike rate' '{Spike rate difference}' 'Percentage change' 'Modulateion index'}, 'Index type' };
    opt.mt_feature = { '{P1}|T1|P2|S2', 'MS-triggered response feature' };
    opt.sc_feature = { 'P2|{S2}', 'Step-contrast response feature'};
    
    opt.mt_model = { {'{Linear polynomial curve}' 'Piecewise linear interpolation'}, 'MS-triggered response model' };
    opt.sc_model = { {'{Linear polynomial curve}' 'Piecewise linear interpolation'}, 'Step-contrast response model' };
    
    opt.mt_cont = { 0:10:100 'MT contrast levels' [0 100]};    % the input contrast levels for corresponding to step-contrast contrast change
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data needed for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { };
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% ----------------
% get the options
% ----------------
index_type = S.Stage_2_Options.AggGetFunPairIndex_options.index_type;
mt_feature = S.Stage_2_Options.AggGetFunPairIndex_options.mt_feature;
sc_feature = S.Stage_2_Options.AggGetFunPairIndex_options.sc_feature;

mt_cont  = S.Stage_2_Options.AggGetFunPairIndex_options.mt_cont;
mt_model = S.Stage_2_Options.AggGetFunPairIndex_options.mt_model;
sc_model = S.Stage_2_Options.AggGetFunPairIndex_options.sc_model;

% -----------------------------------
% get the funciton as ordered pairs
% -----------------------------------
mt_var = 0:10:100;
sc_var = -100:10:100;
% get input X and output Y observations
switch index_type
    case 'Spike rate'
        index_names = {'SpikeRate', 'SpikeRateContDiff'};
        [mt_obs, sc_obs] = getPairObs(index_names, mt_feature, sc_feature, sname);
        
    case 'Spike rate difference'
        index_names = {'SRDiff', 'SRDiffContDiff'};
        [mt_obs, sc_obs] = getPairObs(index_names, mt_feature, sc_feature, sname);
        
    case 'Percentage change'
        index_names = {'PerChange', 'PerChangeContDiff'};
        [mt_obs, sc_obs] = getPairObs(index_names, mt_feature, sc_feature, sname);
        
    case 'Modulateion index'
        index_names = {'ModuIndex', 'ModuIndexContDiff'};
        [mt_obs, sc_obs] = getPairObs(index_names, mt_feature, sc_feature, sname);
        
end % switch

% get ordered pairs
[sc_op, sc_op_mean, sc_op_sem] = function_paired_obs(mt_cont, mt_var, mt_obs, mt_model, sc_var, sc_obs, sc_model);

% figure check
% -------------
figure
errorbar(mt_cont, sc_op_mean, sc_op_sem, '-o')
xlabel('Contrast of MT-triggered response (%)')
ylabel('Contrast change of step-contrast response (%)')

% =========================================================================
% commit results
% =========================================================================
result_dat.OrderedPairs.Inputs = mt_cont;
result_dat.OrderedPairs.Outputs.Cells = sc_op;
result_dat.OrderedPairs.Outputs.Mean = sc_op_mean;
result_dat.OrderedPairs.Outputs.SEM = sc_op_sem;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================
function [x_obs, y_obs] = getPairObs(index_names, mt_feature, sc_feature, sname)
% get pair observations
% 
% Inputs:
%   index_names - string of index names: {1} = name for mt; {2} = name for sc
%   sname       - session name


% mt-triggered - X observations
switch mt_feature
    case 'P1'
        dat_var = {'MTP1Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        x_obs = (dat.MTP1Index.(index_names{1}).Cells)';   % cells x contrast
        
    case 'T1'
        dat_var = {'MTT1Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        x_obs = (dat.MTT1Index.(index_names{1}).Cells)';   % cells x contrast
        
    case 'P2'
        dat_var = {'MTP2Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        x_obs = (dat.MTP2Index.(index_names).Cells)';   % cells x contrast
        
    case 'S2'
        dat_var = {'MTS2Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        x_obs = (dat.MTS2Index.(index_names{1}).Cells)';   % cells x contrast
        
end % switch

% step-contrast - Y observations
switch sc_feature
    case 'P1'
        dat_var = {'SCP1Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        y_obs = dat.SCP1Index.(index_names{2}).Cells;   % cells x contrast change
        
    case 'S2'
        dat_var = {'SCS2Index'};
        dat = CorruiDB.Getsessvars(sname,dat_var);
        y_obs = dat.SCS2Index.(index_names{2}).Cells;   % cells x contrast change
        
end % switch

end % funciton

% [EOF]

function [mn se] = AggAssembleResponseSortedTrials( curr_exp, sessionlist, S)
% AGGASSEMBLERESPONSESORTEDTRIALS aggregates spike and microsaccades trials
%       according to sorted response of contrast
%
% Syntax:
%   [mn se] = AggAssembleResponseSortedUSaccYN( curr_exp, sessionlist, S)
% 
% Input(s):
%
% Output(s):
%   mn      - store
%   se      - not store
% 
% Example:
%
% See also StepContrastResponseSorting.m.

% Copyright 2012 Richard J. Cui. Created: Sun 06/24/2012  4:03:54.916 PM
% $Revision: 0.2 $  $Date: Sun 06/24/2012  4:03:54.916 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% options
if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            % 
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            % opt.Use_stage_1_data_if_contrast_one_is_zero = {{'{0', '1'}};
            mn = { {'{0}', '1'} };
            
            return
    end
end

% =======
% main
% =======

% number of sessions
numSess = length(sessionlist);  % number of sessions

% get in the variables
vars = {'StepContrastResponseSorting', 'SpikeRate', 'SpikeYN', 'SpikeRateWinCenter', ...
        'UsaccYN', 'UsaccRate', 'UsaccRateWinCenter'};

% aggreate
% =======================================================
% Spike rate and microsaccade rate
% =======================================================
grattime = 1300;

least_rep_spkrate = [];
most_rep_spkrate = [];

least_rep_spkyn = [];
most_rep_spkyn = [];

least_rep_usrate = [];
most_rep_usrate = [];

least_rep_usyn = [];
most_rep_usyn = [];

for k = 1:numSess
    data = CorruiDB.Getsessvars(sessionlist{k}, vars);
    
    NumCondition = data.StepContrastResponseSorting.NumCondition;   % the condition number
    stage12numcond = data.StepContrastResponseSorting.Stage12NumCondition;
    
    leastcyc_k = data.StepContrastResponseSorting.LeastResponseCycles;
    stage12leastcyc_k = data.StepContrastResponseSorting.Stage12LeastResponseCycles;
    
    mostcyc_k = data.StepContrastResponseSorting.MostResponseCycles;
    stage12mostcyc_k = data.StepContrastResponseSorting.Stage12MostresponseCycles;
    
    % spike rate
    % -----------
    spkrate_m = data.SpikeRate(:, :, NumCondition);
    least_rep_spkrate = cat(1, least_rep_spkrate, spkrate_m(leastcyc_k, :));
    most_rep_spkrate = cat(1, most_rep_spkrate, spkrate_m(mostcyc_k, :));
    
    % add stage1,2 data if necessary
    if ~isempty(stage12numcond)
        winc = data.SpikeRateWinCenter;
        shiftnum = sum(winc >= 0 & winc <= grattime);
        for m = 1:length(stage12numcond)
            numcond = stage12numcond(m);
            spkrate_m = data.SpikeRate(:, :, numcond);
            
            spkrate12_m = circshift(spkrate_m, [0 shiftnum]);   % shift stage 1, 2 to stage 2, 3
            leastcyc12_m = stage12leastcyc_k{m};
            mostcyc12_m = stage12mostcyc_k{m};
            least_rep_spkrate = cat(1, least_rep_spkrate, spkrate12_m(leastcyc12_m, :));
            most_rep_spkrate = cat(1, most_rep_spkrate, spkrate12_m(mostcyc12_m, :));
            
        end % for
        
    end % if
    
    % spike yn
    % ---------
    spkyn_k = data.SpikeYN(:, :, NumCondition);
    least_rep_spkyn = cat(1, least_rep_spkyn, spkyn_k(leastcyc_k, :));
    most_rep_spkyn = cat(1, most_rep_spkyn, spkyn_k(mostcyc_k, :));

    % add stage1,2 data if necessary
    if ~isempty(stage12numcond)
        
        for m = 1:length(stage12numcond)
            
            numcond = stage12numcond(m);
            spkyn_m = data.SpikeYN(:, :, numcond);
            
            spkyn12_m = circshift(spkyn_m, [0 grattime]);   % shift stage 1, 2 to stage 2, 3
            leastcyc12_m = stage12leastcyc_k{m};
            mostcyc12_m = stage12mostcyc_k{m};
            least_rep_spkyn = cat(1, least_rep_spkyn, spkyn12_m(leastcyc12_m, :));
            most_rep_spkyn = cat(1, most_rep_spkyn, spkyn12_m(mostcyc12_m, :));
            
        end % for
        
    end % if
    
    
    % usacc rate
    % ----------
    usrate_k = data.UsaccRate(:,:,NumCondition);
    least_rep_usrate = cat(1, least_rep_usrate, usrate_k(leastcyc_k, :));
    most_rep_usrate = cat(1, most_rep_usrate , usrate_k(mostcyc_k, :));
    
    % add stage1,2 data if necessary
    if ~isempty(stage12numcond)
        winc = data.UsaccRateWinCenter;
        shiftnum = sum(winc > 0 & winc <= grattime);
        for m = 1:length(stage12numcond)
            
            numcond = stage12numcond(m);
            usrate_m = data.UsaccRate(:, :, numcond);
            
            usrate12_m = circshift(usrate_m, [0 shiftnum]);   % shift stage 1, 2 to stage 2, 3
            leastcyc12_m = stage12leastcyc_k{m};
            mostcyc12_m = stage12mostcyc_k{m};
            least_rep_usrate = cat(1, least_rep_usrate, usrate12_m(leastcyc12_m, :));
            most_rep_usrate = cat(1, most_rep_usrate, usrate12_m(mostcyc12_m, :));
            
        end % for
        
    end % if
    
    
    % usacc YN
    % --------
    usyn_k = data.UsaccYN(:, :, NumCondition);
    least_rep_usyn = cat(1, least_rep_usyn, usyn_k(leastcyc_k, :));
    most_rep_usyn = cat(1, most_rep_usyn, usyn_k(mostcyc_k, :));
    
    % add stage1,2 data if necessary
    if ~isempty(stage12numcond)
        
        for m = 1:length(stage12numcond)
            
            numcond = stage12numcond(m);
            usyn_m = data.UsaccYN(:, :, numcond);
            
            usyn12_m = circshift(usyn_m, [0 grattime]);   % shift stage 1, 2 to stage 2, 3
            leastcyc12_m = stage12leastcyc_k{m};
            mostcyc12_m = stage12mostcyc_k{m};
            least_rep_usyn = cat(1, least_rep_usyn, usyn12_m(leastcyc12_m, :));
            most_rep_usyn = cat(1, most_rep_usyn, usyn12_m(mostcyc12_m, :));
            
        end % for
        
    end % if

end % for

% =======================================================
% SpikeRateWinCenter and UsaccRateWinCenter 
% =======================================================
data = CorruiDB.Getsessvars(sessionlist{1}, vars);
spkcen = data.SpikeRateWinCenter;
uscen = data.UsaccRateWinCenter;

% =======================================================
% commit results
% =======================================================
mn.SpikeYNMostResponseTrials = most_rep_spkyn;
mn.SpikeYNLeastResponseTrials = least_rep_spkyn;

mn.SpikeRateMostResponseTrials = most_rep_spkrate;
mn.SpikeRateLeastResponseTrials = least_rep_spkrate;

mn.UsaccYNMostResponseTrials = most_rep_usyn;
mn.UsaccYNLeastResponseTrials = least_rep_usyn;

mn.UsaccRateMostResponseTrials = most_rep_usrate;
mn.UsaccRateLeastResponseTrials = least_rep_usrate;

mn.SpikeRateWinCenter = spkcen;
mn.UsaccRateWinCenter = uscen;

se = [];

end % function MSaccStat

% =========================
% subroutines
% =========================

% [EOF]

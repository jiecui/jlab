function [mn, se] = Average( curr_exp, sessionlist, S)
% EXPERIMENTAGGREGATE.AVERAGE takes a list of variables, extracts the data from the open db,
%       averages  and finds standard dev (error?) and returns structs with those,
%       that could be fed back into the db as a new experiment
%
% Syntax:
%   [mn se] = Average( curr_exp, sessionlist, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: 10/24/2012  9:02:16.877 AM
% $Revision: 0.3 $  $Date: Wed 04/08/2020  7:08:17.484 AM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            variables_agg = ExperimentAggregate.get_variable_list( curr_exp, 'Average' );
            
            mn.select = { {'{0}', '1'} };
            options = [];
            for i=1:length( variables_agg )
                options.(variables_agg{i}) = { {'0', '{1}'} };
            end
            mn.options = options;
            
            if isempty(options)
                mn = { {'{0}', '1'} };
            end % if
            return
    end
end

% get the list of variables to average
varlist = Experiment.get_variable_list( curr_exp, 'Average', S.Average.options, S.Filters_To_Use );

new_session_name    = S.Name_of_New_Aggregated_Session;
win_back_all        = curr_exp.db.getvar('window_backward', sessionlist);
win_forwrd_all      = curr_exp.db.getvar('window_forward', sessionlist);
samplerate_all      = curr_exp.db.getvar('samplerate', sessionlist);

mn = [];
se = [];
window_backward = [];
window_forward	= [];
raw_dat = [];

%             varsDontAddToRawDat = {'fixHeatMapFVBlank', 'fixHeatMapFVNat', 'fixHeatMapFVPuz', 'fixHeatMapFVWal' };


% Data indepenednt of the eye
for i=1:length(varlist)
    try
        % get an array with the data for all the sessions and the window offests, backward and forward
        [arr, wb, wf] = curr_exp.db.makearray( sessionlist, varlist{i}, win_back_all, win_forwrd_all, samplerate_all );
        if ( isempty( arr) )
            continue;
        else
            if ~( isempty(wb) )
                window_backward.(varlist{i})	= wb;
                window_forward.(varlist{i})	= wf;
            end
        end
        
        %this will make it so any n-d array can be averaged
        dimToAvg = length(size(arr)) ;
        if ( size(arr, dimToAvg) > 0 )
            disp([varlist{i} ', num=' num2str(size(arr, dimToAvg))]);
        end
        
        if ( ~isempty(arr) )
            mn.([varlist{i}]) = nanmean(arr, dimToAvg);
            se.([varlist{i} ]) = nanstd(arr, [], dimToAvg) ./ sqrt(sum(~isnan(arr), dimToAvg));
            if ~(length(size(arr)) >= 3)
                raw_dat.raw.(varlist{i}) = arr;
            end
            curr_exp.db.add( [curr_exp.prefix 'mn' new_session_name], mn );
            curr_exp.db.add( [curr_exp.prefix 'se' new_session_name], se );
        end
        
        
        mn = [];
        se = [];
    catch ex
        fprintf('\n\nCORRUI ERROR AGGREGATING :: experiment -> %s, variable -> %s\n\n', class(curr_exp), varlist{i} );
        ex.getReport()
    end
end

dat.samplerate =  curr_exp.db.getsessvar(sessionlist{1}, 'samplerate');
curr_exp.db.updateStruct( [curr_exp.prefix 'mn' new_session_name], 'raw', raw_dat )
curr_exp.db.updateStruct( [curr_exp.prefix 'mn' new_session_name], 'window_backward', window_backward )
curr_exp.db.updateStruct( [curr_exp.prefix 'mn' new_session_name], 'window_forward', window_forward )
curr_exp.db.add( [curr_exp.prefix 'mn' new_session_name], dat );

end % function Average

% [EOF]

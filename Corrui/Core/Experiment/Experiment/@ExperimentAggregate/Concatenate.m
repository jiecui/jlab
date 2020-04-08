function [mn, se] = Concatenate(  curr_exp, sessionlist, S )
% CONCATENATE Conectanate vars across sessions when aggregating sessions
%
% Syntax:
%   [mn se] = Concatenate(  curr_exp, sessionlist, S )
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: 10/24/2012  9:09:33.593 AM
% $Revision: 0.5 $  $Date: Wed 04/08/2020  7:08:17.484 AM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            variables_agg = ExperimentAggregate.get_variable_list( curr_exp, 'Concatenate' );
            
            mn.select = { {'{0}', '1'}, 'Select variables' };
            options = [];
            for i=1:length( variables_agg )
                options.(variables_agg{i}) = { {'0', '{1}'} };
            end
            mn.options = options;
            
            if isempty(options)
                mn = { {'{0}', '1'}, 'Concatenate variables' };
            end % if
            return
    end
end

% get the list of variables to concatenate
concat_varlist = ExperimentAggregate.get_variable_list( curr_exp, 'Concatenate', S.Concatenate.options, S.Filters_To_Use );

% new_session_name    = S.Name_of_New_Aggregated_Session;
concatenated_vars = [];

% Data that should be concatenated
dat = [];
for i=1:length(concat_varlist)
    try
        
        vars = curr_exp.db.getvar(concat_varlist{i}, sessionlist);
        if ~isempty(vars)
            fnames = fieldnames( vars );
        else
            continue
        end
        total_data = [];
        sessionflag = [];
        for j=1:length(fnames)
            col = vars.(fnames{j});
            
            if isempty(col)
                continue
            end
            
            
            if ( ~isempty(total_data) )
                if ( isstruct( col ) )
                    % total_data{end+1} = col;
                    total_data = cat(2, total_data, col);
                    col_sessionflag = j * ones(size(col, 1), 1);
                    sessionflag(end+1:end+size(col, 1), :) = col_sessionflag;
                    
                % elseif length(size(col)) > 2
                %     total_data = cat(length(size(col)) + 1, total_data, col);
                %     col_sessionflag = j ;
                %     sessionflag(end+1, :) = col_sessionflag;
                else
                    % total_data(end+1:end+size(col, 1), :) = col;
                    total_data = cat(1, total_data, col);   
                    col_sessionflag = j * ones(size(col, 1), 1);
                    sessionflag(end+1:end+size(col, 1), :) = col_sessionflag;
                end
                
                
            else
                if ( isstruct( col ) )
                    total_data = {col};
                    col_sessionflag = j * ones(size(col, 1), 1);
                % elseif length(size(col)) > 2
                %     total_data = col;
                %     col_sessionflag = j ;
                else
                    total_data = col;
                    col_sessionflag = j * ones(size(col, 1), 1);
                end
                sessionflag = col_sessionflag;
            end
            
        end
        if strcmp(concat_varlist{i}, 'info')
            dat.info.session = total_data;
        else
            dat.( concat_varlist{i} ) = total_data;
        end % if
        concatenated_vars.( [ concat_varlist{i} ] ).sessionflag = sessionflag;
    catch ex
        fprintf('\n\nCORRUI ERROR AGGREGATING :: experiment -> %s, variable -> %s\n\n', class(curr_exp), concat_varlist{i} );
        ex.getReport()
    end
    
end

% curr_exp.db.updateStruct( [curr_exp.prefix 'mn' new_session_name], 'concatenated_vars', concatenated_vars );
dat.concatenated_vars = concatenated_vars;
mn = dat;
se = [];

end % function Concatenate

% [EOF]

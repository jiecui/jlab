function [mn, se] = Copy( curr_exp, sessionlist, S )
% EXPERIMENTAGGREGATE.COPY (summary)
%
% Syntax:
%   [mn se] = Copy( curr_exp, sessionlist, S )
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2020 Richard J. Cui. Created: 10/24/2012  9:18:56.073 AM
% $Revision: 0.4 $  $Date: Wed 04/08/2020  7:08:17.484 AM $
%
% Multimodel Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            variables_agg = ExperimentAggregate.get_variable_list( curr_exp, 'Copy' );
            
            mn.select = { {'{0}', '1'}, 'Select variables' };
            options = [];
            for i=1:length( variables_agg )
                options.(variables_agg{i}) = { {'0', '{1}'} };
            end
            mn.options = options;
            
            if isempty(options)
                mn = { {'{0}', '1'}, 'Copy variables' };
            end % if
            return
    end
end
% get the list of variables to copy
copy_varlist = ExperimentAggregate.get_variable_list( curr_exp, 'Copy', S.Copy.options, S.Filters_To_Use );

dat = [];

% Data that should be copied
for i=1:length(copy_varlist)
    try
        v	= curr_exp.db.getvar(copy_varlist{i}, sessionlist);
        
        if ( ~isempty( v ) )
            % Remove sessions that are not being averaged
            % vars	= rmfield( v, setdiff( fieldnames(v), sessionlist ) );
            v	= rmfield( v, setdiff( fieldnames(v), sessionlist ) );
        end
        if ( isempty(v) )
            continue
        end
        fnames = fieldnames( v );
        
        dat.( [ copy_varlist{i} ] ) = v.(fnames{1}); % just use the first one
    catch ex
        fprintf('\n\nCORRUI ERROR AGGREGATING :: experiment -> %s, variable -> %s\n\n', class(curr_exp), copy_varlist{i} );
        ex.getReport()
    end
end
mn = dat;
se = [];

end % function Copy

% [EOF]

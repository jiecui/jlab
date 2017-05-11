function [mn se] = Add(  curr_exp, sessionlist, S)
% ADD (summary)
%
% Syntax:
%   [mn se] = Add(  curr_exp, sessionlist, S)
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012-2014 Richard J. Cui. Created: 10/24/2012  9:14:22.560 AM
% $Revision: 0.2 $  $Date: Thu 11/27/2014 11:15:15.966 AM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            variables_agg = Aggregate.get_variable_list( curr_exp, 'Add' );
            
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

add_varlist = Aggregate.get_variable_list( curr_exp, 'Add', S.Add.options, S.Filters_To_Use );

dat = [];

for i=1:length(add_varlist)
    try
        
        vars = curr_exp.db.getvar(add_varlist{i}, sessionlist);
        
        if ( isempty(vars) )
            continue
        end
        fnames = fieldnames( vars );
        
        total_data = 0;
        for j=1:length(fnames)
            col = vars.(fnames{j});
            total_data = total_data + col;
        end
        dat.( [ add_varlist{i} ] ) = total_data;
        
    catch ex
        fprintf('\n\nCORRUI ERROR AGGREGATING :: experiment -> %s, variable -> %s\n\n', class(curr_exp), add_varlist{i} );
        ex.getReport()
    end
end
mn = dat;
se = [];

end % function Add

% [EOF]

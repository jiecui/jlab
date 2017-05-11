function out = filter_conditions( varargin )
% CORRGUI.FILTER_CONDITIONS select trial categories
%
% Syntax:
%   trial_list   = filter_conditions( current_tag, trial_conditions, filter, enum, sname)
%   filter_list  = filter_conditions( 'get_condition_names', current_tag)
%   dlg_struct   = filter_conditions( 'get_plot_options', current_tag )
%   filter_list  = filter_conditions( 'get_filters_to_use_from_dlg', current_tag, plot_options )
%   filter_list  = filter_conditions( 'get_filters_to_use_from_names', current_tag, names )
%
% Input(s):
%   current_tag         - tag of current experiment
%   trial_conditions    - vector of conditions numbers to be filtered
%   filter              - index of the filter to be used (cf. curr_exp.filter_conditions)
%   enum                - index of columns of data
%   sname               - session name
%   command: get_ondition_names     - lists the possible filters
%            get_plot_options       - builds a structDlg structure
%            get_filters_to_use_from_dlg    - process the structdlg
%                                             structure 'plot_options' to
%                                             get filter_list
%            get_filters_to_use_from_names  - get filter_list from 'names'
%
% Output(s):
%   trial_list          - list of indices of selected trials from 'trial_conditions'
%   dlg_struct          - struct used for StructDlg to get filter names
%   filter_list         - list of filters of trial conditions
%
% Example:
%
% Note:
%   Filters of trial conditions are constructed in
%   curr_exp.filter_condition().
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 08/06/2016  1:51:37.063 PM
% $Revision: 0.2 $  $Date: Mon 09/12/2016  8:52:50.422 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

try
    if ( nargin >= 4 )
        if ( ischar( varargin{1} ) )
            % if the input is a tag and not an object we create the
            % object
            current_tag = varargin{1};
            curr_exp = CorrGui.ExperimentConstructor(current_tag);
        else
            curr_exp = varargin{1};
        end
        trialconditions = varargin{2};
        filter = varargin{3};
        enum = varargin{4};
        sname = varargin{5};
        
        %                     % condition numbers are always > 0 if the list of
        %                     % trialconditions has zeros on it we removed them before
        %                     % calling the experiment filter_conditions (?)
        %                     idx = 1:length(trialconditions);
        %                     original_idx = idx(trialconditions>0);
        %                     trialconditions = trialconditions(trialconditions>0);
        
        % convert from name to number if necessary
        if ( ischar(filter) )
            filter_names = curr_exp.filters;
            filternumber = 0;
            for i=1:length(filter_names)
                if ( strcmp(filter_names{i},filter))
                    filternumber = i;
                    break
                end
            end
            filter = filternumber;
        end
        
        % filter the conditions
        [trial_list] = curr_exp.filter_conditions( trialconditions, filter, enum, sname);
        
        %                     % we need to get the original indices just in case there
        %                     % were zeros(?)
        %                     trial_list = original_idx(trial_list);
        %
        out = trial_list;
        
    else
        
        if ( ischar( varargin{2} ) )
            % if the input is a tag and not an object we create the
            % object
            current_tag = varargin{2};
            curr_exp = eval(strrep(current_tag,'_Avg',''));
        else
            curr_exp = varargin{2};
        end
        command = varargin{1};
        filter_names = curr_exp.filters;
        switch( command )
            case 'get_condition_names'
                out = filter_names;
                
            case 'get_plot_options'
                for i=1:length(filter_names)
                    if ( i==1 )
                        % the first option (ususally All) is always
                        % checked by default
                        plot_options.(filter_names{i})	= { {'0', '{1}' } };
                    else
                        plot_options.(filter_names{i})	= { {'{0}', '1' } };
                    end
                end
                
                out = plot_options;
                
            case 'get_filters_to_use_from_dlg'
                plot_options = varargin{3};
                filters_to_use = [];
                for i=1:length(filter_names)
                    if ( isfield(plot_options, filter_names{i} ) && plot_options.(filter_names{i}) )
                        % filters_to_use(end+1) = i;
                        filters_to_use = cat(2, filters_to_use, i);
                    end
                end
                out = filters_to_use;
            case 'get_filters_to_use_from_names'
                names = varargin{3};
                % filters_to_use = [];
                % for i=1:length(filter_names)
                %     if (~isempty(intersect(filter_names{i}, names)))
                %         filters_to_use = cat(2, filters_to_use, i);
                %     end
                % end
                out = find(strcmp(filter_names, names));
        end
    end
catch me
    msgbox( ['The experiment ' class(curr_exp) ' does not have a proper filter_conditions function']);
    me.rethrow()
end

end % function filter_conditions

% [EOF]

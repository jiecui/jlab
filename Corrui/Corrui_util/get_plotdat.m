%% == get_plotdat
function plotdat = get_plotdat( actual_plotdat, session_name, variable_names , which_eye,fields)
% plotdat = get_plotdat( actual_plotdat, session_name, variable_names , lrb)
%Fields is a cell with the fields of variable_names that you want. Each
%element in variable_names must have the same field when using this
%feature.
% Get a structure with one field per variable needed for the plot.
% If any field is present in actual_plot it will stay.
% the variable_names should be a cell array with the variable names that
% will be retreived from the DB.
% lrb (optional) is used to indicate the eye. 0 left 1 right 2 both 3
% concatenate 4 is data with no eye dependence

if isempty( variable_names )
    return
end

if ( exist( 'which_eye', 'var' ) )
    switch( which_eye)
        case 'Left'
            lrb = 0;
        case 'Right'
            lrb = 1;
        case 'Both'
            lrb = 2;
        case 'Concat'
            lrb = 3;
        case 'Unique'
            lrb = 4;
    end
end



if ischar(variable_names)
    variable_names = { variable_names };
end
j=1;
for ivar = 1:length(variable_names)
    
    variable_name = variable_names{ivar};
    
    % if the variable has already been retrieved
    if ( isfield( actual_plotdat, variable_name) && ~isempty( actual_plotdat.(variable_name) ) )
        continue
    end
    
    % Get the variable from the DB for left, right, of both eyes
    if exist('lrb','var') && ( lrb == 0 )&& ~exist('fields','var')
        % left eye
        actual_plotdat.(variable_name) = sessdb('getsessvar',session_name, ['left_' variable_name]);
    elseif exist('lrb','var') && ( lrb == 1 )&& ~exist('fields','var')
        % right eye
        actual_plotdat.(variable_name) = sessdb('getsessvar',session_name, ['right_' variable_name]);
    elseif exist('lrb','var') && ( lrb == 0 )&& exist('fields','var')&& ~isempty(fields)
        % left eye
        left	= sessdb('getsessvar',session_name, ['left_' variable_name] );
        fieldnames = fields{j};
        for i=1:length(fieldnames)
            if ~isempty(left.(fieldnames{i}))
                actual_plotdat.(variable_name).(fieldnames{i}) = left.(fieldnames{i});
            else
                actual_plotdat.(variable_name).(fieldnames{i}) = [];
            end
        end
        
    elseif exist('lrb','var') && ( lrb == 1 )&& exist('fields','var')&& ~isempty(fields)
        % right eye
        right	= sessdb('getsessvar',session_name, ['right_' variable_name] );
        fieldnames = fields{j};
        for i=1:length(fieldnames)
            if ~isempty(right.(fieldnames{i}))
                actual_plotdat.(variable_name).(fieldnames{i}) = right.(fieldnames{i});
            else
                actual_plotdat.(variable_name).(fieldnames{i}) = [];
            end
        end
        
    elseif exist('lrb','var') && ( lrb == 2 )&& ~exist('fields','var')
        % both eyes averaged
        left	= sessdb('getsessvar',session_name, ['left_' variable_name] );
        right	= sessdb('getsessvar',session_name, ['right_' variable_name] );
        if ( ~isstruct(left) )
            actual_plotdat.(variable_name) = mean( [left, right],2 );
        else
            actual_plotdat.(variable_name) = mean_struct( [left right] );
        end
    elseif exist('lrb','var') && ( lrb == 2 )&& exist('fields','var') && ~isempty(fields)
        % both eyes averaged
        left	= sessdb('getsessvar',session_name, ['left_' variable_name] );
        right	= sessdb('getsessvar',session_name, ['right_' variable_name] );
        if isempty(left)||isempty(right)
            continue;
        end
        fieldnames = fields{j};
        for i=1:length(fieldnames)
            if ~isempty(left.(fieldnames{i}))&&~isempty(right.(fieldnames{i}))
                actual_plotdat.(variable_name).(fieldnames{i}) = ...
                    mean(cat(3,left.(fieldnames{i}),right.(fieldnames{i})),3);
            else
                actual_plotdat.(variable_name).(fieldnames{i}) = [];
            end
        end
        
        
    elseif exist('lrb','var') && ( lrb == 3 )&& ~exist('fields','var')
        % both eyes concatenated
        left	= sessdb('getsessvar',session_name, ['left_' variable_name] );
        right	= sessdb('getsessvar',session_name, ['right_' variable_name] );
        if isempty(left)&& isempty(right)
            continue;
        end
        if ( size(left,2) == size(right,2) )
            actual_plotdat.(variable_name) = [left;right];
        else
            if ( isempty(left) )
                actual_plotdat.(variable_name) = [right];
            elseif (isempty(right) )
                actual_plotdat.(variable_name) = [left];
            else
                actual_plotdat.(variable_name) = [left';right'];
            end
        end
        
    elseif exist('lrb','var') && ( lrb == 3 )&& exist('fields','var')&& ~isempty(fields)
        % both eyes concatenated
        left  = sessdb('getsessvar',session_name,  ['left_' variable_name]);
        right = sessdb('getsessvar',session_name,  ['right_' variable_name]);
        if isempty(left)||isempty(right)
            continue;
        end
        fieldnames = fields{j};
        for i=1:length(fieldnames)
            
            if ( size(left.(fieldnames{i}),2) == size(right.(fieldnames{i}),2) )
                actual_plotdat.(variable_name).(fieldnames{i}) = [left.(fieldnames{i});right.(fieldnames{i})];
            elseif ~(isempty(right.(fieldnames{i})) )|| ~(isempty(left.(fieldnames{i})) )
                if ( isempty(left.(fieldnames{i})) )
                    actual_plotdat.(variable_name) = [right.(fieldnames{i})];
                elseif (isempty(right.(fieldnames{i})) )
                    actual_plotdat.(variable_name) = [left.(fieldnames{i})];
                else
                    actual_plotdat.(variable_name).(fieldnames{i}) = [left.(fieldnames{i})';right.(fieldnames{i})];
                end
            else
                actual_plotdat.(variable_name).(fieldnames{i}) = [];
            end
        end
        
    elseif exist('lrb','var') && ( lrb == 4 )&& exist('fields','var')&& ~isempty(fields)
        
        data	= sessdb('getsessvar',session_name,  variable_name );
        if isempty(data)
            continue;
        end
        fieldnames = fields{j};
        for i=1:length(fieldnames)
            actual_plotdat.(variable_name).(fieldnames{i}) = data.(fieldnames{i});
        end
        
    else
        actual_plotdat.(variable_name) = sessdb('getsessvar',session_name,  variable_name);
    end
    
    j=j+1;
    
end
plotdat = actual_plotdat;
















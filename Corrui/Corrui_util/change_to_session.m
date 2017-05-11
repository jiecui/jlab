function  dat_out = change_to_session(dat_in,sess_start_idx,sess_stop_idx)
% given a struct of variable this will change each variable to the data to
% a given session indicated by the sess_start/stop_idx. Any variable which
% is not a 2-D matrix with one length at least as long as sess_stop_idx is
% not changed

if isstruct(dat_in)
    field_names = fields(dat_in);
        
    for ifield = 1:length(field_names)
        changed = 0;
        d = size(dat_in.(field_names{ifield}));
        dims = sum(d >= 1);
        %if the var is not a 1 or 2 dimensional matrix
        if dims > 2 || max(d) <  sess_stop_idx || (~isnumeric(dat_in.(field_names{ifield})) && ~islogical(dat_in.(field_names{ifield})))
            dat_out.(field_names{ifield}) = dat_in.(field_names{ifield});
            continue
        end
        
        if d(1) < d(2)
            dat_in.(field_names{ifield}) = dat_in.(field_names{ifield})';
            changed = 1;
        end
        
        dat_out.(field_names{ifield}) = dat_in.(field_names{ifield})(sess_start_idx:sess_stop_idx,:);
        
        if changed
            dat_out.(field_names{ifield}) = dat_out.(field_names{ifield})';
        end
    end
elseif iscell(dat_in) %is a cell of matrices
    
    for i = 1:length(dat_in)
           
        changed = 0;
        d = size(dat_in{i});
        dims = sum(d >= 1);
        %if the var is not a 1 or 2 dimensional matrix
        if dims > 2 || max(d) <  sess_stop_idx || (~isnumeric(dat_in{i} && ~islogical(dat_in{i})))
            dat_out{i} = dat_in{i};
            return
        end
        
        if d(1) < d(2)
            dat_in{i} = dat_in{i}';
            changed = 1;
        end
        
        dat_out{i} = dat_in{i}(sess_start_idx:sess_stop_idx,:);
        
        if changed
            dat_out{i} = dat_out{i}';
        end
    
    end
    
else %is a single entry
    
     changed = 0;
        d = size(dat_in);
        dims = sum(d >= 1);
        %if the var is not a 1 or 2 dimensional matrix
        if dims > 2 || max(d) <  sess_stop_idx || (~isnumeric(dat_in && ~islogical(dat_in)))
            dat_out = dat_in;
            return
        end
        
        if d(1) < d(2)
            dat_in = dat_in';
            changed = 1;
        end
        
        dat_out = dat_in(sess_start_idx:sess_stop_idx,:);
        
        if changed
            dat_out = dat_out';
        end
    
    
end
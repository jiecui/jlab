function  dat_out = change_sessions_to_experiment(dat_in)

field_names = fields(dat_in);

for ifield = 1:length(field_names)
    
    if ~iscell(dat_in.(field_names{ifield})) || length(dat_in.(field_names{ifield})) < 2
       if iscell(dat_in.(field_names{ifield}))
           dat_out.(field_names{ifield}) = dat_in.(field_names{ifield}){1};
       else
           dat_out.(field_names{ifield}) = dat_in.(field_names{ifield});
       end
        continue
    end
    
    d1 = size(dat_in.(field_names{ifield}){1});
    d2 = size(dat_in.(field_names{ifield}){2});
    
    diff_dim_idx = find(d1 ~= d2,1);
    
    if isempty(diff_dim_idx)
        diff_dim_idx = 1;
    end
    
    dat_out.(field_names{ifield}) = cat(diff_dim_idx,dat_in.(field_names{ifield}){:});
    
end
function name = get_enumprop_varname(name)
if ~iscell(name)
    name = deunderscore(name);
if any(strcmpi( name,{'magnitude','magnitudes','mag'}))
    name = 'magnitude';
elseif any(strcmpi(name,{'on','start'}))
    name = 'start_index';
elseif any(strcmpi(name,{'off','stop'}))
    name = 'end_index';
elseif any(strcmpi(name,{'dur','durations','duration'}))
    name = 'duration';
elseif any(strcmpi(name,{'peak velocity' 'pk vel','pkvel'}))
    name = 'pkvel';
elseif any(strcmpi(name,{'mean velocity','mn_vel','mnvel','mean_vel'}))
    name = 'mnvel';
elseif any(strcmpi(name,{'dir','direction'}))
    name = 'direction';
elseif  any(strcmpi(name,{'distance', 'dist',}))
    name = 'dist';
elseif  any(strcmpi(name,{'displacement','displacmt' 'dsplmt'}))
    name = 'dsplmt';
elseif  any(strcmpi(name,{'avg speed','average speed'}))
    name = 'mnvel';
elseif  any(strcmpi(name,{'displacement over time', 'dsplmt ovr t'}))
    name = 'dsplmt_ovr_t';
elseif any(strcmpi(name,{'max spread x'}))
    name = 'max_spread_x';
elseif any(strcmpi(name,{'max spread y'}))
    name = 'max_spread_y';
elseif any(strcmpi(name,{'instant speed'}))
    name = 'instspeed';
end
else
    
    for i = 1:length(name)
        name{i} = get_enumprop_varname(name{i});
    end

end



function name = get_short_variable_name(name)
name = deunderscore(lower(name));
if any(strcmpi( name,{'microsaccade','usaccade','usacc'}))
    name = 'usacc';
elseif any(strcmpi(name,{'saccade','sacc'}))
    name = 'sacc';
elseif any(strcmpi(name,{'press','presses','pr'}))
    name = 'pr';
elseif any(strcmpi(name,{'re','release','releases'}))
    name = 're';
elseif any(strcmpi(name,{'blink'}))
    name = 'blink';
elseif any(strcmpi(name,{'all'}))
    name = 'all';
elseif any(strcmpi(name,{'drift'}))
    name = 'drift';
elseif  any(strcmpi(name,{'Number of Events In Bin'}))
    name = 'num_events';
elseif  any(strcmpi(name,{'Sum of Magnitude of Events in Bin'}))
    name = 'mag';
elseif  any(strcmpi(name,{'Average Magnitude of Events in Bin'}))
    name = 'mag_avg';
elseif  any(strcmpi(name,{'Probability of Event Above Threshold in Bin'}))
    name = 'prob_above_thresh';
elseif any(strcmpi(name,{'drift alone in peak'}))
    name = 'drift_noevt';
elseif any(strcmpi(name,{'mean' 'mn'}))
    name = 'mean';
elseif any(strcmpi(name,{'mean max'}))
    name = 'mean_max';
elseif any(strcmpi(name,{'std err' 'standard error'}))
    name = 'std_err';
elseif any(strcmpi(name,{'std dev' 'standard deviation'}))
    name = 'std_dev';
elseif any(strcmpi(name,{'randusacc' 'random microsaccade'}))
    name = 'randusacc';
elseif any(strcmpi(name,{'moved microsaccade' }))
    name = 'usacc_mov';
elseif any(strcmpi(name,{'after random microsaccade' 'after random usacc'}))
    name = 'afterrandusacc';
elseif any(strcmpi(name,{'after microsaccade' 'after usacc'}))
    name = 'afterusacc';
elseif any(strcmpi( name,{'microsaccade saccade','usacc sacc'}))
    name = 'sacc_usacc';
elseif any(strcmpi( name,{'blink saccade','blink sacc'}))
    name = 'blink_sacc';
elseif any(strcmpi( name,{'blink_microsaccade','blink_usacc'}))
    name = 'blink_usacc';
elseif any(strcmpi( name,{'blink_saccade_microsaccade','blink_sacc_usacc'}))
    name = 'blink_sacc_usacc';
elseif any(strcmpi( name,{'microsaccade rate','usaccade rate','usacc rate'}))
    name = 'usacc_rate';
elseif any(strcmpi(name,{'saccade rate','sacc rate'}))
    name = 'sacc_rate';
elseif any(strcmpi(name,{'all rate','all rate'}))
    name = 'all_rate';
elseif any(strcmpi( name,{'microsaccade saccade rate','usacc sacc rate'}))
    name = 'sacc_usacc_rate';
elseif any(strcmpi( name,{'blink saccade','blink sacc'}))
    name = 'blink_sacc_rate';
elseif any(strcmpi( name,{'blink microsaccade','blink usacc'}))
    name = 'blink_usacc_rate';
elseif any(strcmpi( name,{'blink saccade microsaccade','blink sacc usacc'}))
end



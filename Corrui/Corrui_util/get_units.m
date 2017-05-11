
function units = get_units(movement_type,prop)
switch deunderscore(lower(movement_type))
    case {'usacc' 'sacc'}
        switch prop
            case {'mag' 'magnitude' 'magnitudes'}
                units = 'deg';
            case {'dur' 'durations' 'duration'}
                units = 'ms';
            case {'pkvel' 'peak velocity' 'pk vel' 'peak vel'}
                units = 'deg/s';
            case {'mean vel' 'mnvel' 'mean velocity'}
                units = 'deg/s';
            case {'dead t' 'dead time'} 
                units = 'ms';
            case 'on'
                units = 'onset time';
            otherwise
                units = '';
        end
        
    case 'drift'
        switch prop
            case {'dist' 'distance'}
                units = 'deg';
            case {'displacmt' 'displacement' 'dsplmt'}
                units = 'deg';
            case {'duration' 'dur'}
                units = 'sec';
            case {'avg speed' 'average speed' 'mnvel' 'pkvel'}
                units = 'deg/s';
            case {'displacmt over time' 'displacement over time'}
                units = 'deg/s';
            case {'instant_speed' 'instspeed'}
                units = 'deg/s';
            case {'max spread horiz' 'max spread x'}
                units = 'deg';
            case {'max spread vert' 'max spread y'}
                units = 'deg';
            case {'max spread'}
                units = 'deg';
            case {'accel' 'acceleration'}
                units = 'deg/s^2';
            case {'eng' 'engbert'}
                units = 'boxes';
            otherwise
                units = '';
        end
        
    otherwise units = '';
end
end

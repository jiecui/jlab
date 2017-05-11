function  [session_start,session_end] = get_session_start_stop_idx( name)

session_start = sessdb('getsessvar',name,'session_start');
session_end = sessdb('getsessvar',name,'session_end');

if isempty(session_start)
    info = sessdb('getsessvar',name,'info');
    edf_samples = sessdb('getsessvar',name,'edf_samples');
    timestamps = edf_samples(:,1);
    
    if isempty(info)
        session_start(1) = 1;
        session_end(1) = length(edf_samples(:,1)) - 1;
        return
    end
    
    file_timestamps = info.import.file_timestamps;
    
    for i=1:length(file_timestamps(:,1))
        session_start(i) = find(file_timestamps(i,1) == timestamps);
        session_end(i) = find(file_timestamps(i,2) == timestamps);        
    end
    session_end(end) = session_end(end) - 1;
end




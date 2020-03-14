function avg = correlate_data(data,events,window_ms)
% given a single column of the "standard" data matrix, with 1 ms resolution in the rows,
% calculate the correlation of the data with the events passed in
% profile on -detail 'builtin' -timer 'real' 
data(isnan(data))=0;
% data = full(data);
% now modify data so that all indices of a "string" equal the last index of that "string"
% string_onoff = zeros(length(data),1);
% string_onoff(find(data)) = 1;
% string_begs = find(diff(string_onoff)>0);
% string_ends = find(diff(string_onoff)<0);
% for i=1:length(string_ends)
%     data(string_begs(i)+1:string_ends(i)) = data(string_ends(i));
% end
evt_idx = find(events);
sumdat = zeros(window_ms,1);
total_window = sumdat;
avg = sumdat;
li = length(evt_idx);
%li=min(li,200000);

for n=1:li
    n_ms = evt_idx(n);
    % I know here that the button press or whatever I am interested in) is
    % "on"
    dat_begin = max(n_ms-window_ms,0)+1;
    sum_begin = window_ms - (n_ms-dat_begin);
    to_add = data(dat_begin:n_ms);
    sumdat(sum_begin:window_ms) = sumdat(sum_begin:window_ms) + to_add;
    to_add(find(to_add)) = 1;
%     if ~isempty(find(to_add))
%         to_add
%     end
    total_window(sum_begin:window_ms) = total_window(sum_begin:window_ms) + 1;
end
nonzero=find(total_window);
avg(nonzero) = sumdat(nonzero)./total_window(nonzero);
% profile viewer
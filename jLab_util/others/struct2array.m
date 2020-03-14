function new_array = struct2array(stats_array,fname)

magsize = 0;
for s=stats_array
    magsize = magsize + length(s.(fname));
end

new_array = zeros(magsize,size(s.(fname),2));

curstart = 1;
for s=stats_array
    len = length(s.(fname));
    new_array(curstart:curstart+len-1,:) = s.(fname);
    curstart = curstart+len;
end
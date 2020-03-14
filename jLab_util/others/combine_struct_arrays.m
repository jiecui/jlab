function new_array = combine_struct_arrays(sarray1,sarray2,fname)


% make big x-y array to pass into histogram
magsize = 0;
for s=stats_array
    magsize = magsize + length(s.(fname));
end

new_array = zeros(magsize,size(s.(fname),2);
vels = mags;

curstart = 1;
for s=stats_array
    len = length(s.mag);
    new_array(curstart:curstart+len-1,:) = s.(fname);
    curstart = curstart+len;
end
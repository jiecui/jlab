function new_array = cat_struct_arrays(stats_array,fname)

magsize = 0;
for s=stats_array
    magsize = magsize + length(s.(fname));
end

if magsize == length(stats_array)
    new_array = 0;
else
    new_array = zeros(magsize,size(s.(fname),2));
end

curstart = 1;
for s=stats_array
    len = length(s.(fname));
    if len == 1
        % scalar, so we add
        new_array = new_array + s.(fname);
    else
        new_array(curstart:curstart+len-1,:) = s.(fname);
        curstart = curstart+len;
    end
end
function new_array = collapse_struct_arrays(new_array,sarray1,sarray2,fname)
for i=1:length(sarray1)
    if length(sarray1(i).(fname)) == 1
        new_array(i).(fname) = sarray1(i).(fname)+sarray2(i).(fname);
    else
        new_array(i).(fname) = [sarray1(i).(fname);sarray2(i).(fname)];
    end
end
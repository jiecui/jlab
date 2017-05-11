function newarray = merge_struct_arrays(arr1,arr2)
% function newarray = merge_struct_arrays(arr1,arr2)
% return new structure array, length arr1, element-wise vertical cat of 
% array members of arr1 and arr2, and sum of scalar members of arr1 and arr2.
newarray = arr1;
commonnames = intersect(fieldnames(arr1(1)),fieldnames(arr2(1)));
for fname=commonnames'
    fname = char(fname);
    for s=1:length(arr1)
        if isscalar(arr1(s).(fname))
            % scalar, so we add
            newarray(s).(fname) = arr1(s).(fname)+ arr2(s).(fname);
        else
            newarray(s).(fname) = [arr1(s).(fname);arr2(s).(fname)];
        end
    end
end
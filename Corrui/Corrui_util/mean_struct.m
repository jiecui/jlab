function result = mean_struct( data)

if ( ~isstruct(data(1)) )
    result = mean(data);
    return;
end

fields = fieldnames(data(1));

for i=1:length(fields)
    result.(fields{i}) = mean(struct2array(data,fields{i}));
end

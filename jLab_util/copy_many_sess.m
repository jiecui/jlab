sess=sessdb('listsess');

% sess_end_tags ={'II' 'III' 'IV' 'V' 'VI' 'VII' 'VIII' 'XI' 'X'};
sess_end_tags ={'II' 'III' 'IV' 'V' };

for i= 48:length(sess)
    
    for j = 1:length(sess_end_tags)
sessdb('copysess', sess{i}, [sess{i} sess_end_tags{j}])
    end

end
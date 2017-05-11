function YesNo = cut_ends_of_YesNo(YesNo,amount_to_cut,option)
% YesNo = cut_ends_of_YesNo(YesNo,amount_to_cut,[option])

if ~(amount_to_cut > 1)
    return
end

start = find(diff([0;YesNo]) > 0);
stop = find(diff([YesNo;0]) < 0);


if ~exist('option','var') || isempty(option)
    %cut both the beginning and ends of chunks of ones
    for i = 1:length(start)
        if stop(i) - start(i) > 2*amount_to_cut + 1
            YesNo(start(i):start(i) + amount_to_cut) = 0;
            YesNo(stop(i) - amount_to_cut:stop(i)) = 0;
        else
            YesNo(start(i):stop(i)) = 0;
        end
    end
    
else
    
    switch option
        
        case 'end'
            %cut the ends of chunks of ones
            for i = 1:length(start)
                if stop(i) - start(i) > amount_to_cut + 1
                    YesNo(stop(i) - amount_to_cut:stop(i)) = 0;
                else
                    YesNo(start(i):stop(i)) = 0;
                end
            end
            
        case 'beggining'
            %cut the beginning  of chunks of ones
            for i = 1:length(start)
                if stop(i) - start(i) > amount_to_cut + 1
                    YesNo(start(i):start(i) + amount_to_cut) = 0;
                else
                    YesNo(start(i):stop(i)) = 0;
                end
            end
    end
end


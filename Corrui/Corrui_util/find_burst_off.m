function burst_off=find_burst_off(usacc_on,burst_size,...
    burst_durations,dead_time,blinks,magnitude,magnitudes,trial_start,trial_end,samplerate,dead_times)
% function burst_off=find_burst_off(usacc_on,burst_size,...
%     burst_durations,dead_time,blinks,magnitude,magnitudes,trial_start,trial_end,samplerate,dead_times)
% return a list of the end of bursts of microsaccades of
%size burst_size which are not contained in bursts of a bigger size and which have a given
%dead_time before the beginning of the burst. burst_durations is the max burst duration (ms) for each burst size =
%1,...,6. Also require the magnitude of the burst = sum of all mag in burst
%to be some minimum value given by magnitude
% %INPUT
% usacc_on: 0-1 VECTOR OF USACC ONSETS
% burst_size: SIZE OF BURST (CAN BE 1- 6)
% burst_durations: TIME OF EACH BURST DURATION IN MS (FOR EACH BURST SIZE 1 - 6)
% dead_time: AMOUNT OF TIME WITH NO ACTIVITY BEFORE BURST
% blinks: 0-1 vector of blink onsets
% magnitude: 
% magnitudes:
% trial_start:
% trial_end:
% samplerate:
% dead_times:
% 
% %OUTPUT
% burst_off:

burst_off=zeros(length(usacc_on),1);

%indices of all usacc
AllIndices=find(usacc_on);

blink_free_per=0; %amount of time to look forward and backward to check for
%blink free period NOTE: this wont work now unless I add blink criteria

convFactor = 1000/samplerate;
dead_time = dead_time*samplerate/1000;


for n=1:length(trial_start)
    
    Indices=AllIndices(AllIndices >= trial_start(n) & AllIndices <= trial_end(n)); % Indices for trials
    
    if isempty(Indices)
        continue; %If no data, move to next trial
    end
    
    orig_num = length(Indices);
    
    if length(Indices)<11
        
        
        hh=ones(11-length(Indices),1)*Indices(length(Indices))+ max(burst_durations(:)) + 1; %make sure data is long enough
        %NOTE: This puts a microsaccade in the same place multiple times
        %but does not create phantom microsaccades in the data. Purely
        %here for technical reasons
        
        Indices=[Indices;hh];
        
        
    end
    k=1;
    while(k<=orig_num)
        if k==1 && (Indices(k)-trial_start(n))<dead_time
            k=k+1;
            continue;
        end
        if k>1 && (Indices(k)-Indices(k-1))<dead_time
            k=k+1;
            continue;
        end
        if dead_times(Indices(k)) < dead_time
            k=k+1;
            continue;
        end
        
        if k==1
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                k=k+1;
            end
        elseif k==2
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                k=k+1;
            end
        elseif k==3
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                k=k+1;
            end
        elseif k==4
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                k=k+1;
            end
        elseif k==5
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                
                k=k+1;
                
            end
        elseif k>5 && k<=orig_num-5
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k+5)-Indices(k))*convFactor > burst_durations(5)&&...% Not saccade 1 in burst of 6
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
            elseif burst_size==6&&...
                    (Indices(k+5)-Indices(k))*convFactor <= burst_durations(5) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+6;
            else
                k=k+1;
            end
        elseif k==orig_num-4
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k+4)-Indices(k))*convFactor > burst_durations(4)&&...% Not saccade 1 in burst of 5
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            elseif burst_size==5&&...
                    (Indices(k+4)-Indices(k))*convFactor <= burst_durations(4) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+4)-Indices(k-1))*convFactor > burst_durations(5)&&...% Not saccade 2 in burst of 6
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+5;
                
            else
                k=k+1;
            end
        elseif k==orig_num-3
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k+3)-Indices(k))*convFactor > burst_durations(3)&&...% Not saccade 1 in burst of 4
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
            elseif burst_size==4&&...
                    (Indices(k+3)-Indices(k))*convFactor <= burst_durations(3) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+3)-Indices(k-1))*convFactor > burst_durations(4)&&...% Not saccade 2 in burst of 5
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+3)-Indices(k-2))*convFactor > burst_durations(5)&&...% Not saccade 3 in burst of 6
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+4;
            else
                k=k+1;
            end
        elseif k==orig_num-2
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k+2)-Indices(k))*convFactor > burst_durations(2)&&...% Not saccade 1 in burst of 3
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
            elseif burst_size==3&&...
                    (Indices(k+2)-Indices(k))*convFactor <= burst_durations(2) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+2)-Indices(k-1))*convFactor > burst_durations(3)&&...% Not saccade 2 in burst of 4
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+2)-Indices(k-2))*convFactor > burst_durations(4) &&...% Not saccade 3 in burst of 5
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+2)-Indices(k-3))*convFactor > burst_durations(5)&&...% Not saccade 4 in burst of 6
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+3;
                
            else
                k=k+1;
                
            end
        elseif k==orig_num-1
            
            if  burst_size==1 && ...
                    (Indices(k+1)-Indices(k))*convFactor > burst_durations(1)&&...% Not saccade 1 in burst of 2
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            elseif burst_size==2&&...
                    (Indices(k+1)-Indices(k))*convFactor <= burst_durations(1) && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    (Indices(k+1)-Indices(k-1))*convFactor > burst_durations(2)&&...% Not saccade 2 in burst of 3
                    (Indices(k+1)-Indices(k-2))*convFactor > burst_durations(3)&&...% Not saccade 3 in burst of 4
                    (Indices(k+1)-Indices(k-3))*convFactor > burst_durations(4) &&...% Not saccade 4 in burst of 5
                    (Indices(k+1)-Indices(k-4))*convFactor > burst_durations(5)&&... % Not saccade 5 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+2;
                
            else
                k=k+1;
            end
            
        elseif k==orig_num
            if  burst_size==1 && ...
                    (Indices(k)-Indices(k-1))*convFactor > burst_durations(1) &&...% Not saccade 2 in burst of 2
                    (Indices(k)-Indices(k-2))*convFactor > burst_durations(2) &&...% Not saccade 3 in burst of 3
                    (Indices(k)-Indices(k-3))*convFactor > burst_durations(3)&&...% Not saccade 4 in burst of 4
                    (Indices(k)-Indices(k-4))*convFactor > burst_durations(4)&&...% Not saccade 5 in burst of 5
                    (Indices(k)-Indices(k-5))*convFactor > burst_durations(5)&&...% Not saccade 6 in burst of 6
                    sum(magnitudes(Indices(k):Indices(k)+burst_size-1))>=magnitude
                
                burst_off(Indices(k+burst_size-1))=1;
                k=k+1;
            else
                k=k+1;
            end
        end
    end
end
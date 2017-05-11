function dat = change_data_domain(dat,isInTrial)

 fieldnames = fields(dat);
 
 for i = 1:length(fieldnames)
     
     field = fieldnames{i};
     
     if any(size(dat.(field)) == length(isInTrial))
         
         whichone = find(size(dat.(field)) == length(isInTrial));
         
         if whichone == 1
             
             dat.(field) = dat.(field)(isInTrial,:); 
             
             
         else
              dat.(field) = dat.(field)(:,isInTrial); 
             
         end
         
  
         
     end
     
    
     
 end
 

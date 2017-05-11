
function[]  = ctx2txt(input_pathname,output_pathname)
tic;
trial=0;

i_fid = fopen(input_pathname, 'rb')
o_fid = fopen(output_pathname, 'wt')

fprintf(o_fid, 'Processing file %s\n\n', input_pathname);

hd=zeros(1,13);

while ( ~feof (i_fid))
   length     = fread(i_fid, 1, 'unsigned short');
      
   if (isempty(length)~=1)
      fprintf(o_fid, 'length = %d\n', length);
      % Number of bytes for each variable.
      hd(1,1:8)= (fread(i_fid, 8, 'unsigned short'))';
      % Convert bytes to number of float point values (4 bytes apiece in windows and FreeBSD).
      hd(1,5)=hd(1,5)/4;
      % Convert bytes to number of short values (2 bytes apiece in windows and FreeBSD).
      hd(1,6)=hd(1,6)/2;
      hd(1,7)=hd(1,7)/2;
      hd(1,8)=hd(1,8)/2;
      
      fprintf(o_fid, 'cond_no = %d\n', hd(1,1));
      fprintf(o_fid, 'repeat_no = %d\n', hd(1,2));
      fprintf(o_fid, 'block_no = %d\n', hd(1,3));
      fprintf(o_fid, 'trial_no = %d\n', hd(1,4));
      fprintf(o_fid, 'isi_size = %d\n', hd(1,5));
      fprintf(o_fid, 'code_size = %d\n', hd(1,6));
      fprintf(o_fid, 'eog_size = %d\n', hd(1,7));
      fprintf(o_fid, 'epp_size = %d\n', hd(1,8));

      
      hd(1,9:10) = (fread(i_fid, 2, 'unsigned char'))';
      
      fprintf(o_fid, 'kHz_resolution = %d\n', hd(1,9));
      fprintf(o_fid, 'eye_storage_rate = %d\n', hd(1,10));

      hd(1,11:13)= (fread(i_fid, 3, 'unsigned short'))';

      fprintf(o_fid, 'expected response = %d\n', hd(1,11));
      fprintf(o_fid, 'response = %d\n', hd(1,12));
      fprintf(o_fid, 'response_error = %d\n', hd(1,13));

      time_arr(1:(hd(1,5)),trial+1)  = (fread (i_fid,(hd(1,5)), 'unsigned long'));
      event_arr(1:(hd(1,6)),trial+1) = (fread (i_fid,(hd(1,6)), 'unsigned short'));
      
      fprintf(o_fid, '\nTime\tEvents\n\n');

      for i = 1:hd(1,5),
         
         fprintf(o_fid, '%d\t%d\n', time_arr(i,trial+1), event_arr(i,trial+1));
         
      end;
      
      epp        = fread (i_fid,(hd(1,8)), 'short');
      
      fprintf(o_fid, '\nepp(x)\tepp(y)\n\n');
      
      for i = 1:2:(hd(1,8)),
         
         % Must extract the data from the raw epp values.
         % The epp value is made up of 12-bits of data, and 4-bits (the
         % low-order 4 bits) of the channel number.  
         % To extract the data, must right shift the raw data by 4 bits (to
         % get rid of the channel number and put the data value in the proper 
         % location).  After this conversion, you must still add or subtract
         % 2048, since otherwise the value is not right.  (I think that this
         % is because of the way that matlab handles negative values during
         % the bitwise operations.)
         % These calculations cause the results of ctx2txt.m to be the same as
         % for cortview.exe for the EOG and EPP values.
         
         eppdata1 = bitshift(epp(i), -4);
         eppdata2 = bitshift(epp(i+1), -4);
         
         if (eppdata1 < 0)
            eppdata1 = eppdata1 + 2047;
         else
            eppdata1 = eppdata1 - 2048;
         end;
         
         if (eppdata2 < 0)
            eppdata2 = eppdata2 + 2047;
         else
            eppdata2 = eppdata2 - 2048;
         end;
               
         %         fprintf(o_fid, '%d\t%d\n', epp(i), epp(i+1));
         fprintf(o_fid, '%d\t%d\n', eppdata1, eppdata2);

         
         
      end;
      
      eogs       = fread (i_fid,(hd(1,7)), 'short');
      
      fprintf(o_fid, '\neog(x)\teog(y)\n\n');
      
      for i = 1:2:(hd(1,7)),
         
         fprintf(o_fid, '%d\t%d\n', eogs(i), eogs(i+1));
         
      end;
      
      fprintf(o_fid, '\n-------------------\n');
      
      header(1:13,trial+1)=hd(1,1:13)';
                     
      trial=trial+1;
   end; 
end;
fclose('all');
toc

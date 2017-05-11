function mycsvwrite(fid, row_names, column_names, data)

NEWLINE = sprintf('\n');
% write out column names
colch = char(column_names);
for i = 1:length(column_names),
   fwrite(fid, colch(i, :), 'uchar');
   if (i < length(column_names))
      fwrite(fid, ',', 'uchar');
   end
end;
fwrite(fid, NEWLINE, 'char'); % this may \r\n for DOS

rowch = char(row_names);
for i = 1:length(row_names),
   fwrite(fid, rowch(i,:), 'uchar');
   fwrite(fid, ',', 'uchar');
   for j = 1:length(column_names),
      str = num2str(data(i,j));
      fwrite(fid, str, 'uchar'); 
      if(j < length(column_names))
         fwrite(fid, ',', 'uchar');
      end
   end
   fwrite(fid, NEWLINE, 'char'); % this may \r\n for DOS
end;

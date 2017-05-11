function save_teacher(filename, tch_data)
fid = fopen(filename, 'w');
fprintf(fid, '%d %d %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f %6.6f\n',tch_data');
fclose(fid);
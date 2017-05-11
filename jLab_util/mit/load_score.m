function [score] = read_score(score_struct, file_pointer)

line = fgets(file_pointer);
line = fgets(file_pointer);
line = sscanf(line, '%d', 10);
score_struct.transform = line(1);
score_struct.correlation = line(2);
score_struct.cliptorange = line(3);
score_struct.subsample = line(4);
score_struct.mu = line(5:9);

line = fgets(file_pointer);
line = sscanf(line, '%f', 18);
score_struct.shape= line(1);
score_struct.wsmoothness= line(2);
score_struct.wspeed = line(3);
score_struct.wnumvelpeaks = line(4);
score_struct.outliers = line(5);
score_struct.wduration = line(6);
score_struct.inrange = line(7:8);
score_struct.outrange = line(9:10);
score_struct.power = line(11);
score_struct.wSens = line(12:14);
score_struct.wRpos = line(15);
score_struct.wRvel = line(16);
score_struct.wTpos = line(17);
score_struct.wTvel = line(18);

line = fgets(file_pointer);
line = sscanf(line, '%d %d %d %d %d %f %f %f %f %f');
score_struct.sigma = line(1:5);
score_struct.wgauss = line(6:10);

line = fgets(file_pointer);
line = sscanf(line, '%d %d %s', 3);
score_struct.align = line(1);
score_struct.lower = line(2);
score_struct.name = line(3);

score = score_struct;
function calculate_all_patients()
% now run all the patient involved and non-involved scripts
% in their respective directories
%
% go into bin\proj_calculate.m to adjust specific calculation parameters, like spill_stats, path_length etc.
%
original_dir = pwd;
tic
disp('calculating S1 data...');
disp(datestr(now));
cd E:\Matlab\work\s1grdata\LeftRWT
s1calc
cd E:\Matlab\work\s1grdata\RightRWT
s1calc_non
disp('calculating S2 data...');
disp(datestr(now));
cd E:\Matlab\work\s2tcdata\LeftRWT
s2calc_non
cd E:\Matlab\work\s2tcdata\RightRWT
s2calc
disp('calculating S3 data...');
disp(datestr(now));
cd E:\Matlab\work\s3eodata\LeftRWT
s3calc_non
cd E:\Matlab\work\s3eodata\RightRWT
s3calc
disp('calculating S4 data...');
disp(datestr(now));
cd E:\Matlab\work\s4jrdata\LeftRWT
s4calc_non
cd E:\Matlab\work\s4jrdata\RightRWT
s4calc
cd E:\Matlab\work\BancroftNormal\Left
S14Lcalc
cd E:\Matlab\work\BancroftNormal\Right
S14Rcalc
datestr(now)
toc
cd(original_dir);



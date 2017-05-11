disp('calculating S103 data...');
disp(datestr(now));
cd E:\Matlab\work\DanaRWTdata\S3data\LeftRWT
[results, project_files, comments, labels, measure_names, condition_names] = s103Lcalc;
cached_results{4} = {results comments labels};
crunch2 = updateSubject(crunch2, 'S103L', comments, labels, results);

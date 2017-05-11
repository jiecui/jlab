comments = {};
project_files = {};
% add as we go along
comments = [comments, {'Pre1 jr rt. inv'}];
project_files = [project_files {'Pre1R_inv009_3.prj'}];
comments = [comments, {'Pre2 jr rt. inv'}];
project_files = [project_files {'Pre2R_inv009_4.prj'}];
comments = [comments, {'Post1 jr rt. inv s/p 16 Rx'}];
project_files = [project_files {'Post1R_16inv009_23.prj'}];
comments = [comments, {'Post2 jr rt. inv s/p 16 Rx'}];
project_files = [project_files {'Post2R_16inv009_26.prj'}];
comments = [comments, {'Post3 jr rt. inv s/p 32 Rx'}];
project_files = [project_files {'Post3R_32inv009_52.prj'}];
comments = [comments, {'Post4 jr rt. inv s/p 32 Rx'}];
project_files = [project_files {'Post4R_32inv009_56.prjj'}];

calc_sessions('S4Rt_009_TrCnd.csv', 'S4Rt_009_PrePost.csv', project_files, comments);

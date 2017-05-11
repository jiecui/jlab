function [results, project_files, comments, labels, measure_names, condition_names] = normcalc()

global output_dir;

comments = {};
project_files = {};
num_project_files = 17;
% add as we go along
comments = [comments, {'EB Right'}];
project_files = [project_files {'RNormalEBmale_111_1.prj'}];
comments = [comments, {'VP Right'}];
project_files = [project_files {'RNormalVPfem_901_2_fixed.prj'}];
comments = [comments, {'VP Left'}];
project_files = [project_files {'LNormalVPfem_901_1.prj'}];
comments = [comments, {'TD Left'}];
project_files = [project_files {'LNormalTDmale_902_1.prj'}];
comments = [comments, {'RE Right'}];
project_files = [project_files {'RNormalREmale_903_1.prj'}];
comments = [comments, {'MC Right'}];
project_files = [project_files {'RNormMCfem_904_1.prj'}];
comments = [comments, {'MC Left'}];
project_files = [project_files {'LNormMCfem_904_5.prj'}];
comments = [comments, {'SO Right'}];
project_files = [project_files {'RNormSOmale_905_1.prj'}];
comments = [comments, {'SO Left'}];
project_files = [project_files {'LNormSOmale_905_2.prj'}];
comments = [comments, {'JG Right'}];
project_files = [project_files {'RNormJGfem_907_1.prj'}];
comments = [comments, {'JG Left'}];
project_files = [project_files {'LNormJGfem_907_2.prj'}];
comments = [comments, {'DV Right'}];
project_files = [project_files {'RNormDVmale_908_1.prj'}];
comments = [comments, {'DV Left'}];
project_files = [project_files {'LNormDVmale_908_3.prj'}];
comments = [comments, {'SL Right'}];
project_files = [project_files {'RNormSLmale_909_1.prj'}]; 
comments = [comments, {'SL Left'}];
project_files = [project_files {'LNormSLmale_909_2.prj'}]; 
comments = [comments, {'GS Right'}];
project_files = [project_files {'RNormGSfem_910_1.prj'}];
comments = [comments, {'GS Left'}];
project_files = [project_files {'LNormGSfem_910_3.prj'}];



% labels will go into crunch plot for group labels -- will be one of:
% Pre1, Pre2, Post10, Post20a, Post20b, Post30 for subjects, but different for normals
labels = [{'NRMO111'}{'NRFY901'} {'NLFY901'} {'NLMY902'} {'NRMY903'} {'NRFO904'} {'NLFO904'}...
      {'NRMY905'} {'NLMY905'} {'NRFO907'} {'NLFO907'} {'NRMY908'} {'NLMY908'} {'NRMO909'} ...
   {'NLMO909'} {'NRFO910'} {'NLFO910'}];
%need to check delays for each file and also number of trials

delay_cells = {};
delay_cells{num_project_files} = [];
%set values below to be same as number of trials for each session
%1st session in this list
delay_cells{1} = ones(75,1)*3.0;
%2nd session in this list
delay_cells{2} = ones(75,1)*3.0;
% 3d session in this list
delay_cells{3} = ones(70,1)*3.0;
% 4th session in this list
delay_cells{4} = ones(70,1) *3.0;
% 5th session in this list
delay_cells{5} = ones(70,1) *3.0;
% 6th session in this list
delay_cells{6} = ones(70,1) *3.0;
% 7th session in this list
delay_cells{7} = ones(70,1) *3.0;
delay_cells{8} = ones(70,1) *3.0;
delay_cells{9} = ones(79,1) *3.0;
delay_cells{10} = ones(70,1) *3.0;
delay_cells{11} = ones(74,1) *3.0;
delay_cells{12} = ones(70,1) *3.0;
delay_cells{13} = ones(70,1) *3.0;
delay_cells{14} = ones(70,1) *3.0;
delay_cells{15} = ones(75,1) *3.0;
delay_cells{16} = ones(70,1) *3.0;
delay_cells{17} = ones(75,1) *3.0;

target_cells = {};
target_cells{num_project_files} = [];
% 1st session in this list
target_cells{1} = ones(75,3)*3.0;
% 2d session in this list
target_cells{2} = ones(75,3)*3.0;
% 3d session in this list
target_cells{3} = ones(70,3)*3.0;
% 4th session in this list
target_cells{4} = ones(70,3) *3.0;
% 5th session in this list
target_cells{5} = ones(70,3) *3.0;
% 6th session in this list
target_cells{6} = ones(70,3) *3.0;
% 7th session in this list
target_cells{7} = ones(70,3) *3.0;

%NEW
target_cells{8} = ones(70,3) *3.0;
target_cells{9} = ones(79,3) *3.0;
target_cells{10} = ones(70,3) *3.0;
target_cells{11} = ones(74,3) *3.0;
target_cells{12} = ones(70,3) *3.0;
target_cells{13} = ones(70,3) *3.0;
target_cells{14} = ones(70,3) *3.0;
target_cells{15} = ones(75,3) *3.0;
target_cells{16} = ones(70,3) *3.0;
target_cells{17} = ones(75,3) *3.0;


ppfilename = 'Normal_PrePost.csv';
[results, measure_names, condition_names] = dana_calc_sessions('Normal_TrCnd.csv', ppfilename , project_files, comments, delay_cells, target_cells);
try
   copyfile(ppfilename , strcat(output_dir,'\',ppfilename));
catch
   return
end

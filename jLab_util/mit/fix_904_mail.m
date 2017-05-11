function session = fix_904_mail()


% goes through mail scenes (11-25) of session L904_5
% and associates trial and teacher start locations in the data matrix to them
proj = load('E:\Matlab\work\DanaRWTdata\Normals\LNormMCfem_904_5.prj', '-MAT');
names = fieldnames(proj);
proj = getfield(proj,names{1});
session = proj.session_info;

dat = session.data;
ii = session.trial_start;
iif = session.trial_end;
% go through each session and get the trial name
% if it is one we know, AND if sensor 4 is missing, then fix it
% fix it by making a matrix of the right number of samples with "ones" * correct row
% and inserting this into data. As well, add the number of rows to the current
% trial's iif, and subsequent ii's and iif's and subsequent teacher's ti and tif's

for t=11:25
   tbegin = ii(t);
   tend = iif(t);
   tdat = dat(tbegin+find(dat(tbegin+1:tend-1,1)==1),:);
   nrows = size(tdat,1);
   s2begin = tbegin + nrows + 1;
   s2end = s2begin + nrows - 1;
   gl = pol2gl(tdat);
   for j = 1:nrows
      gl(:,:,j) = gl(:,:,j)*rotx(pi);
   end
   pol = gl2pol(gl);
   tdat(:,3:14)=pol(:,3:14);
   dat(s2begin:s2end,:) = tdat;
end;
session.data = dat;
proj.session_info = session;
current_proj = proj;

%save file
save('E:\Matlab\work\DanaRWTdata\Normals\LNormMCfem_904_5_mailfixed.prj', 'current_proj');
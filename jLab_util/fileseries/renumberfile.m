function renumberfile(f,pat,newnum,nz)
%RENUMBERFILE  Re-number the indices of a series of files.
%   RENUMBERFILE(NAME, P) renumbers the files matching NAME having an index
%   following the substring P, using consecutive indices starting from 1.
%   Wildcards (*) and brackets (see EXPANDSTR) may be used in NAME. If P is
%   present several times in a filename, uses only the last occurrence.
%   RENUMBERFILE works only in the current directory (NAME cannot contain
%   pathnames).
%
%   RENUMBERFILE(NAME, P, NEWNUM) does the same, using NEWNUM to renumber
%   the files. If NEWNUM is a number, uses consecutive indices starting
%   from NEWNUM. If NEWNUM is an array, uses it to renumber the files. By
%   default, NEWNUM=1.
%
%   RENUMBERFILE(NAME, P, NEWNUM, NZ) specifies the number of 0 padding the
%   index (eg, '302' padded with 5 zeros is '00302'). By default, NZ=5.
%
%   Examples:
%      If RENUMBERFILE('DSC*.JPG','DSC') is used in a directory that
%      contains 100 JPG-files with arbitrary file numbers, the files are
%      renumbered as 'DSC00001.JPG'...'DSC00100.JPG'.
%
%      RENUMBERFILE('DSC*.JPG','DSC',401) does the same, renumbering
%      the files as 'DSC00401.JPG'...'DSC00500.JPG'.
%
%      RENUMBERFILE('DSC*.JPG','DSC',1,3) does the same, renumbering
%      the files as 'DSC001.JPG'...'DSC100.JPG'.
%
%   F. Moisy
%   Revision: 1.11,  Date: 2005/10/06.
%
%   See also GETFILENUM, EXPANDSTR, RDIR, RENAMEFILE.

% History:
% 2004/03/09: v1.00, first version.
% 2005/09/02: v1.01, help text changed and arg check.
% 2005/10/04: v1.10, syntax changed. now accept wildcards, file expansion.
% 2005/10/06: v1.11, uses a tmp directory in the matlabroot directory

error(nargchk(2,4,nargin));

oldfilename=rdir(f); % expands [] and resolve wildcards
num=getfilenum(f,pat);
if ~exist('newnum','var'), newnum=1; end;
if length(newnum)==1, newnum=newnum:(newnum+length(num)-1); end;
if ~exist('nz','var'), nz=5; end;

tmpdir=[matlabroot filesep 'tmp'];
if ~exist(tmpdir,'dir'),
    mkdir(tmpdir);
else
    delete([tmpdir filesep '*']);
end;

for i=1:length(num),
    oldf=oldfilename{i};
    p=findstr(oldf,pat);
    p=p(end)+length(pat); % position of the first digit
    prefix=oldf(1:(p-1));
    pp=p; while length(str2num(oldf(pp))), pp=pp+1; end;
    suffix=oldf(pp:end);
    newf=expandstr([prefix '[' num2str(newnum(i)) ',' num2str(nz) ']' suffix]);
    newf=newf{1};
    copyfile(oldf,[tmpdir filesep newf],'writable');
    delete(oldf);
end;
copyfile([tmpdir filesep '*'],'.');
delete([tmpdir filesep '*']);
rmdir(tmpdir);

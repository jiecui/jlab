function renamefile(f,pat1,pat2)
%RENAMEFILE  Rename a series of files.
%   RENAMEFILE(NAME, P1, P2) renames the files matching NAME, replacing
%   the substring P1 by P2. NAME may be a cell array of strings, and may
%   contain wildcards (*) and brackets (see EXPANDSTR). If P1 is present
%   several times in a filename, replaces only the last occurrence.
%
%   Examples:
%      RENAMEFILE('DSC*.JPG','DSC','myphoto')
%      renames the files 'DSC00001.JPG','DSC00002.JPG',... as
%      'myphoto00001.JPG','myphoto00002.JPG',...
%
%      RENAMEFILE('*/DSC*.JPG','DSC','myphoto')
%      does the same in all the directories containing JPG files.
%
%      RENAMEFILE('B[1:100,3]*.VEC','B','PIV') renames the files
%      'B001*.VEC' to 'B100*.VEC' as 'PIV001*.VEC' to 'PIV100*.VEC'
%
%   F. Moisy
%   Revision: 1.00,  Date: 2005/10/04.
%
%   See also RENUMBERFILE, MOVEFILE, EXPANDSTR, RDIR, GETFILENUM.

% History:
% 2005/10/04: v1.00, first version.
% 2005/10/06: v1.01, details.


error(nargchk(3,3,nargin));

if ~strcmp(pat1,pat2),
    oldfilename=rdir(f); % expands brackets ([]) and resolves wildcards (*)

    for i=1:length(oldfilename),
        oldf=oldfilename{i};
        p=findstr(oldf,pat1); p=p(end);
        newf=[oldf(1:(p-1)) pat2 oldf((p+length(pat1)):end)];
        movefile(oldf,newf);
    end;
end;
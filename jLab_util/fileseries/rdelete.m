function rdelete(f)
%RDELETE  Delete a series of files.
%   RDELETE file_name  deletes the named files. Wildcards may be used in
%   the filename, as with DELETE, but also in the pathnames, which allows
%   for deleting a series a files belonging to different directories.
%   Brackets ([]) may also be used (see EXPANDSTR).
%
%   Use the functional form of RDELETE, such as RDELETE('file'), when the
%   file names are stored in a string or a cell array of strings.
%
%   To delete directories, see RRMDIR.
%
%   Examples:
%      RDELETE('DSC*.JPG') is equivalent to DELETE('DSC*.JPG')
%
%      RDELETE('*/*.JPG') deletes all the JPG-files in all the directories.
%
%      RDELETE('mydir*/DSC[10:30].*') deletes the files DSC00010.* to
%      DSC00030.* in each directory 'mydir*'.
%
%   F. Moisy
%   Revision: 1.00,  Date: 2005/10/11.
%
%   See also DELETE, EXPANDSTR, RDIR, RMDIR, RRMDIR.

% History:
% 2005/10/11: v1.00, first version.

error(nargchk(1,1,nargin));

f=rdir(f,'fileonly');

for i=1:length(f)
    delete(f);
end;

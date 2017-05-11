function varargout=rrmdir(varargin)
%RRMDIR  Delete a series of directories.
%   RRMDIR dir_name  deletes the named directories. Wildcards may be used
%   in the directory name and in the intermediate pathnames, contrarily
%   to RMDIR. Brackets ([]) may also be used (see EXPANDSTR).
%
%   Use the functional form of RRMDIR, such as RRMDIR('dir'), when the
%   directory names are stored in a string or a cell array of strings.
%
%   The syntax is the same as for Matlab's RMDIR. In particular, the
%   additional input and output arguments of RMDIR can be used, i.e.
%   [SUCCESS,MESSAGE,MESSAGEID] = RRMDIR(DIRECTORY,MODE). See RMDIR for
%   details.
%
%   To delete files, see RDELETE.
%
%   Examples:
%      RRMDIR('mydir*') deletes all the directories 'mydir*'
%
%      RRMDIR('mydir*/subdir[1:10,2]') deletes the subdirectories 'sub01',
%      'sub02',... in each directory mydir*.
%
%   F. Moisy
%   Revision: 1.00,  Date: 2005/10/11.
%
%   See also RMDIR, EXPANDSTR, RDIR, RDELETE, DELETE.

% History:
% 2005/10/11: v1.00, first version.

error(nargchk(1,2,nargin));

f=rdir(f,'dironly');

for i=1:length(f)
    if nargout
        varargout=rmdir(f,varargin{2:end});
    else
        varargout=rmdir(f,varargin{2:end});
    end;
end;

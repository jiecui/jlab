function num=getfilenum(f,pat)
%GETFILENUM  Get the index of a series of files.
%
%   NUM = GETFILENUM (NAME, P) returns an array of integers indexing
%   the filenames (or directory names) matching NAME from the current
%   directory. The integers are searched in the strings following the
%   substring P. For examples, if the files 'B01_t12.vec','B02_t18.vec',
%   'B03_t24.vec' are present in the current directory,
%   GETFILENUM ('*.vec', '_t') returns [12 18 24].
%
%   Example:
%     dir(expandstr(['DSC[' num2str(getfilenum('DSC*.JPG','DSC')) '].JPG']))
%        is equivalent to:
%     dir('DSC*.JPG');
%
%   F. Moisy
%   Revision: 1.00,  Date: 2005/10/04.
%
%   See also EXPANDSTR, RDIR, RENUMBERFILE.

% History:
% 2004/10/04: v1.00, first version.

error(nargchk(2,2,nargin));

filename=rdir(f);

num=[];
nnum=0; % number of file numbers found

for i=1:length(filename),
    fname=filename{i};
    p=findstr(fname,pat);
    if length(p),
        p=p(1)+length(pat); % position of the first digit
        if length(str2num(fname(p))), % if it is indeed a digit
            nnum=nnum+1;
            strn='';
            % builds the string of the number as long as digits are found:
            while length(str2num(fname(p))),
                strn=[strn fname(p)];
                p=p+1;
                if p>length(fname), break; end; % exit the while loop
            end;
            num(nnum)=str2num(strn);
        end;
    end;
end;

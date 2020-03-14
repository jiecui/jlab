% This function makes a zip file archive from an m-file and its
% dependencies.  The zip-file is stored in the same path as the 
% m-file with a *.zip extension.  The keyword is used to identify and
% package ONLY m-files that are on paths containing the keyword.  This
% prevents the archiving of Mathwork functions which the end user is likely
% to have or need a license for.
%
%  SYNTAX: package(mfile,keyword);
%
% DBE 10/26/04
% DBE 06/24/05 Modified to use username if no keyword is passed IFF Unix platform
%              Included DEPFUN2 as a sub-function.
%
% See also DEPFUN, DEPFUN2

function package(mfile,keyword);

if nargin==1
  list=depfun2(mfile);
elseif nargin==2
  list=depfun2(mfile,keyword);
else
  error('PACAKGE.M requires 1-2 inputs on Unix machines and 2 inputs on PC machines.');
end

fprintf('The following m-files were packaged together:\n');  celldisp(list);        % Display the relevant files

zipname=which(mfile);
zipname=[zipname(1:end-1),'zip'];   % Create an *.zip filename based on the root m-file name
zip(zipname,list);                  % Zip them together

return

% DEPFUN2 finds the M-file dependencies of an m-file whos
% path also contains a keyword.  It relies upon the use of the 
% DEPFUN function.  DEPFUN2 accepts a keyword to 'grep' for allowing 
% the return of m-files that are only found on a specific path (a users 
% path for example).  The keyword (or part of a word) is used to find 
% matches in the full pathname of all files that the m-file depends on.
%
% SYNTAX: G=depfun2(fname,keyword,varargin);
%
% fname    - The name of the m-file for which to determine dependencies
% keyword  - The keyword used to retain m-files whose pathname contains 'keyword'
%            DEFAULT keyword is unix('whoami')
% varargin - Any of the various arguments that DEPFUN usually accepts.
%
% Example: G=depfun2('bench','graphics','-quiet','-toponly'); % Returns FEWER results than...
%          G=depfun2('bench','graphics','-quiet');            % Because this includes indirectly called m-files
% 
% DBE 02/07/03
% DBE 04/10/26 Modified to support full range of DEPFUN inputs.

function G=depfun2(fname,keyword,varargin);
if nargin <2 & isunix
  [status,keyword]=unix('whoami');
  keyword=deblank(keyword);
  if status
    error('UNIX WHOAMI call failed.');
  end
elseif nargin<2 & ~isunix
  error('PACKAGE.M requires two user inputs on the PC platform');
elseif nargin==2
else
  error('depfun2.M requires two user inputs');
end

if nargin>2 % Concatentate the VARARGIN into a string that can be used with DEPFUN
  input=[];
  for n=1:length(varargin)
    input=[input,'''',varargin{n},''''];
    if n~=length(varargin), input=[input,',']; end
  end
else        % Default input string to DEPFUN
  input=['''','-quiet','''',',','''','-toponly',''''];
end

T=eval(['depfun(fname,',input,');']);

G=[]; m=1;
for k=1:length(T)
  f=strfind(T{k},keyword);
  if ~isempty(f), 
    G{m}=T{k};
    m=m+1; 
  end
end

G=G';

return

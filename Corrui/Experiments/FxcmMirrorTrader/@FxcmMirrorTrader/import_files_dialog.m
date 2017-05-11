function [filenames, pathname, sessname, S] = import_files_dialog( prefix, tag, extension, extra_options )
% FXCMMIRRORTRADER.IMPORT_FILES_DIALOG collects multiple filenames of data to be imported

% Initially modified by Richard J. Cui. on: Sun 11/09/2014 12:45:22.466 AM
% $Revision: 0.3 $  $Date: Mon 12/29/2014  2:42:14.637 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

filenames		= {};
sessname		= {};

% first, get the name of the file(s)
% ----------------------------------
orig_dir = pwd;
pathname = getpref('corrui', [lower(extension) tag 'Directory'], [orig_dir filesep]);
if(isempty(pathname))
    pathname = orig_dir;
end % if
uppext = upper(extension);
lowext = lower(extension);
FilterName = ['*.', uppext, ';', '*.', lowext]; 
switch uppext
    case 'XLSX'
        FilterDescription = 'XLSX Excel data file (*.xlsx)';
    otherwise
        FilterDescription = '';
end % switch
FilterSpec = {FilterName, FilterDescription};
FilterSpec = cat(1, FilterSpec, {'*.*', 'All Files (*.*)'});
DialogTile = ['Choose ', tag, ' file(s)'];
DefaultName = pathname;
[S.Files, path_file, FilterIndex] = uigetfile(FilterSpec, DialogTile, DefaultName, 'MultiSelect', 'on');
if ( FilterIndex == 0)
	return
end

% add the file names to the options so they can be changed
if ischar(S.Files)
    S.Files = {S.Files};
end % if
NF = length(S.Files);
optFileNames = [];
for k = 1:NF
    [~, fname_k] = fileparts(S.Files{k});
    optFileNames.(['File',num2str(k)]) = fname_k;
end % for

% second, get the name of the sessions
% ------------------------------------
if NF == 1
    % single file selected
    fname1st = S.Files{1};
    [~, name1st]	= fileparts(fname1st);
    Session_names	= { cstAssetName(prefix, name1st) };
else
    % multiple files selected
    opt.Importing_sessions_type = { 'Single|{Multiple}' };
    opt = StructDlg(opt, 'Please choose...', [], CorrGui.get_default_dlg_pos());
    switch opt.Importing_sessions_type  
        case 'Single'       % single session
            fname1st = S.Files{1};
            [~, name1st]	= fileparts(fname1st);
            Session_names	= { cstAssetName(prefix, name1st) };
        case 'Multiple'     % multiple sessions
            Session_names = cell(NF, 1);
            for k = 1:NF
                fname_k = S.Files{k};
                [~, name_k] = fileparts(fname_k);
                % assume the first 6 letters are the forex pair names
                % pairname_k = upper(name_k(1:6));
                % sname_k = [prefix, pairname_k];
                % Session_names{k} = sname_k;
                Session_names{k} = cstAssetName(prefix, name_k);
            end % for
    end % switch
end % if
% add the session names to the options so they can be changed
NS = length(Session_names);
optSessionNames = [];
for k = 1:NS
    optSessionNames.(['Session', num2str(k)]) = Session_names{k};
end % for

S = mergestructs(optFileNames, optSessionNames);
S = mergestructs( S, extra_options );
S = StructDlg( S, ['Specify ', tag, ' session name'], [],  CorrGui.get_default_dlg_pos() );
if(isempty(S))
    return
end %if

% commit
% -------
% filenames
for k = 1:NF
	fname_k   = S.(['File', num2str(k)]);
    filenames = cat(1, filenames, [fname_k, '.', uppext]);
end
% pathname
pathname = path_file;
% session names
for k = 1:NS
    sessn_k = S.(['Session', num2str(k)]);
    % make sure the prefix is correct in the session
    if ( ~isequal(prefix, sessn_k(1:length(prefix))) )
        sess_k = [prefix sessn_k];
    else
        sess_k = sessn_k;
    end
    sessname = cat(1, sessname, sess_k);
end % for

% save cortex path in prefs
setpref('corrui', [lower(extension) tag 'Directory'], pathname);

end % function

% =========================================================================
% subroutines
% =========================================================================
function aname = cstAssetName(prefix, fname)
% construct asset/strategy name

% assume the format of data name is 'pairname_strategyname'

% idx = regexp(fname, '[^_]');
% pairname = upper(fname(idx));
idx = regexp(fname, '_');           % position of underline
pairname = upper(fname(1:idx-1));   % pair name
strtname = lower(fname(idx+1:end)); % strategy name
aname	= [prefix, [pairname, strtname]];

end % funciton

% [EOF]
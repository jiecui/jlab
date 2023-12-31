function [filenames, pathname, sessname, S] = import_files_dialog( prefix, tag, extension, extra_options )
% DATAIO.IMPORT_FILES_DIALOG collects multiple filenames of data to be imported

% Initially modified by Richard J. Cui. on: Thu 04/21/2011  9:04:32 AM
% $Revision: 0.6 $  $Date: Sun 11/09/2014 12:45:22.466 AM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

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
    case 'RF'
        FilterDescription = 'RF2 binary data (*.rf)';
    case 'EDF'
        FilterDescription = 'EyeLink data file (*.edf)';
    case 'AVI'
        FilterDescription = 'Audio video interleave file (*.avi)';
    case 'MAT'
        FilterDescription = 'MatLab MAT-file (*.mat)';  
    case 'TSV'
        FilterDescription = 'TSV text file (*.tsv)';
    case 'CSV'
        FilterDescription = 'CSV text file (*.csv)';
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
    Session_names	= { [prefix, name1st] };
else
    % multiple files selected
    opt.Importing_sessions_type = { 'Single|{Multiple}' };
    opt = StructDlg(opt, 'Please choose...', [], CorrGui.get_default_dlg_pos());
    switch opt.Importing_sessions_type  
        case 'Single'       % single session
            fname1st = S.Files{1};
            [~, name1st]	= fileparts(fname1st);
            Session_names	= { [prefix, name1st] };
        case 'Multiple'     % multiple sessions
            Session_names = cell(NF, 1);
            for k = 1:NF
                fname_k = S.Files{k};
                [~, name_k] = fileparts(fname_k);
                sname_k = [prefix, name_k];
                Session_names{k} = sname_k;
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

% [EOF]
function sessname = import( this, datafiles, S)
% DATAIO.IMPORT  Imports new sessions data to corrui database
%
% Syntax:
%   sessname = import( this, datafiles, S)
%
% Input(s):
%   this        - current experiment object
%   datafiles   - filenames of data sessions
%   S           - options for importing (different for different filetype)
%                 .FileType
%                 .PathName
%                 .SessionName      % new session name
%                 .Values
%
% Output(s):
%   sessname
%   imported_data
%
% Example:
%
% See also .

% Copyright 2013-2016 Richard J. Cui. Created: 04/27/2013 11:17:47.607 PM
% $Revision: 0.5 $  $Date: Thu 07/07/2016 10:55:22.975 AM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

if isempty(this.db)
    this.db = CorruiDB(getpref('corrui', 'db_name' , pwd));
end % if

% single is a special case of batch
if ischar(datafiles)
    datafiles = {datafiles};
end
if ~iscell(S)
    S = {S};
end

prefix = this.prefix;

N = length(datafiles);
sessname = cell(1, N);
for k = 1:N
    S_k = S{k};
    filetype_k = S_k.FileType;
    pathname_k = S_k.PathName;
    sessname_k = S_k.SessionName;
    values_k   = S_k.Values;
    % check filename
    datafile_k = datafiles{k};
    [~, ~, ext] = fileparts(datafile_k);
    if isempty(ext)
        datafile_k = sprintf('%s.%s', datafile_k, filetype_k);
    end % if
    
    sessname_k = import_single(this, prefix, filetype_k, pathname_k, datafile_k, sessname_k, values_k);
    sessname{k} = sessname_k;
end % for

end % function import

% =========================================================================
% subroutines
% =========================================================================
function [session_name, imported_data] = import_single( this, prefix, filetype, pathname, filename, session_name, values)
% IMPORT_SINGLE  imports a single new session /block VNLCorrui database
%
% Syntax:
%   [sessname imported_data] = import_single( this, filetype, files_dir, files, session_name)
%
% Input(s):
%   this            - exp object
%   filetype        - RF, AVI, etc.
%   pathname        - pathname of files
%   filenames       - data to be imported
%   session_name    - session where imported data will be added
%   values          - options for importing data
%
% Output(s):
%   sessname
%   imported_data
%
% Example:
%
% See also .

fprintf(sprintf('\n------>Importing session %s of %s experiment<------\n',...
    this.SessName2UserSessName(session_name), this.name))

% backward compatibility
switch class(this)
    case { 'BlankCtrl', 'Tune', 'Grating',  'AlternatingBrightnessStar' }
        
        % select the import function depending in the file type
        % ------------------------------------------------------
        switch(filetype)
            case 'AVI'
                import_function = @import_avi;
            case 'EDF'
                import_function = @import_edf;
            case 'EDF (Cortex)'
                import_function = @import_edf_cortex;
            case 'IDF'
                import_function = @import_idfs;
            case 'LAB'
                import_function = @import_labs;
            case 'MAT'
                import_function = @import_mat;
            case 'MAT (Leigh)'
                import_function = @import_mats_leigh;
            case 'CTX'
                import_function = @import_ctxs;
            case 'MAT (generic LR)'
                import_function = @import_mats_generic;
            case 'MAT (psycortex2)'
                import_function = @PsyCortexAnalysis.import;
            case 'MAT (fjflores)'
                import_function = @import_mats_flores;
            case 'RF'
                import_function = @import_rf;
            case 'TSV'
                import_function = @import_tsv;
            otherwise
                error('Unknown Filetype');
        end
        
        % import the data
        % ---------------
        % [session_name, imported_data] = import_function( class(this), this.db, this.prefix, pathname, filename, session_name, values);
        [session_name, imported_data] = import_function( this, pathname, filename, session_name, values);
    otherwise
        [session_name, imported_data] = this.importExp(pathname, filename, session_name, values, filetype);
end % switch

% make sure the prefix is correct in the session
if ( ~isequal(prefix, session_name(1:length(this.prefix))) )
    session_name = [this.prefix session_name];
end

% get info about import for all exps
% ----------------------------------
imported_data.internalTag           = class(this);
imported_data.info.import.folder    = pathname;
imported_data.info.import.filename  = filename;
imported_data.info.import.date      = datestr(now);
imported_data.info.import.filetype  = filetype;

% get info about exp specified imported data
% ------------------------------------------
imported_data = this.getExpImportedDataInfo(imported_data);

% -------------------
% save data imported
% -------------------
if isfield(imported_data.info.import, 'variables')
    imported_data.info.import.variables = union(fieldnames( imported_data ), imported_data.info.import.variables);
else
    imported_data.info.import.variables = fieldnames( imported_data );
end

this.db.unlock(session_name, fieldnames( imported_data ) );
this.db.add( session_name, imported_data );
this.db.lock( session_name, fieldnames( imported_data ) );

end % function

% [EOF]

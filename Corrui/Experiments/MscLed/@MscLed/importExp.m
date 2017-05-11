function [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
% MSCLED.IMPORTEXP imports experimental data
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Tue 07/01/2014 11:46:40.086 AM
% $Revision: 0.1 $  $Date: Tue 07/01/2014 11:46:40.086 AM $
%
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ---------------------------------------------
% Get the filenames of data from the dialog,
% if it is not provided
% ---------------------------------------------
if ( ~exist( 'pathname', 'var' ) )
    S=[];
    [filename, pathname, session_name] = import_files_dialog( this.prefix, tag, imported_filetype, S );
    if ( isempty( filename ) )
        session_name = [];
        imported_data = [];
        return
    end
    if length(session_name) == 1
        session_name = session_name{1};
    end % if
end

% --------------------------
% inport exp data to matlab
% --------------------------
switch imported_filetype
    case 'RF'
        imported_data = importMldRf(pathname, filename, values);
    otherwise
        error('MSaccContrast:importExp:unknownFiletype', ...
            'No known method to import filetype %s to experiment %s.', imported_filetype, this.name)
end

end % function importExp

% =========================================================================
% subroutines
% =========================================================================
function imported_data = importMldRf(pathname, filename, values)

mld_exp = MLDImportRF(pathname, filename, values);
% save spike and eye data
% ---------------------
imported_data.SAEChunkData = mld_exp.SAEChunkData;
% save mscled data
% -----------------
imported_data.BctChunkData = mld_exp.BctChunkData;  % use BctChunk
imported_data.LastBctChunk = mld_exp.BctChunkData.LastBctChunk;
% save other system info
% --------------------
imported_data.ImportPara    = mld_exp.ImportPara;
imported_data.HorAngle      = mld_exp.HorAngle;
imported_data.VerAngle      = mld_exp.VerAngle;
imported_data.samplerate    = mld_exp.samplerate;
imported_data.timestamps    = mld_exp.timestamps;
imported_data.samples       = mld_exp.samples;
imported_data.spiketimes    = mld_exp.spiketimes;
imported_data.blinkYesNo    = mld_exp.blinkYesNo;
imported_data.TuneChunkData = mld_exp.TuneChunkData;
imported_data.BeforeExpTuneChunk    = mld_exp.TuneChunkData.BeforeExpTuneChunk;
imported_data.AfterExpTuneChunk     = mld_exp.TuneChunkData.AfterExpTuneChunk;

end % function

% [EOF]

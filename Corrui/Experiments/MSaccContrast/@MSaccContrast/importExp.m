function [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
% MSACCCONTRAST.IMPORTEXP imports experimental data
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

% Copyright 2014 Richard J. Cui. Created: Sat 03/15/2014  5:05:42.078 PM
% $Revision: 0.1 $  $Date: Sat 03/15/2014  5:05:42.078 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
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
        imported_data = importMscRf(pathname, filename, values);
    otherwise
        error('MSaccContrast:importExp:unknownFiletype', ...
            'No known method to import filetype %s to experiment %s.', imported_filetype, this.name)
end

end % function importExp

% =========================================================================
% subroutines
% =========================================================================
function imported_data = importMscRf(pathname, filename, values)

contrast_exp = MSCImportRF(pathname, filename, values);
% save spike and eye data
% ---------------------
imported_data.SAEChunkData = contrast_exp.SAEChunkData;
% save contrast data
% -----------------
imported_data.ConChunkData = contrast_exp.ConChunkData;
imported_data.LastConChunk = contrast_exp.ConChunkData.LastConChunk;
% save other system info
% --------------------
imported_data.HorAngle      = contrast_exp.HorAngle;
imported_data.VerAngle      = contrast_exp.VerAngle;
imported_data.samplerate    = contrast_exp.samplerate;
imported_data.timestamps    = contrast_exp.timestamps;
imported_data.samples       = contrast_exp.samples;
imported_data.spiketimes    = contrast_exp.spiketimes;
imported_data.blinkYesNo    = contrast_exp.blinkYesNo;
imported_data.TuneChunkData = contrast_exp.TuneChunkData;
imported_data.BeforeExpTuneChunk    = contrast_exp.TuneChunkData.BeforeExpTuneChunk;
imported_data.AfterExpTuneChunk     = contrast_exp.TuneChunkData.AfterExpTuneChunk;

end % function

% [EOF]

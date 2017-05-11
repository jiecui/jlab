function [sessname, imported_data] = import_mat( this, pathname, filename, sessname, values)
% IMPORT_MAT imports MatLab MAT files for one data session / blocks

% Copyright 2014 Richard J. Cui. Created: Sat 11/02/2013  4:49:21.419 PM
% $Revision: 0.2 $  $Date: Sat 03/15/2014 10:24:53.558 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% NOTE: tag name is the folder name in 'Experiments', which is actually a
%       project name.

tag = class(this);
prefix = this.prefix;

% ---------------------------------------------
% Get the filenames of data from the dialog,
% if it is not provided
% ---------------------------------------------
if ( ~exist( 'pathname', 'var' ) )
    S=[];
    [filename, pathname, sessname] = import_files_dialog( prefix, tag, 'MAT', S );
    if ( isempty( filename ) )
        sessname = [];
        imported_data = [];
        return
    end
    if length(sessname) == 1
        sessname = sessname{1};
    end % if
end

% --------------------------
% inport exp data to matlab
% --------------------------
fprintf(sprintf('\n------>Importing session %s of %s experiment<------\n', sessname, tag))

    switch tag  % tage of different experiments
        case 'Tinnitus'
            tin_exp = importMAT.importTinnitusExp(pathname, filename, values);
            
            % save data
            % ----------------------
            imported_data.enum          = tin_exp.enum;
            imported_data.ExpSR         = tin_exp.ExpSR;
            imported_data.EyeSignal     = tin_exp.EyeSignal;
            imported_data.CH1           = tin_exp.CH1;
            imported_data.ExpBlinkYN    = tin_exp.ExpBlinkYN;
            imported_data.Clinic        = tin_exp.Clinic;
            imported_data.Comment       = tin_exp.Comment;
            imported_data.ExpDate       = tin_exp.ExpDate;
            imported_data.OriginalFile  = tin_exp.OriginalFile;
            imported_data.StartTime     = tin_exp.StartTime;
            imported_data.FixPosIndex   = tin_exp.FixPosIndex;
            
        otherwise % import other old data
            error('Import:import_mat', '%s is an unknown experiment to import MAT data', tag)
    end
        


end % function

% [EOF]

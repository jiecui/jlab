function [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
% GFSMSACC.IMPORTEXP imports experimental data
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

% Copyright 2016 Richard J. Cui. Created: Sun 04/03/2016  5:24:10.660 PM
% $Revision: 0.1 $  $Date: Thu 06/02/2016  5:28:34.633 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

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
    case 'MAT'
        imported_data = GMSImportMAT(pathname, filename, values).ImportedData;
    otherwise
        error('GfsMSacc:importExp:unknownFiletype', ...
            'No known method to import filetype %s to experiment %s.', imported_filetype, this.name)
end

end % function importExp

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

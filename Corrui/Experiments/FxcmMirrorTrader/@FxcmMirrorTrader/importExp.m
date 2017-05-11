function [session_name, imported_data] = importExp(this, pathname, filename, session_name, values, imported_filetype)
% FXCMMIRRORTRADER.IMPORTEXP imports experimental data
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

% Copyright 2014 Richard J. Cui. Created: Sat 11/08/2014 11:02:23.968 PM
% $Revision: 0.2 $  $Date: Thu 11/13/2014 10:34:54.736 PM $
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
    case 'XLSX'
        imported_data = importFmtXLS(pathname, filename, values);
    otherwise
        error('FxcmMirrorTrader:importExp:unknownFiletype', ...
            'No known method to import filetype %s to experiment %s.', imported_filetype, this.name)
end

end % function importExp

% =========================================================================
% subroutines
% =========================================================================
function imported_data = importFmtXLS(pathname, filename, values)

fmt_exp = FMTImportXLS(pathname, filename, values);
strat_prop = fmt_exp.StrategyProperty;
strat_name = strat_prop.StrategyName;
curry_pair = strat_prop.CurrencyPair;
comm_str = sprintf('%s/%s', curry_pair, strat_name);

% save properties and history
% ---------------------------
imported_data.Property     = strat_prop;
imported_data.History      = fmt_exp.History;
imported_data.comment      = comm_str;

end % function

% [EOF]

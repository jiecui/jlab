classdef DataIO < handle
	% Class DATAIO handles processes of data import and outport

	% Copyright 2013-2014 Richard J. Cui. Created: 05/25/2013 12:38:53.323 PM
	% $Revision: 0.6 $  $Date: Sun 11/09/2014 12:45:22.466 AM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 

        
    end % properties

    % =====================================================================
    % constructor
    % =====================================================================
    methods 
        function this = DataIO()
 
        end
    end % methods
    
    methods (Static = true)
        % ====== imports ======
        [filenames, pathname, sessname, S] = import_files_dialog( prefix, tag, extension, extra_options )   % get filename and session name
        imported_data = getExpImportedDataInfo(imported_data)       % get info about imported data
        
    end % static methods
    
    methods (Sealed = true)    % cannot be replaced but can be called by sub-class
        % ====== otheres ======
        dname = SesName2DatName(this, sname)        
    end % methods
    
    methods     % can be redefined by subclasses
        % ====== otheres ======
        sessname = import( this, datablocks, S)    % imports one new session /block VNLCorrui database
    end % methods
    
end % classdef

% [EOF]

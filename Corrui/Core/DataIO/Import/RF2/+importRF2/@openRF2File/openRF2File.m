classdef openRF2File < openDataFile
    %OPENRF2FILE opens a RF data file
    
    % Copyright 2011 Richard J. Cui. Created: 10/31/2011  2:34:58.398 PM
	% $Revision: 0.2 $  $Date: Sun 11/13/2011  3:16:38.167 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    % =======================================================
    % constructor
    % =======================================================
    properties (Abstract)
        
    end % abstract properties
    
    properties (SetAccess = protected)
        fileID = -1;
        extension = '.RF'     % set the file extensiton
    end % properties
    
    methods
        function this = openRF2File()
            
            wholename = [this.pathname, this.filenames];    % only one file now
            if(~isempty(wholename))
                this.fileID = fopen(wholename);
                if this.fileID == -1
                    error('Cannot open file %s.',this.FileName);
                end % if
            end % if
            
        end % function
    end

    % =======================================================
    % destructor
    % =======================================================
    methods (Access = private)
        function delete(this)
            file_id = this.fileID;
            if file_id == true
                fclose(file_id);
            end % if
        end % desctructor
    end % methods
    
end


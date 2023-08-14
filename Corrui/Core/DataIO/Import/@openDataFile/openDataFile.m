classdef openDataFile < handle
	% Class OPENDATAFILE opens a data file for processing

	% Copyright 2011 Richard J. Cui. Created: 10/31/2011  1:30:17.020 PM
	% $Revision: 0.1 $  $Date: 10/31/2011  1:30:17.114 PM $
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
    % -------------
    % properties
    % -------------
    properties (Abstract = true, SetAccess = protected)
        prefix
        tag
        extension
        extra_options
        % Ext         % data file extension
    end % abstract properties
    
    properties (GetAccess = public, SetAccess = private)
        filenames
        pathname
        sessname
        S
        % FilePath
        % FileName
    end % readonly properties
 
    % -------------
    % methods
    % -------------
    methods 
        function this = openDataFile()
            
            %             FilterSpec = ['*' this.Ext];
            %             [filename,filepath] = uigetfile(FilterSpec,'Select the RF-file');
            %             if ~filename
            %                 this.FilePath = [];
            %                 this.FileName = [];
            %             else
            %                 this.FilePath = filepath;
            %                 this.FileName = filename;
            %             end % if
            
            [this.filenames, this.pathname, this.sessname, this.S] ...
                = import_files_dialog( this.prefix, this.tag, ...
                                       this.extension, this.extra_options );
            
        end
    end % methods
end % classdef

% [EOF]

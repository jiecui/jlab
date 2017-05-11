classdef importTinnitusExp < handle
	% Class +IMPORTMAT.IMPORTTINNITUSEXP imports the data from blank control
	%       experiment

	% Copyright 2012 Richard J. Cui. Created: Sat 11/02/2013 11:37:52.572 PM
	% $Revision: 0.1 $  $Date: Sat 11/02/2013 11:37:52.572 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    % session propperties
    properties
        sessname            % session file name
        sesspath            % path of session data
    end % properties
  
    % Tinnitus experiment parameters
    properties
        enum                % name of the fields
        ExpSR               % experimental sampling rate (Hz)
        EyeSignal           % eye positions in deg = [left_x, left_y, right_x, right_y]
        CH1                 % eye position information
        ExpBlinkYN          % experiment blink logical
        Clinic              % clinic info of the subject
        Comment             % comments of the experiment
        ExpDate             % date on which the experiment was done
        OriginalFile        % file name of original data file
        StartTime           % machine time of experiment start
        FixPosIndex         % indexes indicate position of the fix spot
    end % properties
    
    properties (SetAccess = protected)
        
    end % properties
 
    methods 
        function this = importTinnitusExp(filepath, filename, values)
            % basic info not recorded in the dataset
            this.sessname = filename;
            this.sesspath = filepath;
            
            this.Clinic   = values.clinic;
            
            fixpos.Center       = 0.1;
            fixpos.Left         = 0.2;
            fixpos.Right        = 0.5;
            fixpos.Up           = 0.6;
            fixpos.Down         = 0.9;
            this.FixPosIndex    = fixpos;
            
            % -------------------------
            % load dataset into MatLab
            % -------------------------
            wholename = [filepath, filesep, filename];      % single file now
            this.importTin(wholename);
            
            % more on comment
            s1 = cellstr(values.Comment);
            s2 = s1{1};
            if ~isempty(s2)
                com = [s2, '; ', this.Comment];
                this.Comment = com;
            end % if
        end
    end % methods
    
    methods (Access = protected)
        dat = importTin(this, filename)
        
    end % 
end % classdef

% [EOF]

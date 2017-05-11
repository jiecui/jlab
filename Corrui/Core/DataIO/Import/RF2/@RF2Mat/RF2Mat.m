classdef RF2Mat < handle
    % Class RF2Mat converts binary RF files into Matlab file
    
    % Copyright 2010-2011 Richard J. Cui. Created: 01/28/2010 10:19:13.608 PM
    % $Revision: 0.5 $  $Date: Mon 09/19/2011  3:20:31 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    % =====================================================================
    % the constructor
    % =====================================================================
    properties (SetAccess = private)
        DefaultStimType = 'CORNERS';
        MaxChunkrange = 2500;
    end % properties of constructor (private)
    
    methods
        function RM = RF2Mat(filename,stimtype,chunkrange,option,excldrange)
            % RF2Mat convert RF to Matlab
            %
            % Input(s):
            %   filename    - RF data file (optional)
            % RM = RF2Mat(filename,stimtype,chunkrange,option,excldrange)
            
            % ++++++++++++++++++++++++
            % parse inputs
            % ++++++++++++++++++++++++
            if nargin < 1
                [filename,filepath] = uigetfile('*.RF','Select the RF-file');
                RM.FilePath = filepath;
            end % if
            if nargin < 2
                stimtype = RM.DefaultStimType;
            end % if
            if nargin < 3
                chunkrange = [1,RM.MaxChunkrange];
            end % if
            if nargin < 4
                RM.Option.saveRF2Mat = true;
                RM.Option.loadRF2Mat = false;
            else
                RM.Option.saveRF2Mat = option.saveRF2Mat;
                RM.Option.loadRF2Mat = option.loadRF2Mat;
            end % if
            if nargin < 5
                excldrange = [];
            end % if
            % ++++++++++++++++++++++++
            % Initialization
            % ++++++++++++++++++++++++
            % ** check file name
            [filepath,name,ext] = fileparts(filename);
            if isempty(ext), ext = '.RF'; end % if
            if ~isempty(filepath)
                RM.FilePath = [filepath,'\'];
            end % if
            fullname = [name,ext];
            if isempty(RM.FilePath)
                wholename = which(fullname);
            else
                wholename = [RM.FilePath,fullname];
            end % if
            if isempty(wholename)
                error('Cannot find the file %s. \n',fullname)
            end % if
            % -- echo
            fprintf('--> processing the seesion %s ... <--\n',name)
            
            % ** chunk range
            % -- echo
            fprintf('\t--> get chunk range ...')
            RM.ChunkRange = chunkrange;
            % -- echo
            fprintf('done!\n')
            
            % ** excluding block range
            % -- echo
            fprintf('\t--> get exclude data range ...')
            RM.ExcldRange = excldrange;
            % -- echo
            fprintf('done!\n')
            
            % ** read RF2 into Matlab
            RM.readrf2chunks(wholename);
            fprintf('\t--> Acutal chunk range read = [%d,%d] \n',...
                RM.ChunkRange(1),RM.ChunkRange(2));
            % ** stimulus type
            % -- echo
            fprintf('\t--> get stimulus type ... ')
            RM.Stimulus.type = stimtype;
            % -- echo
            fprintf('done!\n')
            
            % ** stimulus time
            switch stimtype
                case {'DIAG','CORNERS'}
            % -- echo
            fprintf('\t--> get stimulus time ...')
            RM.StimTime = RM.getStimTime;
            if length(unique(RM.StimTime)) > 1
                fprintf('\t<!> Note: more than one stimulus time were involved in this session.\t')
            end % if
            % -- echo
            fprintf('done!\n')
            end %switch
            
            % ** fixational grid
            switch stimtype
                case {'DIAG','CORNERS'}
             % -- echo
            fprintf('\t--> get fixation grid ...')
            RM.getFixGrid;
            % -- echo
            fprintf('done!\n')
            end % switch
            
            % ** maximum resolution
            % -- echo
            fprintf('\t--> get maximum resolution ... ')
            RM.getMaxRes;
            % -- echo
            fprintf('done!\n')
            
            % ++++++++++++++++++++++++
            % Eye position and spike times
            % ++++++++++++++++++++++++
            if RM.Option.loadRF2Mat == true
                RM.loadRF2Mat(filename);
            end % if
            % ++++++++++++++++++++++++
            % read MAT structures
            % ++++++++++++++++++++++++
            if RM.Option.loadRF2Mat == false
                % continuous recorded eye movements and corresponding spike
                %   times
                % -- echo
                fprintf('\t--> calculate eye positions and spike times ... ')
                
                RM.getContuSpikeEye;
                
                % -- echo
                fprintf('done!\n')
                
            end % if
            
            % ** number of spikes
            % -- echo
            fprintf('\t--> get number of spikes ... ')
            RM.numSpike = length(RM.SpikeTime);
            % -- echo
            fprintf('done!\n')
            
        end % RF2Mat
    end % methods
    
    % =====================================================================
    % the destructor
    % =====================================================================
    methods
        function delete(RM)
            if RM.Option.saveRF2Mat == true
                RM.saveRF2Mat;
            end % if
        end % delete
    end % destructor method
    
    % =====================================================================
    % Experimental system and processing
    % =====================================================================
    properties (SetAccess = private)
        ParaDisp = struct(...                   % parameters of the display
            'PixMaxRes',640,...   % number of pixels corresponding to max resolution (640?)
            'HorAngle',40,...     % display horizontal angle (deg)
            'VerAngle',30,...     % display vertical angle (deg)
            'HorWidth',640,...    % display horizontal width (pix)
            'VerWidth',480,...    % display vertical width (pix)
            'Gamma',2.171 ...     % harvard.gamma, see rf2analysis.m
            );
        MaxRes      % maximum resolution of the analog signal of the eyes
      
        Fs = 1000;  % sampling frequency (Hz)
    end % properties of experimental system and processing
    
    properties (Abstract)

    end % properties, abstract

    methods (Access = private)
        percent_lum = PercentLuminanceFromGun(RM,gun_value,usergamma,gamma) % luminance
        maxres = getMaxRes(RM)
    end % methods

    methods
        Y = MUnit2Pix(this,X)       % machine unit --> pix
        Y = ABSPix2Arcmin(this,X)   % convert pix --> arcmin
        Y = ABSArcmin2Pix(this,X)   % convert arcmin --> pix
    end % public methods of display

    % =====================================================================
    % Datasets
    % =====================================================================
    properties (SetAccess = private)
        FileName    % RF dataset filename
        FilePath    % path of RF file
        FileLength  % file length (bytes)
        numChunk    % number of chunks in a RF dataset
        nChunkOfInt % number of chunks of interest
        chunks      % chunk structure of imported chunks
                    % .position : begin position of the chunk in RF binary files
                    % .type     : chunk types
                    % .length   : chunk length (Bytes)
                    % .data     : data in chunk (uint8)
        
        ChunkRange  % rnage of chunks corresponding to current stimulus type
                    % = [first, last]
                    
        ExcldRange  % data range in a coutinuous block which is excluded
                    % = [block#,begin time stamps, end time stamps]
    end % properties of Datasets

    methods (Access = private, Hidden)
        readrf2chunks(RM,path_file_name)    % read RF dataset
    end % priviate, hidden methods

    % =====================================================================
    % Visual stimulus and processing
    % =====================================================================
    properties (SetAccess = private)
        FixGrid     % fixational grid (N x 2 = [g_x,g_y]) (getFixGrid)
        FixCorner   % four corner coordinates, 4 x 2 array
                    % = [upper_left_x,upper_lefter_y;
                    % upper_right_x,upper_right_y;
                    % lower_right_x,lower_right_y;
                    % lower_left_x,lower_lefter_y]

        StimTime    % time of fixational cross shown on the display (? should be FixTime)
        knownStimType = {'DANCE', 'FIVEDOT', 'TUNING','HERMANN',... % known type of stimulus
                        'DIAG', 'CORNERS', 'EDGECOMP', 'FREEBAR'};
        
        Stimulus = struct('type',[],'image',[],'data',[],'poly_vert',[]);    % information on stimulus
                    % .type     : type of the stimulus
                    % .image    : rendered stimulus image
                    % .data     : information on current stimulus (parse*)
    end % properties of Visual stimulus and processing
    
    methods
        setFixCorner(RM,corner)         % set FixCorner
        stim_time = getStimTime(RM)     % get stimulus (fix cross) time (?)
        stim_type = getStimType(RM)     % get the type of stimululs
        [grid,corner] = getFixGrid(RM)  % get fixation grid
        [stimulus,poly_vert] = renderStim(this)     % render stimulus
    end % methods
    
    methods (Access = private, Hidden)
        star_image = renderDiag(RM,DiagData)    % render start iamge
        [corners_image,ploy_vert] = renderCorners(RM,CornersData);  % render corners image
        diagdata = parseDiag(RM,diag)           % parse DIAG chunk
        cornersdata = parseCorners(RM,corners)  % parse CORNERS chunk
    end % methods, priviate, hidden

    % =====================================================================
    % Eye positions and processing
    % =====================================================================
    properties (SetAccess = private)
        EyePos      % structure of eye positions in continuous segments (getContuSpikeEye)
                    % eye position is double in arcmin
        EstFix      % estimated fixation positions            
    end % properties of eye positions and processing
    
    methods

    end % public methods
    
    % =====================================================================
    % Spikes
    % =====================================================================
    properties (SetAccess = private)
        SpikeTime   % structure of time stamps of spikes (getContuSpikeEye), corresponding to EyePos
        numSpike    % number of spikes in this session
    end % private access properties
    
    methods
        [EyePos,SpikeTime] = getContuSpikeEye(RM)   % get eye position and spike times
        [newEP,newST] = excludeData(RM)             % exclude bad data
        denEP = denEyePos(this,level,name)          % de-noise eye signals
    end % public methods
    
    methods (Access = private, Hidden)
        saedata = parseSpikeAndEye(RM,sae)  % extracts information from SpikeAndEye single chunk
    end % private, hidden methods
    
    % =====================================================================
    % save / load MAT structures
    % =====================================================================
    properties
        Option = struct(...                     % options for RF2Mat class
            'saveRF2Mat',true,...   % save RF2Mat data into disk file (default = true)
            'loadRF2Mat',true ...   % load previous RF2Mat data, otherwise read RF2 dataset
            );
    end % public properties

    methods
        saveRF2Mat(RM)                  % save RF2Mat class information
        loadRF2Mat(RM,filename)         % load RF2Mat class information
    end % public methods
    
    
end %
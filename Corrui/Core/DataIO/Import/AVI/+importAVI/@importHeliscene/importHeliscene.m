classdef importHeliscene < handle
	% Class IMPORTHELISCENE imports AVI files from Helicopter Scene experiment

	% Copyright 2013 Richard J. Cui. Created: 03/12/2013  5:13:47.882 PM
	% $Revision: 0.1 $  $Date: 03/12/2013  5:13:47.898 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        AVIObj          % AVI object produced by VideoReader
        fps             % frame per second
        
    end % properties
 
    methods 
        function this = importHeliscene(filepath, filename, values)
            % create a VideoReader class
            wholename = [filepath, filesep, filename];    % single file now
            
            tag = values.tag;
            this.AVIObj = VideoReader(wholename, 'Tag', tag);
            this.fps = this.AVIObj.FrameRate;
        end
    end % methods
end % classdef

% [EOF]

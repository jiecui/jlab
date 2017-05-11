classdef importHeliscene < handle
	% Class IMPORTHELISCENE imports EDF files from Helicopter Scene experiment

	% Copyright 2013 Richard J. Cui. Created: Wed 03/13/2013  5:19:22.284 PM
	% $Revision: 0.1 $  $Date: Wed 03/13/2013  5:19:22.284 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        enum        % position and meaning
        edf_samples
        edf_gaze_samples
        samples
        timestamps
        elink_fix
        elink_sacc
        elink_blink
        blinkYesNo
        pupil_samples
        samplerate
        message
        options
        info
        
    end % properties
 
    methods     % constructor
        function this = importHeliscene(filepath, filename, values)
            this.createEnum;
            
            % -- Import the files into matlab variables
            try
                hwait = waitbar(0,'Please wait while EDF Files are read...');
                [dat, warnings] =  edf2mat( fullfile( filepath, char(filename) ) , values );
                isFileGaze = ~isempty(cell2mat(strfind(warnings, 'preferred sample type HREF not available: using GAZE data' ))); % ???
                waitbar( 1/length(filename), hwait);
                close(hwait);
            catch ex
                close(hwait);
                rethrow(ex);
            end
            
            % -- Interpolate blinks in the data
            [samples_val, blinkYesNo_val] = interpolate_blinks2(dat.edf_samples, dat.blinks, values.blink_gap*dat.samplerate/1000, this.enum.samples);
            blinkYesNo_val(end) = [];
            pupil_samples_val = samples_val(1:end-1,[6 7]);
            samples_val = samples_val(:,this.enum.samples.timestamps:this.enum.samples.right_y);
            % if ( ~isempty( db ) )
            %     db.add( sessname, imported_data, {'edf_samples' 'blinkYesNo' 'pupil_samples'} );
            %     imported_data = rmfield(imported_data, {'edf_samples' 'blinkYesNo' 'pupil_samples'} );
            %     imported_data.info.import.variables = {'edf_samples' 'blinkYesNo' 'pupil_samples' 'edf_gaze_samples' };
            % end
            
            % -- Flip necessary components
            if ( values.fliph  )
                samples_val(:, this.enum.samples.left_x)    = -samples_val(:, this.enum.samples.left_x);
                samples_val(:, this.enum.samples.right_x)   = -samples_val(:, this.enum.samples.right_x);
            end
            if ( values.flipv )
                samples_val(:, this.enum.samples.left_y)    = -samples_val(:, this.enum.samples.left_y);
                samples_val(:, this.enum.samples.right_y)   = -samples_val(:, this.enum.samples.right_y);
            end
            
            % -- Convert to DVA ( Degrees of the Visual Angle )
            dva = HREF2dva(samples_val, this.enum.samples);
            
            if sum(isFileGaze) > 0
                % if some file had only GAZE data we need to use another conversion
                lengthFiles = length(dat.edf_samples);
                msgbox('This file has only GAZE data');
                dvaGaze = GAZE2dva(imported_data.samples, this.enum.samples);
                for i=1:length(isFileGaze)
                    % replace "chunks" of data from HREF to GAZE
                    if (isFileGaze(i) && (lengthFiles(i+1) - lengthFiles(i)>1))
                        dva(lengthFiles(i):lengthFiles(i+1),:) = [dvaGaze(lengthFiles(i)+1,:);dvaGaze(lengthFiles(i)+1:lengthFiles(i+1)-1,:);dvaGaze(lengthFiles(i+1)-1,:)];
                    end
                end
            end
            
            % -- commit results
            this.edf_samples = dat.edf_samples;
            this.edf_gaze_samples = dat.edf_gaze_samples;
            
            this.elink_fix = dat.fixations;
            this.elink_sacc = dat.saccades;
            this.elink_blink = dat.blinks;
            this.blinkYesNo = blinkYesNo_val;
            this.pupil_samples = pupil_samples_val;
            
            samples_dva = samples_val(1:end-1, :);
            samples_dva(:, this.enum.samples.left_x:this.enum.samples.right_y) = dva;
            this.samples = samples_dva;
            this.timestamps = dat.edf_samples(:, this.enum.edf_samples.timestamps);
            
            this.samplerate = dat.samplerate;
            this.message = dat.msg;
            this.options = values;
            
            this.info.import.variables = { 'edf_samples' 'blinkYesNo' 'pupil_samples' ...
                'edf_gaze_samples' 'samples' 'samplerate' 'options' };

        end
    end % methods
    
    methods
        enums = createEnum(this)    % create enums
        
    end % methods
end % classdef

% [EOF]

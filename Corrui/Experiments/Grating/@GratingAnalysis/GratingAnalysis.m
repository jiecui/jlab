classdef GratingAnalysis < EyeMovementAnalysis
    % Class GRATINGANALYSIS analyzes the responses during grating testing
    
    % Copyright 2012 Richard J. Cui. Created: Sun 08/05/2012 11:24:32.357 AM
    % $Revision: 0.1 $  $Date: Sun 08/05/2012 11:24:32.357 AM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties
    end
    
    methods ( Static )
        
        function options = get_options( )
            % options = get_options( )
            %
            % Global options to appear in the process dialog. They are
            % common for all the analysis
            %
            % Imput:
            % Output
            %   options: struct with the options
            %
            % Example:
            % options.Window_Backward             = 4000;
            % options.Window_Forward              = 2000;
            % options.Use_Only_Previous_Period    = { {'0','{1}'} };
            %
            
            % this options will be in stage_2_options
            % options.debug_SesEyeAnalysis = { {'{0}','1'} };
            options = [];
        end
        
        % Example
        %   result_dat = ABS_example_analysis( current_tag, name,  S, dat )
        
        % methods
        % ======================
        % For single session 
        % ======================
        % Note: the sequece of the list determines the sequece for the analysis
        result_dat = CellGratingResponse(current_tag, name, S, dat)
        
        % =======================
        % For aggregate analysis
        % =======================

    end
    
end

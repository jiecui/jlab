classdef GfsMSaccAnalysis < EyeMovementAnalysis
    % GFSMSACCANALYSIS Class for the analysis of MS-contrast experiment
    
    % Copyright 2014 Richard J. Cui. Created: Sun 08/03/2014 11:32:19.742 AM
    % $Revision: 0.1 $  $Date: Sun 08/03/2014 11:32:19.742 AM $
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
        
        % methods: Gui interface
        % =======================================
        % For single session (cell) / data block 
        % =======================================
        % Note: the sequece of the list determines the sequece for the analysis
        % result_dat = getSessInfo(current_tag, name,  S, dat)    % data preparation
        
        % =======================
        % For aggregated session
        % =======================
        % result_dat = AggUsaccAmpDisTest(current_tag, name, S, dat)      % cell selection
        
    end
    
    % methods: do analysis
    % --------------------
    methods (Static, Hidden)
        % ======================
        % For single session
        % ======================

    end % methods
    
end

classdef MSaccContrastAnalysis < TuneAnalysis & EyeMovementAnalysis
    % MSACCCONTRASTANALYSIS Class for the analysis of MS-contrast experiment
    
    % Copyright 2011-2014 Richard J. Cui. Created: Sun 11/13/2011  8:43:21.814 PM
    % $Revision: 0.7 $  $Date: Thu 10/23/2014  2:44:56.497 PM $
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
        result_dat = getSessInfo(current_tag, name,  S, dat)    % data preparation
        result_dat = estFixSpot(current_tag, name,  S, dat)     % data preparation
        result_dat = CheckCellFRChange(current_tag, name, S, dat)               % cell selection
        result_dat = UsaccAmplitudeDistributionTest(current_tag, name, S, dat)  % cell selection
        result_dat = do_UsaccRateStepCont(current_tag, name, S, dat)            % ms rate around step-contrast change
        result_dat = do_UsaccTimeStepCont(current_tag, name, S, dat)            % step-contrast response
        result_dat = do_SpikeTimeStepCont(current_tag, name, S, dat)            % step-contrast response
        result_dat = do_SpikeRateStepCont(current_tag, name, S, dat)            % step-contrast response
        result_dat = do_SelectUsacc(current_tag, name, S, dat)                  % selects microsaccades for subsequent analysis
        result_dat = do_SelectSpike(current_tag, sname, S, dat)                 % select spikes for subsequent analysis
        result_dat = StepContrastResponseSorting(current_tag, name, S, dat)     % step-contrast response
        result_dat = UsaccTriggeredContrastResponse(current_tag, name, S, dat)  % MS-triggered response
        result_dat = MSTriggeredContrastResponse(current_tag, name, S, dat)     % Individual cell MS-triggered response at different contrast level
        result_dat = MSTriggeredSpikeSpectrogram(current_tag, sname, S, dat)    % individual cell MS-triggered spike spectrograms at different contrast
        result_dat = SurrogateMSTriggeredResponse(current_tag, name, S, dat)    % MS-triggered response
        result_dat = UsaccTriggered1stPeakAnalysis(current_tag, name, S, dat)   % analysis of 1st peak of MS-triggered response in individual cell
        result_dat = UsaccTriggered2ndPeakAnalysis(current_tag, name, S, dat)   % analysis of 2nd peak of MS-triggered response in individual cell
        result_dat = UsaccTriggered1stTroughAnalysis(current_tag, name, S, dat) % analysis of 1st trough of MS-triggered response in individual cell
        result_dat = EyeMovementAveragedMetrics(current_tag, sname, S, dat)     % get averaged eye characters
        % =======================
        % For aggregated session
        % =======================
        result_dat = AggUsaccAmpDisTest(current_tag, name, S, dat)      % cell selection
        result_dat = AggSCIndex(current_tag, name, S, dat)              % step-contrast response
        result_dat = AggUsaccTriggeredSpikeRateAnalysis(current_tag, name, S, dat)  % MS-triggered response
        result_dat = AggAnaMSTrig1stPeak(current_tag, name, S, dat)     % analysis of 1st peak of MS-triggered response (Pmt1) in aggregated data
        result_dat = AggAnaMSTrig2ndPeak(current_tag, name, S, dat)     % analysis of 2nd peak of MS-triggered response (Pmt2) in aggregated data
        result_dat = AggAnaMSTrig1stTrough(current_tag, name, S, dat)   % analysis of 1st trough of MS-triggered response (Tmt1) in aggregated data        
        result_dat = AggGetFunPairIndex(current_tag, name, S, dat)      % Correlation between MT and SC
        result_dat = AggMSAdaptation(current_tag, name, S, dat)         % MS impact on step-contrast adaptation
        result_dat = AggAnaMSTrigResp(current_tag, name, S, dat)
        result_dat = AggAnaSWJParas(current_tag, sname, S, dat)         % get SWJ parameters for SWJ detection
        result_dat = AggMSContStep(current_tag, name, S, dat)           % Relationship between MS and Contrast steps
        result_dat = AggCellMetrics(current_tag, sname, S, dat)         % Analysis of cell metrics
        result_dat = AggComp2Peaks(current_tag, sname, S, dat)          % compare two peaks
        result_dat = AggAnaMSTrigSpikeSpecgram(current_tag, name, S, dat) % spike spectrogram
        
    end
    
    % methods: do analysis
    % --------------------
    methods (Static, Hidden)
        % ======================
        % For single session
        % ======================
        [fxcr12, fxcr23] = FiringXContrastCondition(NumberCondition, NumberCycle, grattime, ...
            spiketimes, CondInCycle, trialMatrix, enum)
        [uxcr12_start, uxcr12_end, uxcr23_start, uxcr23_end] = UsaccXContrastCondition(NumberCondition, NumberCycle, grattime, ...
            usacc_props, CondInCycle, trialMatrix, enum)
        sorted_trialnum = sortBySpikeRate(fr_yn, cont_onset, intv, numCondition)
        utcresp = UsaccTriggeredContrastResponse_3stages(data, parameters)
        utcresp = UsaccTriggeredContrastResponse_2stages(data, parameters, fr_method, normlz)
    end % methods
    
end

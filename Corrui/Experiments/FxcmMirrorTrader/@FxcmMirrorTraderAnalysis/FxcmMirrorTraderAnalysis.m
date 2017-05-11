classdef FxcmMirrorTraderAnalysis < handle
    % Class FXCMMIRRORTRADERANALYSIS FxcmMirrorTrader experiment analysis
    
    % Copyright 2014-2015 Richard J. Cui. Created: Fri 11/07/2014 11:09:04.541 PM
    % $Revision: 0.3 $  $Date: Mon 02/23/2015  3:31:33.510 PM $
    %
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
        
        % methods
        % ======================
        % For single session 
        % ======================
        % Note: the sequece of the list determines the sequece for the analysis
        result_dat = do_BalanceCurve(current_tag, sname, S, dat)  % accumulated balance curve of realized trades
                
        % =======================
        % For aggregate analysis
        % =======================
        result_dat = AggBalanceCurve(current_tag, sname, S, dat)        % get Balance curve
        result_dat = AggPortfolioAnalysis(current_tag, sname, S, dat)   % analysis of the portolio of the given assests
        result_dat = AggSpecPortAnalysis(current_tag, sname, S, dat)    % analysis of the specified portfolio
        result_dat = AggBuildPortfolio(current_tag, sname, S, dat)      % build the opitmal portfolio from the given n assets
    end
    
end

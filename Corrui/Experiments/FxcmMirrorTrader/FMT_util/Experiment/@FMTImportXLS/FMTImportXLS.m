classdef FMTImportXLS < handle
	% Class FMTIMPORTXLS imports the XLS data from FMT experiment

	% Copyright 2014 Richard J. Cui. Created: Sat 11/08/2014 11:02:23.968 PM
	% $Revision: 0.1 $  $Date:Sat 11/08/2014 11:02:23.968 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
        StrategyProperty
        History

    end % properties
        
    properties (SetAccess = protected)
        WholeName
        MaxNumPos       % max number of positions of this strategy
        HistoryEnum     % column index of MirrorTrader History
        OSType          % operating systme type
    end % properties
 
    methods 
        function this = FMTImportXLS(filepath, filename, values)
            % ----------------
            % class initialize
            % ----------------
            % check OS
            pcstr = computer;
            switch pcstr
                case {'PCWIN', 'PCWIN64'}
                    this.OSType = 'WIN';
                case 'MACI64'
                    this.OSType = 'MAC';
                otherwise
                    warning('FMTIMPORTXLS:FMTImportXLS', 'Untested OS, treated as Windows')
                    this.OSType = 'WIN';
            end % switch
            
            % file info.
            this.WholeName = [filepath, filename];      % single file now
            file_kind = values.file_kind;
            
            % 'history' enum for column variables
            his_enum.ticket     = 1;
            his_enum.strategy   = 2;
            his_enum.symbol     = 3;
            his_enum.buysell    = 4;
            his_enum.amount     = 5;
            his_enum.open_time  = 6;
            his_enum.open_price = 7;
            his_enum.close_time = 8;
            his_enum.close_price = 9;
            his_enum.high_low   = 10;
            his_enum.rollover   = 11;
            his_enum.gross_pl   = 12;
            his_enum.pips       = 13;
            this.HistoryEnum    = his_enum;
            
            % max number of positions
            this.MaxNumPos = values.max_numpos;
            
            switch file_kind
                case 'History'
                    [strategy_prop, history] = FMTImportXLSHistory(this);
                    
            end % switch\file_kind
                       
            this.StrategyProperty = strategy_prop;
            this.History      = history;
        end
        
    end % methods
    
    methods
        [strategy_prop, history] = FMTImportXLSHistory(this)
    end % methods
end % classdef

% [EOF]

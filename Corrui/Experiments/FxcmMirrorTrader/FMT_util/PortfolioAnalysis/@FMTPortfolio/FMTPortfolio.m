classdef FMTPortfolio < Portfolio
	% Class FMTPORTFOLIO general functions for FMT portfolio using mean-variance approach

	% Copyright 2014 Richard J. Cui. Created: Wed 12/31/2014 11:21:00.162 PM
	% $Revision: 0.1 $  $Date: Wed 12/31/2014 11:21:00.206 PM $
	%
	% Sensorimotor Research Group
	% School of Biological and Health System Engineering
	% Arizona State University
	% Tempe, AZ 25287, USA
	%
	% Email: richard.jie.cui@gmail.com

    properties 
        AssetInfo
        MonthlyReturn
        MonRetFts       % fints object of MonthlyReturn
   end % properties
 
    properties
        Property        % properties of aggregated protfolio
        AssetInfoVarNames = { 'AssetIdx' 'AssetName' 'CurrencyPair' 'Strategy' 'MaxNumPos' };
    end % properties
    
    methods 
        function this = FMTPortfolio(property, monret_all, concatneted_vars)
            % Input(s):
            %   property    - properties of aggregated protfolio
            %   monret_all  - aggregated monthly return of the individual assets
            %   concatenated_vars   - index for variables of each assest
            
            this.Property = property;
            this.AssetInfo = getAssetInfo( this );
            this.MonthlyReturn = getMonthlyRet(this, monret_all, concatneted_vars);
            
        end
    end % methods
    
    methods
        p = setPortMV(this, date_start, date_end, pname)    % setup the object
        monret_fts = setMonthlyReturnFts(this, date_start, date_end)
        asset_info = getAssetInfo(this)     % get the information of the assets
        mon_return = getMonthlyRet( this, monret_all, con_vars )    % get structure of monthly return
        
        [this, efport, efrsk, efret] = estEffFrontPortMV(this, num_port_frontier)
        [tport, trsk, tret] = estTargPortByReturn(this, target_ret) % estimate portfolio by targeted return
        [tport, trsk, tret] = estTargPortByRisk(this, target_rsk)   % estimate portfolio by targeted risk
        
    end % methods
    
end % classdef

% [EOF]

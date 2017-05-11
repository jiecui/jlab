classdef GMSImportMAT < handle
	% Class GMSIMPORTMAT imports MAT data from General Flash experiments
    %
    % References:
    %   Wilke, M., Logothetis, N. K., & Leopold, D. A. (2006). Local field
    %   potential reflects perceptual suppression in monkey visual cortex.
    %   Proceedings of the National Academy of Sciences of the United
    %   States of America, 103(46), 17507-17512.
    %
    %   Cui, J., Wilke, M., Logothetis, N. K., Leopold, D. A., & Liang, H.
    %   L. (2009). Visibility states modulate microsaccade rate and
    %   direction. Vision Research, 49(2), 228-236. doi:DOI
    %   10.1016/j.visres.2008.10.015    
    
	% Copyright 2016 Richard J. Cui. Created: Tue 05/10/2016 10:29:57.338 PM
	% $Revision: 0.1 $  $Date: Sun 05/22/2016 11:18:48.754 PM $
	%
	% 3236 E Chandler Blvd Unit 2036
	% Phoenix, AZ 85048, USA
	%
	% Email: richard.jie.cui@gmail.com

    % GFS-MS exp data
    properties 
        ImportedData
    end % properties
 
    
    % experimental parameters
    properties
        
    end % properties
    
    methods 
        function this = GMSImportMAT(pathname, filename, values)
            % import data of GFS microsaccade exp data
            % --------------------------------------------
            gfsms_exp = this.GFSImportMAT(pathname, filename, values);
            this.ImportedData = gfsms_exp;
            
        end
    end % methods/constructor
    
    methods ( Static = true )
        gfsms_exp = GFSImportMAT(pathname, filename, values)
    end % static methods
    
    methods
        
    end % methods
end % classdef

% [EOF]

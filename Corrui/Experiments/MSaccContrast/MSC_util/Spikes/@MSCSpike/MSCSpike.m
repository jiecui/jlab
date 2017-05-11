classdef MSCSpike < NeuSpike
	% Class MSCSPIKE offers basic operations for spike information in MSC experiment

	% Copyright 2013-2014 Richard J. Cui. Created: 04/25/2013  4:05:20.493 PM
	% $Revision: 0.2 $  $Date: Mon 10/20/2014 11:31:05.312 PM $
    %
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com
    
    properties
        
    end % properties
 
    % the constructor
    methods 
        function this = MSCSpike(curr_exp, sname)
            % parse input arguments
            db = curr_exp.db;
            
            % initialize superclasses
            this@NeuSpike(sname, db);
            
            % construction
            this.import_basic_spike_vars;
        end
    end % methods
    
    % other method
    methods

    end 
    
end % classdef

% [EOF]

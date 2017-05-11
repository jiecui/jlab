classdef ExpProcedure < handle
	% Class EXPPROCEDURE parent class of experimental procedure
    %       Basic properties of experiment system, stimulus and trials

	% Copyright 2013 Richard J. Cui. Created: 05/30/2013  7:33:59.043 PM
	% $Revision: 0.1 $  $Date: 05/30/2013  7:33:59.046 PM $
    %
    % Visual Neuroscience Lab (Dr. Martinez-Conde)
    % Barrow Neurological Institute
    % 350 W Thomas Road
    % Phoenix AZ 85013, USA
    %
    % Email: jie@neurocorrleate.com

    properties 
 
    end % properties
 
    methods 
        function this = ExpProcedure()
 
        end
    end % methods
    
    methods (Static)
        exp_trial = Trial()
    end 
    
end % classdef

% [EOF]

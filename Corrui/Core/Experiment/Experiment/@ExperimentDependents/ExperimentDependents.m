classdef ExperimentDependents < handle
	% Class EXPERIMENTDEPENDENTS handle dependents of the experiment
    %
    % Syntax:
    %   this = Dependents()
    %
    % Input(s):
    %   exp         - [obj] EXP object
    %
    % Output(s):
    %   this        - [obj] Dependents object
    %
    % Note:
    %   Dependents of the experiment should be setup before the setup of
    %   the experiment.
    %
    % See also .

	% Copyright 2020 Richard J. Cui. Created: Tue 03/31/2020 10:25:29.586 AM
	% $Revision: 0.1 $  $Date: Tue 03/31/2020 10:25:29.589 AM $
	%
	% 1026 Rocky Creek Dr NE
	% Rochester, MN 55906, USA
	%
	% Email: richard.cui@utoronto.ca

    % =====================================================================
    % properties
    % =====================================================================    
    properties 
        ExpDependents           % [struct] names and locations of dependents
                                % .Name         : name of the dependent
                                % .DependentDir : dependent dir relative to
                                %                 UserDir
    end % properties
 
    % =====================================================================
    % constructor
    % =====================================================================
    methods 
        function this = ExperimentDependents()
            % Construct ElifeGammaOsc constructor
            % ===================================
            
            % Operations during construction
            % ------------------------------
            % Initialize super classes

            % initialize properties
            
            % set information of dependents
            dep = struct([]);            
            this.ExpDependents = dep;
        end
    end % methods

    % =====================================================================
    % methods
    % =====================================================================
    methods
        setup(this) % setup dependents
    end % methods
end % classdef

% [EOF]

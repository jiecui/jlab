classdef LocalFieldPotential < handle
	% Class LOCALFIELDPOTENTIAL data and functions for local field potentials

	% Copyright 2014 Richard J. Cui. Created: Tue 11/25/2014 10:29:27.845 PM
	% $Revision: 0.1 $  $Date: Tue 11/25/2014 10:29:27.847 PM $
	%
	% Sensorimotor Research Group
	% School of Biological and Health System Engineering
	% Arizona State University
	% Tempe, AZ 25287, USA
	%
	% Email: richard.jie.cui@gmail.com

    properties  % Chronux
        ChronuxMTMParams    % default Chronux MTM parameters
        ChronuxMovingWin    % [win width, win step]
    end % properties
    
    properties  %TFTB
        TftbWinName         % smoothing window name
        TftbWinSize         % short-time window length
        TftbNumFreqBins     % number of frequency bins
        TftbTimeInstants    % time instants (normalized frequency unit)
        TftbFPassIdx        % indexes of frequency band pass
    end % properties
    
    properties % HHS
        HhsNumFreqBins      % number of bins in [0 1/2]
        HhsFilterTimeSigma  % time sigma of smooth filter
        HhsFilterTimeSize   % time size of smooth filter
        HhsFilterFreqSigma  % freq sigma of smooth filter
        HhsFilterFreqSize   % freq size of smooth filter
        HhsFPassIdx         % indexes of frequency band pass
    end % properties
 
    methods 
        function this = LocalFieldPotential()
            
            % set defautl params
            initChronuxMTM( this );
            this.ChronuxMovingWin = [1 1];
            
        end
    end % methods
    
    methods
        % ===== spectrum =====
        [pxx, f] = ChronuxMTMSpec(this, lfp)       % Chronux MTM spectrum
        
        % ===== spectrogram =====
        [S, txx, fxx] = ChronuxMTMSpecgram(this, lfp)
        [S, txx, fxx] = TftbTFRrsp(this, lfp)
        [S, txx, fxx] = HilbertHuangSpectrum(this, lfp)
        
        % ===== others =====
        chrxmtm_para = initChronuxMTM( this )       % set default parameters for Chronux MTM
        
    end % methods
    
    methods (Static = true)
        % ===== others =====
        [num_tsteps, num_fpoints] = getChronuxSpecgramSize(N, movingwin, params)
        
    end % methods static
end % classdef

% [EOF]

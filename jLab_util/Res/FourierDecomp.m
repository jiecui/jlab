% FourierDecomp: Fourier decomposition of a 1-dimensional function.  Returns coefficients, 
%                phase angles, amplitudes, and reconstructed functions.
%
%     Usage: [a,b,phase,ampl,xrecon] = FourierDecomp(x,{theta},{nfc},{nharm})
%
%         x =       vector (length n) containing function values to be decomposed.
%         theta =   optional corresponding vector of angle or perimeter-length values,
%                     for function reconstructions.  If not supplied, 'xrecon' is 
%                     returned as null.
%         nfc =     optional number of pairs of Fourier coefficients to be 
%                     returned, to a max of n [default = n].
%         nharm =   optional value indicating the number of Fourier components 
%                     to be plotted for the smoothed outline [default = nfc].
%         ------------------------------------------------------------------------------
%         a,b =     Column vectgors of Fourier coefficients (a0,b0), (a1,b1),..., 
%                     (a(nfc-1),b(nfc-1)), where the a's are the coefficients 
%                     of the cosine terms and the b's are the coefficients 
%                     of the sine terms.
%         phase =   phase-angle coefficients.
%         ampl =    amplitude coefficients.
%

% RE Strauss, 2/6/05; code taken from Fourier().

function [a,b,phase,ampl,xrecon] = FourierDecomp(x,theta,nfc,nharm)
  if (nargin < 1) help FourierDecomp; return; end;
  
  if (nargin < 2) theta = []; end;
  if (nargin < 3) nfc = []; end;
  if (nargin < 4) nharm = []; end;
  
  get_xrecon = 0;
  if (nargout > 4) get_xrecon = 1; end;
  
  x = x(:)';
  n = length(x);
  
  if (isempty(nfc)) nfc = n; end;
  if (isempty(nharm)) nharm = nfc; end;
  
  if (isempty(theta))
    get_xrecon = 0;
  end;

  fx = fft(x);                       % Fourier decomposition

  a = zeros(nfc,1);                         % Allocate output matrices
  b = zeros(nfc,1);

  a(1) = fx(1)/nfc;                         % Fourier coefficients
  if (nfc > 1)
    for k = 2:nfc
      a(k) = 2*real(fx(k-1))/nfc;
      b(k) = -2*imag(fx(k-1))/nfc;
    end;
  end;
  
  phase = atan(b./a);                     % Phase angles
  ampl = sqrt(a.*a + b.*b);               % Amplitudes
  
  xrecon = [];
  if (get_xrecon)
    xrecon = a(1)*ones(size(theta));        % Accumulate harmonics
    for i = 2:nharm                         
      xrecon = xrecon + a(i)*cos(i*theta) + b(i)*sin(i*theta);
    end;
    xrecon = xrecon.*mean(x)./mean(xrecon); % Adjust radius to observed value
  end;
  
  return;
  

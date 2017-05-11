function denEP = denEyePos(this,level,wname)
% DENEYEPOS denoises eye position traces using wavelet analysis
%
% Syntax:
%   denEP = denEyePos(this)
%   denEP = denEyePos(this,level,wname)
% 
% Input(s):
%   this        - ABSSessionAnalysis object
%   level       - decompsotion level
%   wname       - wavelet name (see wavenames.m)
% 
% Output(s):
%   denEP       - denoised EyePos structure
% 
% Example:
%
% See also .

% Copyright 2010 Richard J. Cui. Created: 05/02/2010  6:48:35.065 PM
% $Revision: 0.1 $  $Date: 05/02/2010  6:48:35.140 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% denoise
% -------
if nargin < 2
  level = 5;
end % if
if nargin < 3
    wname = 'db4';
end % if

eye_seg = this.EyePos;
nB = size(eye_seg,1);
wh = waitbar(0,'De-noising signals. Please wait...');
for k = 1:nB
    waitbar(k/nB)
    x_k = double(eye_seg(k).eye_x); % x-position (arcmin)
    y_k = double(eye_seg(k).eye_y); % y-position (arcmin)
    sig = [x_k,y_k];
    
    if ~isempty(sig)
        % centered process
        % ----------------
        % Xmean = mean(sig);
        % csig = sig-Xmean(ones(size(sig,1),1),:);
        %
        % cds = denswt(csig,wname,level);
        % ds = cds+Xmean(ones(size(sig,1),1),:);
        
        ds = denWtXy(sig,wname,level);
        
        % eye_seg(k).eye_x = uint16(ds(:,1));
        % eye_seg(k).eye_y = uint16(ds(:,2));
        eye_seg(k).eye_x = ds(:,1);
        eye_seg(k).eye_y = ds(:,2);

    end %if

end % for
close(wh)

denEP = eye_seg;
% this.EyePos = denEP;

end % function denEyePos

% [EOF]

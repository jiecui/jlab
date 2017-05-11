function [newEP,newST] = excludeData(this)
% EXCLUDEDATA excludes bad data from the blocks
%
% Syntax:
%   [newEP,newST] = excludeData(this)
% 
% Input(s):
%   this        - RF2Mat objects
% 
% Output(s):
%   newEP       - new EyePos structure
%   newSP       - new SpikeTime structure
% 
% Example:
%
% See also .

% Copyright 2010 Richard J. Cui. Created: 05/02/2010  5:47:49.320 PM
% $Revision: 0.1 $  $Date: 05/02/2010  5:47:49.434 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

EyePos = this.EyePos;
SpikeTime = this.SpikeTime;

% =========================================================================
% excluding data
% =========================================================================
excldrange = this.ExcldRange;
nEx = size(excldrange,1);   % numeber of blocks to be checked
spk_k = SpikeTime;
for k = 1:nEx
    block_k = excldrange(k,1);
    ex_t0 = excldrange(k,2);
    ex_t1 = excldrange(k,3);
    
    x_k = EyePos(block_k).eye_x;
    y_k = EyePos(block_k).eye_y;
    t_k = EyePos(block_k).time;
    
    % eye position and time
    t_k_idx = t_k >= ex_t0 & t_k <= ex_t1;
    xx_k = x_k(~t_k_idx);
    yy_k = y_k(~t_k_idx);
    tt_k = t_k(~t_k_idx);
    
    EyePos(block_k).eye_x = xx_k;
    EyePos(block_k).eye_y = yy_k;
    EyePos(block_k).time  = tt_k;
    
    % spike time
    spk_k_idx = spk_k >= ex_t0 & spk_k <= ex_t1;
    ss_k = spk_k(~spk_k_idx);
    spk_k = ss_k;
    
end % for

% =========================================================================
% output
% =========================================================================
newEP = EyePos;
newST = SpikeTime;

this.EyePos = newEP;
this.SpikeTime = newST;

end % function excludeData

% [EOF]

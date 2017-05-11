function [blink,yorn]  = CoilBlinkYesNo(x,y)
% COILBLINKYESNO attempts to identify blink events from signals of search
%       coils. This algorithm assumes that blinks happen during fixation,
%       and sampling frequency is 1 kHz.
% 
% Syntax:
%   [blink,yorn]  = CoilBlinkYesNo(x,y)
% 
% Input(s)
%   x       - x position of the eye (unit arcmin)
%   y       - y position (arcmin)
% 
% Output(s)
%   blink   - m x 2 matrix = [start,end], where m is the number of blinks detected.
%   yorn    - blink yes or no logic. = 1 is yes.
% 
% Example
% 
% See also lohi2idx.

% adapted from get_coil_blinkYesNo.m
% 
% Copyright 2010 Richard J. Cui. Created: Fri 04/30/2010  8:45:20 AM
% $Revision: 0.1 $  $Date: Fri 04/30/2010  8:45:20 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =================
% detect blinks
% =================
x = x(:); x = x/60;     % change to dva
y = y(:); y = y/60;

% paras
v_thres = 3/1000;
blinkGap = 50;
% wname = 'db4';
% level = 5;
vRange = 100;

% calculate smoothed velocity
smooth_param1 = 31;
diff_x = diff([x(1); x]);
diff_y = diff([y(1); y]);
diff_x = newboxcar(diff_x, smooth_param1);
diff_y = newboxcar(diff_y, smooth_param1);
vel = sqrt(diff_x.^2 + diff_y.^2);

% detect fast movements
v = vel > v_thres;

% detect when the eye velocity was over the threshold during 200ms at least
% 70% of the time
blinkYesNo1 = newboxcar(double(v),200);
blinkYesNo2 = blinkYesNo1 > 0.7; %?

% add some space at the begining and the end of the blink
loidx	= max( find( diff(blinkYesNo2) > 0 ) - blinkGap , 1);   
hiidx	= min( find( diff(blinkYesNo2) < 0 ) + blinkGap, length(blinkYesNo2));


% if there is nan at the end add the last low
if ( blinkYesNo2(end) == 1 )
	hiidx(end+1) = length(blinkYesNo2);
end
% if there is nan at the begining add the first hi
if ( blinkYesNo2(1) == 1 )
	loidx = [1;loidx];
end

% if there is no blink detected, return
% ====================
if isempty(loidx)
    blink = [];
    yorn = zeros(size(x));
    return
end % if
% ====================

% check overlapping
% ------------------
nblink = length(loidx);     % number of blinks
if nblink > 1
    % xx = zeros(size(x));
    % xx(lohi2idx(loidx,hiidx)) = 1;
    xx = be2yn(loidx,hiidx,length(x));
    %     yy = diff(xx);
    %     low_idx = yy == 1;
    %     hig_idx = yy == -1;
    %     loidx = find(low_idx);
    %     hiidx = find(hig_idx);
    %     if xx(1) == 1
    %         loidx = [1;loidx];
    %     elseif xx(end) == 1
    %         hiidx = [hiidx;length(x)];
    %     end %if
    [loidx,hiidx] = yn2be(xx);
end %if

% ===================================
% adjust the start and end points of the blinks
% ===================================
% the idea is that we assume from the start point the eye will monotonously
% moves close to the vertex, and monotonously moves away from it until the
% end point. We also assume that the start and end points will be around
% (defined below) the estimated end points descirbed above 

% loidx - index of blink start points
% hiidx - index of blink end points
nblink = length(loidx);     % number of blinks
startp = zeros(size(loidx));
endp   = startp;
for k = 1:nblink
    lo_k = loidx(k);
    hi_k = hiidx(k);
   
    vel_k = vel(lo_k:hi_k);   % velocity of kth blink
    % vel_k = denswt(vel_k,wname,level);  % smoothed
    vel_k(vel_k < 0) = 0;
    
    x_k = x(lo_k:hi_k);       % x-position
    y_k = y(lo_k:hi_k);       % y-position
    blink_k = [x_k,y_k];
    start_k = blink_k(1,:);     % start point
    % end_k = blink_k(end,:);     % end point
    
    % (1) distance between the start point and eye position
    S = start_k(ones(size(blink_k,1),1),:);
    d = blink_k-S;
    dis = hypot(d(:,1),d(:,2));
    % dis = denswt(dis,wname,level);  % smoothed
    dis(dis < 0) = 0;
    
    [~,maxd_pos] = max(dis);    % find the position of max dis
    maxd_pos = maxd_pos(1);
    
    % (2) adjust the start point
    close_eye = dis(1:maxd_pos);    % dis of close eye lids
    [~,min_ceye] = min(close_eye);
    min_ceye = min_ceye(1);
    % -- set speed search range
    v0 = min_ceye-vRange;
    if v0 < 1, v0 = 1; end
    v1 = min_ceye+vRange;
    if v1 > maxd_pos, v1 = maxd_pos; end
    % -- search minimum velocity
    v_seg = vel_k(v0:v1);
    [~,minv_idx] = min(v_seg);
    minv_idx = minv_idx(1);
    sp_k = v0+minv_idx-1;
    startp(k) = lo_k+sp_k-1;
    
    % (3) adjust the end point
    open_eye = dis(maxd_pos:end);   % dis of open eye lids
    [~,min_oeye] = min(open_eye);
    min_oeye = min_oeye(end);   % choose the right one
    % -- set speed search range
    v0 = min_oeye-vRange;
    if v0 < 1, v0 = 1; end
    v0 = v0+maxd_pos-1;
    v1 = min_oeye+vRange;
    if v1 > length(open_eye), v1 = length(open_eye); end
    v1 = v1+maxd_pos-1;
    % -- search minimum velocity
    v_seg = vel_k(v0:v1);
    [~,minv_idx] = min(v_seg);
    minv_idx = minv_idx(end);
    ep_k = v0+minv_idx-1;
    endp(k) = lo_k+ep_k-1;
end % for 

% =========================================================================
% output
% =========================================================================
blink = [startp,endp];
% yorn = zeros(size(x));
% % yorn = zeros(length(blinkYesNo2),1);
% yorn(lohi2idx(startp,endp)) = 1;
yorn = be2yn(startp,endp,length(x));

end
 
% [EOF]

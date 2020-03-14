function rasterplot(times,numtrials,triallen, varargin)
% RASTERPLOT.M Display spike rasters.
%   RASTERPLOT(T,N,L) Plots the rasters of spiketimes (T in samples) for N trials, each of length
%   L samples, Sampling rate = 1kHz. Spiketimes are hashed by the trial length.
%
%   RASTERPLOT(T,N,L,H) Plots the rasters in the axis handle H
%
%   RASTERPLOT(T,N,L,H,FS) Plots the rasters in the axis handle H. Uses sampling rate of FS (Hz)
%
%   RASTERPLOT(T, N, L, H, FS, SHOWTIMESCALE, ZTIME)
% 
%   Example:
%          t=[10 250 9000 1300,1600,2405,2900];
%          rasterplot(t,3,1000)
%
%
% Rajiv Narayan
% askrajiv@gmail.com
% Boston University, Boston, MA

% Revised by Richard J. Cui.: Tue 06/05/2012  4:44:40.708 PM
% $Revision: 0.2 $  $Date: Tue 10/09/2012  4:06:09.993 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com



%%%%%%%%%%%%%% Plot variables %%%%%%%%%%%%%%
plotwidth=1;     % spike thickness
plotcolor='k';   % spike color
trialgap=1.5;    % distance between trials
defaultfs=1000;  % default sampling rate
showlabels=1;    % display x and y labels
ztime = 1;       % poisition where time is set as zero

% parse inputs
% ---------------
fs = defaultfs;
showtimescale = true;

if nargin == 3
    figure
    hresp = gca;
end % if

if nargin > 3
    hresp = varargin{1};
    if (~ishandle(hresp))
        error('Invalid handle');
    end
end % if

if nargin > 4
    fs = varargin{2};
end % if

if nargin > 5
    showtimescale = varargin{3};
end % if

if nargin > 6
    ztime = varargin{4};
end % fif

if nargin > 7
    error('Invalid Arguments')
end % if

% plot spikes raster
trials=ceil(times/triallen);
reltimes=mod(times,triallen);
reltimes(~reltimes)=triallen;
numspikes=length(times);
xx=ones(3*numspikes,1)*nan;
yy=ones(3*numspikes,1)*nan;

yy(1:3:3*numspikes)=(trials-1)*trialgap;
yy(2:3:3*numspikes)=yy(1:3:3*numspikes)+1;

%scale the time axis to ms
xx(1:3:3*numspikes)=reltimes*1000/fs;
xx(2:3:3*numspikes)=reltimes*1000/fs;
xx = xx - ztime;
xlim=[1,triallen*1000/fs] - ztime;

axes(hresp);
plot(xx, yy, plotcolor, 'linewidth',plotwidth);
axis ([xlim,0,(numtrials)*1.5]);

% x-axis
if showtimescale
    set(hresp, 'tickdir','out');
else
    set(hresp,'xtick',[]);
end

% y-axis
[ytick, yticklabel] = findYTickLabel(hresp, yy, trials);
set(hresp, 'YTick', ytick, 'YTickLabel', yticklabel)
set(hresp, 'Box', 'off')

if showlabels
    xlabel('Time(ms)');
    ylabel('Trials');
end

end % funciton

% ========================================================================
% subroutines
% ========================================================================
function [ytick, ylabel] = findYTickLabel(ha, tickpos, labvec)
%   ha          - axis handle
%   tickpos     - tick positions vector
%   labvec      - label vectors

utickpos = unique(tickpos(1:3:end));
ulabvec = unique(labvec);

curtick = get(ha, 'YTick');
N = length(curtick);
ytick = zeros(1, N);
ylabel = zeros(1, N);

for k = 1:N
    
    ct_k = curtick(k);
    [~, idx] = min(abs(ct_k -utickpos));
    ytick(k) = utickpos(idx);
    ylabel(k) = ulabvec(idx);
    
end % for

ytick = unique(ytick);
ylabel = unique(ylabel);

end % function

% [EOF]

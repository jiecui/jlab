function hh = barstderror(b, errdata, colr, barlegend) 

if nargin<2
   error('Must provide both mean and standard error data1');
   return
end
if nargin==2
   colr = 'g';
end
if nargin==3
   barlegend = [];
end
if size(b)~=size(errdata)
   error('Both mean and standard error data must be same size!');
   return
end

% condition data
borig = b;
for i=1:size(b,1)
   for j=1:size(b,2)
      if b(i,j)==0 | isnan(b(i,j))
         b(i,j)=0.0001;
      end
   end
end

h = bar('v6',borig, 'grouped');
if ~isempty(barlegend)
   legend(h,barlegend);
end
xdata = get(h, 'XData');
ydata = get(h ,'YData');

% Determine number of bars, and find each center
sizz = size(b);
bargroups = sizz(1);
barmembers = sizz(2);
nb = sizz(1)*sizz(2);
xb = [];
yb = [];
center = [];
try
   for i = 1:barmembers,
      if barmembers==1
         % only one bar per group, so cell indexing won't work
         xb = xdata;
      else
         xb = xdata{i,1};
      end
      for j = 1:bargroups,
         center = [center mean(xb(2:3,j))];
      end; 
   end;
catch
   % cell indexing didn't work, so must be just an array
   xb = xdata;
   yb = ydata;
   for j = 1:bargroups*barmembers,
      center = [center mean(xb(2:3,j))];
   end; 
end


% To find the center of each bar - need to look at the output vectors xb, yb
% find where yb is non-zero - for each bar there is a pair of non-zero yb values.
% The center of these values is the middle of the bar

%nz = find(yb);
%for i = 1:nb,
%   xright = xb(nz(i*2));
%   xleft = xb(nz((i*2)-1));
%   center(i) = (xright-xleft)/2 + xleft;
%end;

% To place the error bars - use the following:
hold_state = ishold;
hold on;
h2=errorbar('v6',center, b, errdata);
set(h2(1),'linewidth',1);            % This changes the thickness of the errorbars
set(h2(1),'color',colr);              % This changes the color of the errorbars
set(h2(2),'linestyle','none');       % This removes the connecting
if ~hold_state, hold off; end

if nargout>0, hh = h; end
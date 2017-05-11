function H = plot_polardist( varargin )
% H = plot_polardist( [ax], dirs)
%
% plots a polar distribution of directions
%
% plot_polardist( ax, ...)
%       plots in the given axis
%
% Parameters:
%   - dirs: directions to use for the distribution
%
% Output:
%   - H: handles of the lines

% Last modified by RJC on Tue 12/18/2012  1:11:33.708 PM

p = check_parameters( varargin{:} );
P = p.S;

% S.Axis='on';
% S.Border='on';
% S.Grid='on';
% S.RLimit=[0 1];
% S.TLimit=[0 2*pi];
% S.RTickUnits='';
% S.TTickScale='degrees';
% S.TDirection='ccw';
% S.TZeroDirection='east';
% 
% S.BackgroundColor=get(0,'defaultaxescolor');
% S.BorderColor=[0 0 0];
% S.FontName=get(0,'defaultaxesfontname');
% S.FontSize=get(0,'defaultaxesfontsize');
% S.FontWeight=get(0,'defaultaxesfontweight');
% S.TickLength=0.02;
% 
% S.RGridColor=get(0,'defaultaxesycolor');
% S.RGridLineStyle=get(0,'defaultaxesgridlinestyle');
% S.RGridLineWidth=get(0,'defaultaxeslinewidth');
% S.RGridVisible='on';
% S.RTickOffset=0.04;
% S.RTickLabel='0|0.5|1.0';
% S.RTickLabelHalign='center';
% S.RTickLabelValign='middle';
% S.RTickValue=[0 .5 1];
% S.RTickVisible='on';
% 
% S.TGridColor=get(0,'defaultaxesxcolor');
% S.TGridVisible='on';
% S.TGridLineStyle=get(0,'defaultaxesgridlinestyle');
% S.TGridLineWidth=get(0,'defaultaxeslinewidth');
% S.TTickOffset=0.08;
% S.TTickDirection='in';
% S.TTickLabel='';
% S.TTickSign='+-';
% S.TTickValue=0:15:359;
% S.TTickVisible='on';

num_bins = round(P.NumBin);
pdf_flag = P.pdf_flag;
S.Style = P.Style;
S.RTickAngle = P.RTickAngle;
S.RTickLabelVisible = P.RTickLabelVisible;
S.TTickDelta = P.TTickDelta;
S.TTickLabelVisible = P.TTickLabelVisible;
if P.RLimit_flag
    S.RLimit = P.RLimit;
end % if
S.FontSize = P.FontSize;

if (~isfield(p,'ax') )
    % if no axes is given create a new one in a new figure
    figure
    p.ax = axes;
end

dirs = p.data;

global colors_array;

if isempty(colors_array)
    [~, colors_array] = get_nice_colors();
end

if ( ~iscell( dirs) )
	dirs = {dirs};
end
ishold = 0;

numbin  = length(dirs);
for i = 1:numbin
	
	thta = dirs{i} * (pi/180);
	if ( ~isempty( thta) )

		% it is necessary to make two times the number of binns
        num = 2 * num_bins;
        
        bins = 0:2*pi/num:2*pi;
		n = histc( thta, bins );
		n(end) = [];
%         n = 100*n/sum(n(:));

		nn = zeros( num/2, 1);
		nn(2:end) = n(2:2:end-1)+n(3:2:end-1);
		nn(1) = n(end)+n(1);

		n = [nn;nn(1)];
        
        if pdf_flag
            binwidth = 2 / pi / numbin;
            n = n / sum(n) / binwidth;     % rjc
        end % if
       

		x = 0:4*pi/num:2*pi;


		% histrho = zeros(length(rho)*2,1);
		% histthta = zeros(length(thta)*2,1);
		% histrho(2:2:end)=rho;
		% histthta(2:2:end)=thta;

% 		H = mmpolar(x,n,'Style','compass', 'FontSize', 14, 'TTickDelta' , 30 , 'RTickAngle', 20 ,'TTickDelta',45,'RTickOffset',.08,'RTickLabelHalign','left');
% 		H = mmpolar(x,n,'Style','compass', 'FontSize', 14, ...
%             'Border','on', 'FontSize', 8,...
%             'TTickDelta' , 90 ,'TTickLabelVisible', 'on', 'TTickVisible', 'on', ...
%             'RTickAngle', 135, 'RTickVisible', 'on','RTickLabelVisible', 'on','RGridVisible','on','RGridLineWidth',0.5);		
        
        H = mmpolar(x,n,S);
		if ( ~ishold)
			hold
			ishold = 1;
		end
	end
end

for i=1:length(H)
    set( H(i), 'color', colors_array(i,:), 'linewidth',2);
end

end % function


function p = check_parameters( varargin )

if ( nargin >=1)
    p = inputParser;   % Create an instance of the class.
    
    % 1st
    if ( ishandle( varargin{1} ) )
        p.addRequired('ax', @ishandle);
    end
    % 2nd
    p.addRequired('data', @(x)(isnumeric(x)&& length(x)>1)||iscell(x));
    % 3rd
    p.addRequired('S', @isstruct);
    
    p.StructExpand = true;
    p.parse(varargin{:});
    p = p.Results;
else
    throw('at least one parameter are necessary');
end

end % function
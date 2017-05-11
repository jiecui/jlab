% interface for creating mvn data from mvngrps


figure('Color',[0.8 0.8 0.8], ...
    'Name','Harmonic reconstructor',...
    'Units','normalized');	
%initial values
n=3;
k=1;
betw=0;
r=0;

[a,b,phase,ampl] =pfourier(crds)
tnc=size(a,1)

s='Value=get(gcbo,''Value'');nc=round(tnc*Value);uicontrol(''Units'',''normalized'',''Position'',[ 0.72 -0.0078 .1152 0.0625 ],''String'',strcat(''n='',''....'',num2str(nc)),''Style'',''text'');cla;[a,b,phase,ampl]=pfourier(crds,{},{},{},nc,{});';

% correlation r=
uicontrol('Units','normalized',...
    'Max',1,  'Min',0,  ...
	'Callback',s,...
	'Position',[ 0.279296875 0 0.416015625 0.0546875 ], ...
	'Style','slider', ...
	'Tag','number of harmonics', ...
	'Value',0);
uicontrol('Units','normalized',...
	'Position',[ 0.72 -0.0078 .1152 0.0625 ], ...
	'String',strcat('n=','... ',num2str(r)),...
	'Style','text', ...
	'Tag','none');	

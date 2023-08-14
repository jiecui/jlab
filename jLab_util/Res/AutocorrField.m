% AutocorrField: Generate a 1D, 2D or 3D random autocorrelated field of cell values. 
%                Returns field values in the range 0-1.
%                The field is periodic, wrapping at all opposite edges.
%
%     Usage: field = AutocorrField({cells},{corrwidth},{model},{doplots})
%
%         cells =     optional vector containing the numbers of cells in 1-3 
%                       dimensions.  Dimensionality of the output field
%                       is the length of 'cells'.  (default = [64,64])
%         corrwidth = optional 2-element vector containing the kernel widths in 1-3 
%                       dimensions.  See 'model' for interpretations.  A scalar is 
%                       interpreted as the kernal width in all dimensions
%                       [default = cells/6].
%         model =     optional scalar indicating kermal model:
%                       1 = Gaussian (corrwidth = standard deviation) [default];
%                       2 = exponential (corrwidth = standard deviation);
%                       3 = spherical (corrwidth = radius).
%         doplots =   optional boolean value indicating whether plots are to be produced:
%                       0 = no plots [default];
%                       1 = field plot produced;
%                       2 = kernal and field plots produced.
%         ------------------------------------------------------------------------------
%         field =     1-3 dimensional matrix of cell values.
%

% RE Strauss, 3/17/05, modified from function randomfield.m by OA Cirpka.

function field = AutocorrField(cells,corrwidth,model,doplots)
  if (nargin < 1) cells = []; end;
  if (nargin < 2) corrwidth = []; end;
  if (nargin < 3) model = []; end;
  if (nargin < 4) doplots = []; end;
  
  if (isempty(cells)) cells = [64 64]; end;           % Default numbers of cells
  
  cells = cells(:)';
  dimen = length(cells);                              % Number of dimensions
  
  if (isempty(model))     model = 1; end;             % Kernel model
  if (isempty(corrwidth)) corrwidth = cells/6; end;   % Kernel width
  if (isempty(doplots))   doplots = 0; end;
  
  if (dimen<1 | dimen>3)
    error('  AutocorrField: invalid number of dimension.');
  end;
  if (length(corrwidth)~=dimen)
    corrwidth = corrwidth(1)*ones(1,dimen);
  end;

  spacing = [1 1 1];                  % Grid spacing
  ang = [0 0 0];                      % Orientation of 3D plot
%   maptype = 'gray';                 % Monochrome colormap
  maptype = 'jet';                    % Color colormap

  [RYY,X,Y,Z,Rotmat] = CalcCorr(cells,spacing,corrwidth,ang,dimen,model);
  if (doplots>1)
    PlotCorr(X,Y,Z,RYY,Rotmat,cells,spacing,corrwidth,dimen,maptype);
  end;

  ntot = prod(cells(1:dimen));
  n_real = 1;
  SYY = fftn(fftshift(RYY))/ntot;     % Fourier transform giving power spectrum of field
  SYY = abs(SYY);                     % Remove imaginary artifacts
  SYY(1,1,1)=0;

  cellsize = cells(1:dimen);          % cellsize is cells with the first two entries switched
  if (dimen > 1)
      cellsize(1:2)=[cells(2) cells(1)];
  else
      cellsize = [1,cells(1)];
  end;
  
  % Generate a field of random real numbers, transform the field into the spectral domain,
  % and evaluate the corresponding phase-spectrum.  This random phase-spectrum and the 
  % given power spectrum define the Fourier transform of the random autocorrelated field.

  field=sqrt(SYY).*exp(i*angle(fftn(rand(cellsize))));
  field=real(ifftn(field*ntot));    % Backtransformation into the physical coordinates
  
  maxval = max(max(max(field)));    % Standardize to range 0-1
  minval = min(min(min(field)));
  range = maxval-minval;
  field = (field-minval)/range;
  
  if (doplots)
    PlotField(field,cells,spacing,ang,dimen,RYY,X,Y,Z,Rotmat,maptype);
  end;

  if (dimen==2 & cells(1)~=cells(2))        % Re-switch first two dimensions
    field = field';
  elseif (dimen==3 & cells(1)~=cells(2))
    newfield = zeros(cells);
    for i3 = 1:cells(3)
      f = field(:,:,i3);
      newfield(:,:,i3) = f';
    end;
    field = newfield;
  end;
  
  return;
  
% ---------------------------------------------------------------------------------

% CalcCorr: calculates the correlation kernel function

function [RYY,X,Y,Z,Rotmat] = CalcCorr(cells,spacing,corrwidth,ang,dimen,model)
  ntot=prod(cells);
  Y = [];
  Z = [];
  Rotmat = [];

  switch (dimen)                          % Define the physical grid
    case 1,                                  % 1-D fields
      X=-cells(1)/2*spacing(1):spacing(1):(cells(1)-1)/2*spacing(1); % Grid in Physical Coordinates
      H=abs(X/corrwidth(1));

    case 2,                                   % Grid in 2D physical coordinates
      ang2=ang/180*pi;
      [X,Y]=meshgrid(-cells(1)/2*spacing(1):spacing(1):(cells(1)-1)/2*spacing(1),...
                     -cells(2)/2*spacing(2):spacing(2):(cells(2)-1)/2*spacing(2));
      X2= cos(ang2(1))*X + sin(ang2(1))*Y;      % Rotate into longitudinal/transverse crds
      Y2=-sin(ang2(1))*X + cos(ang2(1))*Y;
      H=sqrt((X2/corrwidth(1)).^2+(Y2/corrwidth(2)).^2);
    
    case 3,                                   % Grid in 3D physical coordinates
      [X,Y,Z]=meshgrid(-cells(1)/2*spacing(1):spacing(1):(cells(1)-1)/2*spacing(1),...  
                       -cells(2)/2*spacing(2):spacing(2):(cells(2)-1)/2*spacing(2),...
                       -cells(3)/2*spacing(3):spacing(3):(cells(3)-1)/2*spacing(3));
      ang2=ang/180*pi;                          % Rotate into longitudinal/transverse crds
      Rotmat= ...
          [ cos(ang2(1)) sin(ang2(1)) 0; ...
           -sin(ang2(1)) cos(ang2(1)) 0; ...
            0         0         1] * ...
          [ cos(ang2(2)) 0         sin(ang2(2));...
            0         1         0;...
           -sin(ang2(2)) 0         cos(ang2(2))] * ...
          [ 1         0         0        ;...
            0         cos(ang2(3)) sin(ang2(3));
            0        -sin(ang2(3)) cos(ang2(3))];
   
      X2= Rotmat(1,1)*X + Rotmat(1,2)*Y + Rotmat(1,3)*Z;
      Y2= Rotmat(2,1)*X + Rotmat(2,2)*Y + Rotmat(2,3)*Z;
      Z2= Rotmat(3,1)*X + Rotmat(3,2)*Y + Rotmat(3,3)*Z;
  
      H=sqrt((X2/corrwidth(1)).^2+(Y2/corrwidth(2)).^2+(Z2/corrwidth(3)).^2);
  end;

  switch (model)                          % Covariance matrix
    case 1,
        RYY=exp(-H.^2);                     % Gaussian
    case 2,
        RYY=exp(-abs(H));                   % Exponential
    case 3,
        RYY=(1-1.5*H+0.5*H.^3);             % Spherical
        RYY(H>1)=0;
  end;
  
  return;

% ---------------------------------------------------------------------------------

% PlotCorr: plot the correlation kernel function.

function PlotCorr(X,Y,Z,RYY,Rotmat,cells,spacing,corrwidth,dimen,maptype)
  colormap(maptype);
  
  switch (dimen)
    case 1,
      plot([X -X(1)],[RYY RYY(1)]);
      xlabel('X');
      ylabel('f(X)');
      xlim([-cells(1)*spacing(1)/2,(cells(1)-1)*spacing(1)/2]);
      drawnow;
      
    case 2,
      pcolor([X -X(:,1);X(1,:) -X(1,1)],[Y Y(:,1);-Y(1,:) -Y(1,1)],...
             [RYY RYY(:,1);RYY(1,:) RYY(1,1)]);
      shading interp;
      xlim([-cells(1)*spacing(1)/2,(cells(1)-1)*spacing(1)/2]);
      ylim([-cells(2)*spacing(2)/2,(cells(2)-1)*spacing(2)/2]);
      box on;
      set(gca,'fontsize',10,'layer','top','clim',[0 1]);
      daspect([1 1 1]);
      xlabel('X');
      ylabel('Y');
      cb = colorbar;
      set(cb,'fontsize',10);
      drawnow;
      
    case 3,
      slice(X,Y,Z,RYY,0,0,0);
      line([-cells(1)*spacing(1)/2,cells(1)*spacing(1)/2],[0 0],[0 0],'color','w','linewidth',2);
      line([0 0],[-cells(2)*spacing(2)/2,cells(2)*spacing(2)/2],[0 0],'color','w','linewidth',2);
      line([0 0],[0 0],[-cells(3)*spacing(3)/2,cells(3)*spacing(3)/2],'color','w','linewidth',2);
      aha=Rotmat(1,:)*log(5)*corrwidth(1);
      line([-1 1]* aha(1),[-1 1]* aha(2),[-1 1]* aha(3),'color','w','linewidth',2); 
      aha=Rotmat(2,:)*log(5)*corrwidth(2);
      line([-1 1]* aha(1),[-1 1]* aha(2),[-1 1]* aha(3),'color','w','linewidth',2); 
      aha=Rotmat(3,:)*log(5)*corrwidth(3);
      line([-1 1]* aha(1),[-1 1]* aha(2),[-1 1]* aha(3),'color','w','linewidth',2); 
      daspect([1 1 1]);
      xlim([-cells(1)*spacing(1)/2,cells(1)*spacing(1)/2]);
      ylim([-cells(2)*spacing(2)/2,cells(2)*spacing(2)/2]);
      zlim([-cells(3)*spacing(3)/2,cells(3)*spacing(3)/2]);
      box on;
      set(gca,'xgrid','on','ygrid','on','zgrid','on','fontsize',10,'clim',[0 1]);
      daspect([1 1 1]);
      xlabel('X');
      ylabel('Y');
      zlabel('Z');
      shading interp;
      cb = colorbar;
      set(cb,'fontsize',10);
      drawnow;
  end;
  title('Correlation kernel');
  
  return;

% ---------------------------------------------------------------------------------
% PlotField: plot resultant field

function PlotField(field,cells,spacing,ang,dimen,RYY,X,Y,Z,Rotmat,maptype)
  figure;
  colormap(maptype);
  
  switch (dimen)
  case 1,
    plot([X -X(1)],[field field(1)]);
    xlabel('X');
    ylabel('f(X)');
    xlim([-cells(1)*spacing(1)/2,cells(1)*spacing(1)/2]);
    drawnow;
    
  case 2,
    pcolor([X -X(:,1);X(1,:) -X(1,1)],[Y Y(:,1);-Y(1,:) -Y(1,1)],...
           [field field(:,1);field(1,:) field(1,1)]);
    shading flat;
    xlim([-cells(1)*spacing(1)/2, cells(1)*spacing(1)/2]);
    ylim([-cells(2)*spacing(2)/2, cells(2)*spacing(2)/2]);
    box on;
    set(gca,'fontsize',10,'layer','top');
    daspect([1 1 1]);
    xlabel('X');
    ylabel('Y');
    cb = colorbar;
    set(cb,'fontsize',10);
    drawnow;
    
  case 3,
    slice(X,Y,Z,field,0,0,0);
    line([-cells(1)*spacing(1)/2,cells(1)*spacing(1)/2],[0 0],[0 0],'color','k','linewidth',2);
    line([0 0],[-cells(2)*spacing(2)/2,cells(2)*spacing(2)/2],[0 0],'color','k','linewidth',2);
    line([0 0],[0 0],[-cells(3)*spacing(3)/2,cells(3)*spacing(3)/2],'color','k','linewidth',2);
    daspect([1 1 1]);
    xlim([-cells(1)*spacing(1)/2, cells(1)*spacing(1)/2]);
    ylim([-cells(2)*spacing(2)/2, cells(2)*spacing(2)/2]);
    zlim([-cells(3)*spacing(3)/2, cells(3)*spacing(3)/2]);
    box on;
    set(gca,'xgrid','on','ygrid','on','zgrid','on','fontsize',10,'clim',[0,1]);
    daspect([1 1 1]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    shading flat;
    cb = colorbar;
    set(cb,'fontsize',10);
    drawnow;
  end;
  return;

function dva=GAZE2dva(rsasc, enum)
% GAZE2dva calculate the degr visual angle given output from eyelink in GAZE format takes the matrix from an asc export file from eyelink
%enum: should contain the fields left_x, left_y, right_x, right_y


TREMOR = 0;
if (TREMOR)
    warning('using TREMOR parameters for gaze to degrees conversion');
    %-- horizontal and vertical resolutions of the screen (pixels)
    hor_res		= 1024;
    vert_res	= 768;
    %-- width and height of the screens (cms)
    screen_width	= 41;
    screen_height	= 31;

    %-- distance of the eye to the screen
    dist = 43;
else
    %-- horizontal and vertical resolutions of the screen (pixels)
    hor_res		= 1024;
    vert_res	= 768;
    %-- width and height of the screens (cms)
    screen_width	= 40; % tremor 41
    screen_height	= 30; % tremor 31

    %-- distance of the eye to the screen
    dist = 57; % tremor 43
end


% First left eye
x = rsasc(1:end-1,enum.left_x);
y = rsasc(1:end-1,enum.left_y);


x_left = rad2deg( atan( ((x-hor_res/2) *  screen_width/hor_res )  / dist) );
y_left = rad2deg( atan( ((y-hor_res/2) *  screen_height/vert_res )  / dist) );

% now do right eye
x = rsasc(1:end-1,enum.right_x);
y = rsasc(1:end-1,enum.right_y);

x_right = rad2deg( atan( ((x-hor_res/2) *  screen_width/hor_res )  / dist) );
y_right = rad2deg( atan( ((y-hor_res/2) *  screen_height/vert_res )  / dist) );


% fs = 500;
% 
% fstop = 25;
% 
% wstop = 25/500*2;
% 
% [b, a] = iirnotch( wstop, wstop/35);
% 
% x_left = filter( b, a, x_left);
% y_left = filter( b, a, y_left);
% x_right = filter( b, a, x_right);
% y_right = filter( b, a, y_right);

% 
% 
% 
% wo = 60/(300/2);  bw = wo/35;
% [b,a] = iirnotch(wo,bw);  
% fvtool(b,a);


dva = [x_left y_left  x_right y_right ];
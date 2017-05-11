% front-end for rescore...
% load score file, parse
[filename,pathname] = uigetfile('*.sdf','Open Score Preference File');

if (pathname == 0),
   % 'cancel' condition
   return;
end;


cd (pathname);
fp = fopen(filename, 'r');
if( fp == -1 ),
   return;
end;

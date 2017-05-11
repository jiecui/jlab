function use_edfapi(edffile)
% EDFAPI try out the edfapi dll stuff

% Modify the path -- this is only necessary if you could not install the
% DLL interface library into your copy of MATLAB (perhaps it is located on
% a network drive that you do not have access to). In that case, please
% install the DLL interface library into the same directory as you've
% placed this M-file (finperf.m). If you installed the interface library
% into your copy of MATLAB, you may comment out the two commands below.
% If you install the library into your copy of MATLAB, you will need to
% issue the command 'rehash toolboxcache' at the MATLAB command prompt
% before the example code will run.
local_path = 'toolbox/matlab/general';
if (exist(local_path) == 7), path('toolbox/matlab/general', path), end;

% Load the library that contains the functions dupont() and zscore().
% Only load the library if it isn't already loaded. The library must
% be a DLL on the MATLAB path. (The current directory is a good place
% to put both the library and the header file that defines the library's
% exported functions.)
libname = 'edfapi';
hname = 'edf';
if ~libisloaded(libname)
    % To load the library, specify the name of the DLL and the name of the
    % header file. If no file extensions are provided (as below)
    % LOADLIBRARY assumes that the DLL ends with .dll and the header file
    % ends with .h.
    loadlibrary(libname, hname);
    disp(['Loaded library: ' libname]);
end
if ~libisloaded(libname)
    error(['Failed to load external library: ' libname]);
else
    err = 0;
    edffile = calllib(libname, 'edf_open_file','..\\TOM1.EDF',1,1,1,err);
end


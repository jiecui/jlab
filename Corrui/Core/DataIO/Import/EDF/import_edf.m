function [sessname, imported_data] = import_edf( this, getpathname, filenames, sessname)
% IMPORT_EDF imports EDF files for one session only
% 
% Syntax:
%   [sessname, imported_data] = import_edf( tag, db, prefix, getpathname, filenames, sessname)
% 
% Read EDF files and import the data into matlab vars
% Imput:
%	tag :			tag of the session that is being created
%   db :            CorruiDB object
%	prefix :		prefix for the session name
%	directory :     directory of the files
%	files :			list of files to import
%	sessname :      name of the session
%   options:        options for the import
% 
% Output :
%	sessname:
%	imported_data.edf_samples(:,1)	= Eyelink raw data (HREF, nans and blinks) [timestamps, left_x, right_x, left_y, right_y, left_pupil, right_pupil];
%	imported_data.samples(:,1)		= [timestamps, left_x, left_y, right_x, right_y, left_pupil, right_pupil];
%	imported_data.blinkYesNo		= blinkYesNo(1:end-1);
%	imported_data.blinks			= timestamps and data for blinks
%	imported_data.events			= timestamps and data for events
%	imported_data.saccades			= timestamps and data for saccades
%	imported_data.nsamples			= number of samples that have been imported
%	imported_data.trial_length		= lenght of the trials in the experiment
%	imported_data.samplerate		= sample rate of the data

% Copyright 2014 Richard J. Cui. Created: Sat 03/09/2013  6:30:11.734 PM
% $Revision: 0.2 $  $Date: Sat 03/15/2014 10:24:53.558 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% NOTE: tag name is the folder name in 'Experiments', which is actually a
%       project name.  The function has two general parts: the first one
%       set paras for reading AVI files in different experiments; and the
%       2nd part actually reads the AVI files in each experiments.

% =========================================================================
% global paras
% =========================================================================
tag = class(this);
db = this.db;
prefix = this.prefix;

% =========================================================================
% Get the filenames of data from the dialog,
% if it is not provided
% =========================================================================
if ( ~exist( 'getpathname', 'var' ) )
    S = [];
    [filenames, getpathname, sessname] = import_files_dialog( prefix, tag, 'EDF', S );
    if ( isempty( filenames ) )
        sessname = [];
        imported_data = [];
        return
    end
    if iscell(sessname) && length(sessname) == 1
        sessname = sessname{1};
    end % if
    
    % make sure the prefix is correct in the session
    if ( ~isequal(prefix, sessname(1:length(prefix))) )
        sessname = [prefix sessname];
    end

    % -- Do not import files that are too small, they will give errors (they don't have data)
    goodfiles = zeros(length(filenames),1);
    for j=1:length(filenames)
        d = dir(fullfile( getpathname, char(filenames(j))));
        goodfiles(j) = d.bytes > 1024;
    end
    filenames = filenames(goodfiles==1);

end

% =========================================================================
% get info and options of experiments to be imported
% =========================================================================
switch tag  % tag of different experiments
    % ----- Helicopter Scene ----- %
    case 'Heliscene'
        opt.gazemap = {{'0' '{1}'}, 'Output Gazemap'};
        opt.frames  = {{'0' '{1}'}, 'Insert framenumber'};
        opt.fliph   = {{'{0}' '1'}, 'Flip x-eye positions'};
        opt.flipv   = {{'{0}' '1'}, 'Flip y-eye positions'};
        opt.gaze    = {{'0' '{1}'}, 'Gaze data'};
        opt.blink_gap = { 200, 'Blink gap (ms)', [0 500]};
        opt_dlg_str = 'Options for reading HLS EDF file...';
        
    otherwise
        warning('Unknown experiment')
        opt = [];
end % switch
if isempty(opt)
    values = [];
else
    values = StructDlg(opt,opt_dlg_str);
end % if

% =========================================================================
% import exp data to matlab
% =========================================================================
fprintf(sprintf('\n------>Importing session %s of %s experiment<------\n', sessname, tag))

switch tag  % tage of different experiments
    case 'Heliscene'        % import Helicopter Scene experiment data
        heliscene_exp = importEDF.importHeliscene(getpathname, filenames, values);
        imported_data.enum          = heliscene_exp.enum;                   % data positions meaning
        imported_data.edf_samples   = heliscene_exp.edf_samples;            % eye samples in display coordinates
        imported_data.edf_gaze_samples = heliscene_exp.edf_gaze_samples;    % eye samples in SceneCam AVI coordinates
        imported_data.samples       = heliscene_exp.samples;                % TODO: ?? eye samples in dva from edf_samples
        imported_data.timestamps    = heliscene_exp.timestamps;             % time stamps of edf_samples
        imported_data.elink_fixations   = heliscene_exp.elink_fix;
        imported_data.elink_saccades    = heliscene_exp.elink_sacc;
        imported_data.elink_blinks  = heliscene_exp.elink_blink;
        imported_data.blinkYesNo    = heliscene_exp.blinkYesNo;
        imported_data.pupil_samples = heliscene_exp.pupil_samples;
        imported_data.samplerate    = heliscene_exp.samplerate;
        imported_data.message       = heliscene_exp.message;
        imported_data.options       = heliscene_exp.options;
        imported_data.info          = heliscene_exp.info;
        
    otherwise   % use old edf files
        [sessname, imported_data] = import_edfs( tag, db, prefix, directory, filenames, sessname, options);
end

end % function

% [EOF]

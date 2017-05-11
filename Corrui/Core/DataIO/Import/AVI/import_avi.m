function [sessname, imported_data] = import_avi( this, getpathname, filenames, sessname, values)
% IMPORT_AVI imports AVI files for one session only

% Copyright 2014 Richard J. Cui. Created: Sat 03/09/2013  6:30:11.734 PM
% $Revision: 0.3 $  $Date: Sat 03/15/2014 10:24:53.558 AM $
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
prefix = this.prefix;

% =========================================================================
% Get the filenames of data from the dialog,
% if it is not provided
% =========================================================================
if ( ~exist( 'getpathname', 'var' ) )
    S = [];
    [filenames, getpathname, sessname] = import_files_dialog( prefix, tag, 'AVI', S );
    if ( isempty( filenames ) )
        sessname = [];
        imported_data = [];
        return
    end
    if length(sessname) == 1
        sessname = sessname{1};
    end % if
end

% =========================================================================
% get info and options of experiments to be imported
% =========================================================================
% if isempty(values)
%     switch tag  % tag of different experiments
%         % ----- Helicopter Scene ----- %
%         case 'Heliscene'
%             opt.tag = tag;
%             opt_dlg_str = 'Options for reading HLS AVI file...';
%             
%         otherwise
%             warning('Unknown experiment')
%             opt = [];
%     end % switch
%     if isempty(opt)
%         values = [];
%     else
%         values = StructDlg(opt,opt_dlg_str);
%     end % if
% end % if

% =========================================================================
% import exp data to matlab
% =========================================================================
fprintf(sprintf('\n------>Importing session %s of %s experiment<------\n', sessname, tag))

switch tag  % tage of different experiments
    case 'Heliscene'        % impoart Helicopter Scene experiment data
        heliscene_exp = importAVI.importHeliscene(getpathname, filenames, values);
        imported_data.AVIObj    = heliscene_exp.AVIObj;
        imported_data.fps       = heliscene_exp.fps;
            
    otherwise 
        error('Unknown experiment')
end

end % function

% [EOF]

function [sessname, imported_data] = import_edf_cortex( this, files_dir, files, session_name )

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 1.7 $  $Date: Tue 09/03/2013 10:10:14.838 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

current_tag = class(this);
db = this.db;
prefix = this.prefix;

% sessname = []; imported_data = [];


if ( ~exist( 'files_dir' , 'var' ) )
    [sessname, imported_data] = import_edfs2( current_tag, db, prefix);
    EDF_files = imported_data.info.import.filenames;
else
    EDF_files = {};
    CTX_files = {};
    for i=1:length(files)
        if ( ~isempty( strfind( files{i}, '.edf' ) ) || ~isempty( strfind( files{i}, '.EDF' ) ))
            EDF_files{end+1} = files{i};
        else
            CTX_files{end+1} = files{i};
        end
    end
    [sessname, imported_data] = import_edfs2( current_tag, db, prefix ,  files_dir, EDF_files, session_name);
end

imported_data.info.import.edf_filenames = EDF_files;
if ( isempty( sessname ) )
    return
end
if ( ~exist( 'files_dir' , 'var' ) )
    imported_data	= read_ctx( imported_data );
else
    imported_data	= read_ctx( imported_data, CTX_files , files_dir );
end

end

function dat = read_ctx( dat ,ctxnames,ctxpathname)
% function dat = incrthresh_read_files(fname)
% use the given string to read fname.edf and the associated .ctx file, then
% put all the data in dat

orig_dir = pwd;
if ( ~exist('ctxnames') )
    pathname = getpref('corrui', ['FreeView_ctx_Directory'], [orig_dir filesep]);
    
    cd(pathname);
    if (~exist('ctxnames' ) )
        [ctxnames,ctxpathname] = uigetfile( { ['*.1;*.2;*.3;*.4;*.5;*.6;*.7;*.8;*.9;'], 'All Cortex Files'}, 'Step 2: Choose cortex file', 'MultiSelect', 'on');
    end
    
    if ( isempty(ctxnames) )
        dat = [];
        return;
    end
    
    if ( ~iscell(ctxnames) )
        ctxnames = {ctxnames};
    end
else
    ctxpathname = [ctxpathname '\'];
end


for i=1:length(ctxnames)
    ctxname = char(ctxnames{i});
    [ctxTimes, ctxEvents, ctxEog_arr, ctxEpp_arr, ctxHeader, ctxTrialcount] = get_alldata([ctxpathname ctxname]);
    
    if ( ~isfield( dat, 'ctxTimes' ) )
        dat.ctxTimes	= ctxTimes;
        dat.ctxEvents	= ctxEvents;
        dat.ctxEog_arr	= ctxEog_arr;
        dat.ctxEpp_arr	= ctxEpp_arr;
        dat.ctxHeader	= ctxHeader;
        dat.ctxTrialcount = ctxTrialcount;
    else
        % correct for the case that not all the matrixes have the same
        % number of events. FILLING WITH ZEROS
        if ( size(dat.ctxTimes,1) > size(ctxTimes,1))
            ctxTimes = [ctxTimes;zeros(size(dat.ctxTimes,1)-size(ctxTimes,1),size(ctxTimes,2))];
            ctxEvents = [ctxEvents;zeros(size(dat.ctxEvents,1)-size(ctxEvents,1),size(ctxEvents,2))];
            
        elseif ( size(dat.ctxTimes,1) < size(ctxTimes,1))
            dat.ctxTimes = [dat.ctxTimes;zeros(size(ctxTimes,1)-size(dat.ctxTimes,1),size(dat.ctxTimes,2))];
            dat.ctxEvents = [dat.ctxEvents;zeros(size(ctxEvents,1)-size(dat.ctxEvents,1),size(dat.ctxEvents,2))];
        end
        % putting together the matrixes
        dat.ctxTimes	= [dat.ctxTimes ctxTimes+max(dat.ctxTimes(:))+1];
        dat.ctxEvents	= [dat.ctxEvents ctxEvents];
        dat.ctxHeader	= [dat.ctxHeader ctxHeader];
        dat.ctxTrialcount = dat.ctxTrialcount + ctxTrialcount;
    end
end

dat.info.import.ctx_pathname = ctxpathname;
dat.info.import.ctx_filenames = ctxnames;
% save cortex path in prefs
setpref('corrui', ['FreeView_ctx_Directory'], ctxpathname);

cd(orig_dir);
end
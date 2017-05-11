function [sessname, imported_data] = import_rf( this, pathname, filename, sessname, values)
% IMPORT_RF imports RF2 files for one data session / blocks

% Copyright 2013 Richard J. Cui. Created: Mon 03/28/2011  5:59:26 PM
% $Revision: 1.7 $  $Date: Tue 09/03/2013 10:10:14.838 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% NOTE: tag name is the folder name in 'Experiments', which is actually a
%       project name.
% TODO: paras input in Configuration

% ----------------
% global paras
% ----------------
% maxNumChunks = 5000;

tag = class(this);
prefix = this.prefix;

% ---------------------------------------------
% Get the filenames of data from the dialog,
% if it is not provided
% ---------------------------------------------
% if exist('filename', 'var') && ischar('filename')
%     filename = {filename};
% end % if

if ( ~exist( 'pathname', 'var' ) )
    S=[];
    [filename, pathname, sessname] = import_files_dialog( prefix, tag, 'RF', S );
    if ( isempty( filename ) )
        sessname = [];
        imported_data = [];
        return
    end
    if length(sessname) == 1
        sessname = sessname{1};
    end % if
end

% --------------------------
% inport exp data to matlab
% --------------------------
fprintf(sprintf('\n------>Importing session %s of %s experiment<------\n', sessname, tag))
if ~isfield(values, 'Which_reading_method')
    sessname = [];
    imported_data = [];
    return
end % if

if strcmpi(values.Which_reading_method, 'Jie')
    switch tag  % tage of different experiments
%         case 'Fixsim'
%             fsm_exp = importRF2.importFixsimExp(pathname, filename, values);
%             % save spike and eye data
%             % ---------------------
%             imported_data.SAEChunkData = fsm_exp.SAEChunkData;
%             % save fixsim chunk data
%             % --------------------
%             imported_data.FsmChunkData = fsm_exp.FsmChunkData;
%             % save other system info
%             % --------------------
%             imported_data.HorAngle      = fsm_exp.HorAngle;
%             imported_data.VerAngle      = fsm_exp.VerAngle;
%             imported_data.samplerate    = fsm_exp.samplerate;
%             imported_data.timestamps    = fsm_exp.timestamps;
%             imported_data.samples       = fsm_exp.samples;
%             imported_data.spiketimes    = fsm_exp.spiketimes;
%             imported_data.blinkYesNo    = fsm_exp.blinkYesNo;
%             imported_data.stim1         = fsm_exp.stim1;
%             imported_data.TuneChunkData = fsm_exp.TuneChunkData;
%             imported_data.BeforeExpTuneChunk    = fsm_exp.TuneChunkData.BeforeExpTuneChunk;
%             imported_data.AfterExpTuneChunk     = fsm_exp.TuneChunkData.AfterExpTuneChunk;
        
%         case 'ABSV1Diag'
%             abd_exp = importRF2.importAbsv1diagExp(pathname, filename, values);
%             % save spike and eye data
%             % -----------------------
%             imported_data.SAEChunkData = abd_exp.SAEChunkData;
%             % save diag data
%             % -----------------
%             imported_data.DigChunkData = abd_exp.DigChunkData;
%             % save other system info
%             % ----------------------
%             imported_data.HorAngle      = abd_exp.HorAngle;
%             imported_data.VerAngle      = abd_exp.VerAngle;
%             imported_data.HorWidth      = abd_exp.HorWidth;
%             imported_data.VerWidth      = abd_exp.VerWidth;
%             imported_data.samplerate    = abd_exp.samplerate;
%             imported_data.timestamps    = abd_exp.timestamps;
%             imported_data.samples       = abd_exp.samples;
%             imported_data.spiketimes    = abd_exp.spiketimes;
%             imported_data.blinkYesNo    = abd_exp.blinkYesNo;
        
%         case 'ABSV1EdgeCompare'
%             aec_exp = importRF2.importAbsv1edgecompExp(pathname, filename, values);
%             % save spike and eye data
%             % -----------------------
%             imported_data.SAEChunkData = aec_exp.SAEChunkData;
%             % save Edgecomp data
%             % -----------------
%             imported_data.EgcChunkData = aec_exp.EgcChunkData;
%             % save other system info
%             % ----------------------
%             imported_data.HorAngle      = aec_exp.HorAngle;
%             imported_data.VerAngle      = aec_exp.VerAngle;
%             imported_data.HorWidth      = aec_exp.HorWidth;
%             imported_data.VerWidth      = aec_exp.VerWidth;
%             imported_data.samplerate    = aec_exp.samplerate;
%             imported_data.timestamps    = aec_exp.timestamps;
%             imported_data.samples       = aec_exp.samples;
%             imported_data.spiketimes    = aec_exp.spiketimes;
%             imported_data.blinkYesNo    = aec_exp.blinkYesNo;
                    
%         case 'ABSV1Corners'
%             abc_exp = importRF2.importAbsv1cornersExp(pathname, filename, values);
%             % save spike and eye data
%             % -----------------------
%             imported_data.SAEChunkData = abc_exp.SAEChunkData;
%             % save Croners data
%             % -----------------
%             imported_data.CorChunkData = abc_exp.CorChunkData;
%             % save other system info
%             % ----------------------
%             imported_data.HorAngle      = abc_exp.HorAngle;
%             imported_data.VerAngle      = abc_exp.VerAngle;
%             imported_data.HorWidth      = abc_exp.HorWidth;
%             imported_data.VerWidth      = abc_exp.VerWidth;
%             imported_data.samplerate    = abc_exp.samplerate;
%             imported_data.timestamps    = abc_exp.timestamps;
%             imported_data.samples       = abc_exp.samples;
%             imported_data.spiketimes    = abc_exp.spiketimes;
%             imported_data.blinkYesNo    = abc_exp.blinkYesNo;
            
%         case 'MSaccContrast'        % import contrast exp data
%             contrast_exp = importRF2.importContrastExp(pathname, filename, values);
%             % save spike and eye data
%             % ---------------------
%             imported_data.SAEChunkData = contrast_exp.SAEChunkData;
%             % save contrast data
%             % -----------------
%             imported_data.ConChunkData = contrast_exp.ConChunkData;
%             imported_data.LastConChunk = contrast_exp.ConChunkData.LastConChunk;
%             % save other system info
%             % --------------------
%             imported_data.HorAngle      = contrast_exp.HorAngle;
%             imported_data.VerAngle      = contrast_exp.VerAngle;
%             imported_data.samplerate    = contrast_exp.samplerate;
%             imported_data.timestamps    = contrast_exp.timestamps;
%             imported_data.samples       = contrast_exp.samples;
%             imported_data.spiketimes    = contrast_exp.spiketimes;
%             imported_data.blinkYesNo    = contrast_exp.blinkYesNo;
%             imported_data.TuneChunkData = contrast_exp.TuneChunkData;
%             imported_data.BeforeExpTuneChunk    = contrast_exp.TuneChunkData.BeforeExpTuneChunk;
%             imported_data.AfterExpTuneChunk     = contrast_exp.TuneChunkData.AfterExpTuneChunk;
            
        case 'BlankCtrl'
            bct_exp = importRF2.importBlankctrlExp(pathname, filename, values);
            % save spike and eye data
            % ---------------------
            imported_data.SAEChunkData = bct_exp.SAEChunkData;
            % save blankctrl data
            % -----------------
            imported_data.BctChunkData = bct_exp.BctChunkData;
            imported_data.LastBctChunk = bct_exp.BctChunkData.LastBctChunk;
            % save other system info
            % --------------------
            imported_data.HorAngle      = bct_exp.HorAngle;
            imported_data.VerAngle      = bct_exp.VerAngle;
            imported_data.samplerate    = bct_exp.samplerate;
            imported_data.timestamps    = bct_exp.timestamps;
            imported_data.samples       = bct_exp.samples;
            imported_data.spiketimes    = bct_exp.spiketimes;
            imported_data.blinkYesNo    = bct_exp.blinkYesNo;
            
%         case 'MscLed'
%             mld_exp = importRF2.importMscledExp(pathname, filename, values);
%             % save spike and eye data
%             % ---------------------
%             imported_data.SAEChunkData = mld_exp.SAEChunkData;
%             % save mscled data
%             % -----------------
%             imported_data.BctChunkData = mld_exp.BctChunkData;  % use BctChunk
%             imported_data.LastBctChunk = mld_exp.BctChunkData.LastBctChunk;
%             % save other system info
%             % --------------------
%             imported_data.HorAngle      = mld_exp.HorAngle;
%             imported_data.VerAngle      = mld_exp.VerAngle;
%             imported_data.samplerate    = mld_exp.samplerate;
%             imported_data.timestamps    = mld_exp.timestamps;
%             imported_data.samples       = mld_exp.samples;
%             imported_data.spiketimes    = mld_exp.spiketimes;
%             imported_data.blinkYesNo    = mld_exp.blinkYesNo;
%             imported_data.ImportPara    = values;   % structures of paras for importing

        case 'Tune'
            tune_exp = importRF2.importTuneExp(pathname, filename, values);
            % save tune data
            % ---------------
            imported_data.TuneChunkData = tune_exp.TuneChunkData;
            imported_data.BeforeExpTuneChunk = tune_exp.TuneChunkData.BeforeExpTuneChunk;
            imported_data.AfterExpTuneChunk = tune_exp.TuneChunkData.AfterExpTuneChunk;
            
        case 'Grating'
            grating_exp = importRF2.importGratExp(pathname, filename, values);
            % save spike and eye data
            % ---------------------
            imported_data.SAEChunkData = grating_exp.SAEChunkData;
            % save grating data
            % -----------------
            imported_data.GratChunkData = grating_exp.GratChunkData;
            imported_data.LastGratChunk = grating_exp.GratChunkData.LastGratChunk;
            % save other system info
            % --------------------
            imported_data.HorAngle      = grating_exp.HorAngle;
            imported_data.VerAngle      = grating_exp.VerAngle;
            imported_data.samplerate    = grating_exp.samplerate;
            imported_data.timestamps    = grating_exp.timestamps;
            imported_data.samples       = grating_exp.samples;
            imported_data.spiketimes    = grating_exp.spiketimes;
            imported_data.blinkYesNo    = grating_exp.blinkYesNo;
        
        case 'AlternatingBrightnessStar'
            [sessname, imported_data] = import_rf_jie( tag, pathname, filename, sessname, values);
            
        otherwise % import other old data
            [sessname, imported_data] = import_rf_jie( tag, pathname, filename, sessname, values);
    end
    
elseif strcmpi(values.Which_reading_method, 'Other')
    % -- Get the filenames to import from the dialog
    if ( ~exist( 'getpathname', 'var' ) )
        S=[];
        [filename, pathname, sessname] = import_files_dialog( prefix, tag, 'RF', S );
        if ( isempty( filename ) )
            return
        end
    end
    [sessname, imported_data] = import_rf_others( tag, prefix, pathname, filename, sessname);
    
end % if


end % function

% [EOF]

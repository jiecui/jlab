function  dat = analyze_eye_movements( this, sname, S,  import_variables)
% BLANKCTRL.ANALYZE_EYE_MOVEMENTS
% 
% Last modified by Richard J. Cui on Wed 10/30/2013  1:33:43.257 PM
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

%% This function is for Stage 1 processing

%==========================================================================
%% Get Data ===============================================================
%==========================================================================
if ~exist('import_variables', 'var')
    import_variables = { 'samples' 'isInTrialSequence' 'isInTrialCond' ...
                         'isInTrial' 'blinkYesNo' 'samplerate' 'info' 'enum' };
end % if
dat = this.db.getsessvars( sname, import_variables );
dat.enum = get_enums( dat.enum );
enum = dat.enum;

% detect all saccades in the recording (not only those in the trials)
% flag_DetectAllSaccades = true;
% datts = this.db.getsessvars(sname, {'timestamps'});
% timestamps = datts.timestamps;
% dat.isInTrial = EyeMovement.get_isInTrial_from_timestamps(timestamps);
%     datiit = this.db.getsessvars(sname, {'isInTrial'});
%     dat.isInTrial = datiit.isInTrial;

% save original eye data
% dat.eyedat = dat.samples;

LEFT =  ~isAllNaN( dat.samples(:,enum.samples.left_x) );
RIGHT = ~isAllNaN( dat.samples(:,enum.samples.right_x) );

% TODO: IMPROVE!!!
% dat = fix_variables(dat);

% events of eye movement objects
bct_ms = BCTUsacc(sname);
bct_sa = BCTSacc(sname);
bct_bk = BCTBlink(sname);
bct_fx = BCTFixation(sname);
bct_tr = BCTTrial(sname);

%% ========================================================================
%% = Preprocess ==========================================
%% ========================================================================
% low pass filtering the sample if requested
% ------------------------------------------
% ( the original data will be in 'eyedat', the filtered data will be saved in 'samples' )
% ++++++++++++++++++++++++++++
% Butterworth IIR filter
% ++++++++++++++++++++++++++++
if ( S.Stage_1_Options.Low_pass_filter )
    [b,a] = butter( 10, S.Stage_1_Options.Low_pass_filter_freq/dat.samplerate );
    if ( LEFT )
        dat.samples(:,enum.samples.left_x) = filtfilt( b, a, dat.samples(:,enum.samples.left_x));
        dat.samples(:,enum.samples.left_y) = filtfilt( b, a, dat.samples(:,enum.samples.left_y));
    end
    if ( RIGHT )
        dat.samples(:,enum.samples.right_x) = filtfilt( b, a, dat.samples(:,enum.samples.right_x));
        dat.samples(:,enum.samples.right_y) = filtfilt( b, a, dat.samples(:,enum.samples.right_y));
    end
end

% ++++++++++++++++++++++++++++++++++
% Wavelet Filter
% Mon 02/14/2011  5:33:44 PM by RJC
% ----------------------------------
if S.Stage_1_Options.Wavelet_Filter
    
    wname = S.Stage_1_Options.Wavelet_Filter_Options.Wavelet_Name;
    level = S.Stage_1_Options.Wavelet_Filter_Options.Decomposition_Level;
    sorh  = S.Stage_1_Options.Wavelet_Filter_Options.Soft_or_hard_threshold;
    manu  = S.Stage_1_Options.Wavelet_Filter_Options.Manually_set_threshold;
    thres = S.Stage_1_Options.Wavelet_Filter_Options.Threshold;
    
    if LEFT
        eye_range = enum.samples.left_x:enum.samples.left_y;
        xy = dat.samples(:,eye_range);
        if ~manu
            dxy = denWtXy(xy,wname,level,sorh);
        else
            dxy = denWtXy(xy,wname,level,sorh,thres);
        end
        dat.samples(:,eye_range) = dxy;
    end % if
    if RIGHT
        eye_range = enum.samples.right_x:enum.samples.right_y;
        xy = dat.samples(:,eye_range);
        if ~manu
            dxy = denWtXy(xy,wname,level,sorh);
        else
            dxy = denWtXy(xy,wname,level,sorh,thres);
        end
        dat.samples(:,eye_range) = dxy;
    end % if
    
end % if

% Engbert Surrogate analysis ( optional )
% dat = surrogate( sname, dat, S );

%% ========================================================================
%% = Saccade detection !! ==========================================
%% ========================================================================
% (1) get the saccade detection algorithm object
% -----------------------------------------------
if ( S.Stage_1_Options.Use_Engbert_Algorithm )
    S.Algorithm = 'Engbert';
elseif (S.Stage_1_Options.Use_MMC_Algorithm)
    S.Algorithm = 'MMC';
else
    error('Unknown (micro)saccade detection algorithm')
end

switch( S.Algorithm )
    case 'Engbert'
        saccadeDetection = SaccadeDetectionEngbert( );
        algorithmParms = S.Stage_1_Options.Engbert_options;
    case 'MMC'
        saccadeDetection = SaccadeDetectionMMC();
        algorithmParms = S.Stage_1_Options.MMC_options;
    otherwise
        error('Unknown (micro)saccade detection algorithm')
end

if ( LEFT )
    dat.left_monoculars = [];
    dat.left_overshoots = [];
end
if ( RIGHT )
    dat.right_monoculars = [];
    dat.right_overshoots = [];
end

% (2) Basic monocular detection
% -----------------------------
if ( LEFT )
    xy_left = dat.samples(:,[enum.samples.left_x,enum.samples.left_y]);
    dat.left_eyedat = saccadeDetection.PreprocessData(xy_left, dat.samplerate, enum );
    lsac = saccadeDetection.FindSaccades( dat.left_eyedat, dat.samplerate, ...
        dat.isInTrial, dat.blinkYesNo, algorithmParms, enum);
end
if ( RIGHT )
    xy_right = dat.samples(:,[enum.samples.right_x,enum.samples.right_y]);
    dat.right_eyedat = saccadeDetection.PreprocessData(xy_right, dat.samplerate, enum );
    rsac = saccadeDetection.FindSaccades( dat.right_eyedat, dat.samplerate, ...
        dat.isInTrial, dat.blinkYesNo, algorithmParms, enum);
end

% (3) Remove monoculars (overlap threshold)
% --------------------------------------
if ( LEFT && RIGHT && S.Stage_1_Options.Remove_Monoculars )
    [left_monoculars_idx, right_monoculars_idx] = saccadeDetection.FindMonoculars( lsac, rsac, dat.samplerate, S.Stage_1_Options.Binoculars_Minimum_Overlap );
    dat.left_monoculars = lsac(left_monoculars_idx,:);
    dat.right_monoculars = rsac(right_monoculars_idx,:);
    lsac(left_monoculars_idx,:) = [];
    rsac(right_monoculars_idx,:)  = [];
else
    dat.left_monoculars     = [];
    dat.right_monoculars    = [];    
end

% (4) Remove overshoots
% ----------------------
if ( S.Stage_1_Options.Remove_Overshoots )
    if ( LEFT && RIGHT )
        if ( S.Stage_1_Options.Remove_Monoculars )
            % if monoculars have been removed we can find overshoots
            % binocularly
            [overshoots_idx] = saccadeDetection.FindOvershoots( dat.left_eyedat, lsac, dat.right_eyedat, rsac, dat.samplerate,  S.Stage_1_Options.Overshoot_Time );
            left_overshoots_idx = overshoots_idx;
            right_overshoots_idx = overshoots_idx;
        else
            % if monoculars are still present we find the overshoots
            % independently in each eye
            [left_overshoots_idx] = saccadeDetection.FindOvershoots( dat.left_eyedat, lsac, [], [], dat.samplerate, S.Stage_1_Options.Overshoot_Time );
            [right_overshoots_idx] = saccadeDetection.FindOvershoots( [], [], dat.right_eyedat, rsac, dat.samplerate, S.Stage_1_Options.Overshoot_Time );
        end
        dat.left_overshoots = lsac(left_overshoots_idx,:);
        dat.right_overshoots = rsac(right_overshoots_idx,:);
        lsac(left_overshoots_idx,:) = [];
        rsac(right_overshoots_idx,:) = [];
    elseif ( LEFT )
        [left_overshoots_idx] = saccadeDetection.FindOvershoots( dat.left_eyedat, lsac, [], [], dat.samplerate, S.Stage_1_Options.Overshoot_Time );
        dat.left_overshoots = lsac(left_overshoots_idx,:);
        lsac(left_overshoots_idx,:) = [];
    elseif ( RIGHT )
        [right_overshoots_idx] = saccadeDetection.FindOvershoots( [], [], dat.right_eyedat, rsac, dat.samplerate, S.Stage_1_Options.Overshoot_Time );
        dat.right_overshoots = rsac(right_overshoots_idx,:);
        rsac(right_overshoots_idx,:) = [];
    end
end

% (5) Refine durations
% ---------------------
if ( isfield(S,'UseOvershoots') &&   S.UseOvershoots )
    if ( S.Remove_Overshoots )
        if ( LEFT )
            % oldlsac = lsac;
            for i=1:size(lsac,1)
                ovidx = find(dat.left_overshoots(:,1)>=lsac(i,2) & dat.left_overshoots(:,1)<=lsac(i,2)+ S.Stage_1_Options.Overshoot_Time);
                if ( ~isempty(ovidx) )
                    lsac(i,2) = dat.left_overshoots(ovidx(end),2);
                end
            end
        end
        if ( RIGHT )
            % oldrsac = rsac;
            for i=1:size(rsac,1)
                ovidx = find(dat.right_overshoots(:,1)>=rsac(i,2) & dat.right_overshoots(:,1)<=rsac(i,2)+ S.Stage_1_Options.Overshoot_Time);
                if ( ~isempty(ovidx) )
                    rsac(i,2) = dat.right_overshoots(ovidx(end),2);
                end
            end
        end
    end
end

% (6) Classify microsaccades and saccades (magnitude threshold)
% -------------------------------------------------------------
if ( LEFT && RIGHT )
    % lmags = bct_ms.getmagnitude( dat.left_eyedat(:,[1 2]), lsac );
    lmags = bct_ms.getmagnitude( dat.left_eyedat(:,[enum.eyedat.x, enum.eyedat.y]), lsac );
    % rmags = bct_ms.getmagnitude( dat.right_eyedat(:,[1 2]), rsac );
    rmags = bct_ms.getmagnitude( dat.right_eyedat(:,[enum.eyedat.x, enum.eyedat.y]), rsac );
    if ( S.Stage_1_Options.Remove_Monoculars )
        % if monoculars have been removed we can find microsaccades
        % binocularly
        lusac_idx = find( lmags < S.Stage_1_Options.Maximum_usac_magnitude & rmags < S.Stage_1_Options.Maximum_usac_magnitude );
        rusac_idx = lusac_idx;
    else
        % if monoculars are still present we find the microsaccades
        % independently in each eye
        [lusac_idx] = find( lmags < S.Stage_1_Options.Maximum_usac_magnitude );
        [rusac_idx] = find( rmags < S.Stage_1_Options.Maximum_usac_magnitude );
    end
    lusac = lsac(lusac_idx,:);
    rusac = rsac(rusac_idx,:);
    lsac(lusac_idx,:)   = [];
    rsac(rusac_idx,:)  = [];
elseif ( LEFT )
    % lmags = bct_ms.getmagnitude( dat.left_eyedat(:,[1 2]), lsac );
    lmags = bct_ms.getmagnitude( dat.left_eyedat(:,[enum.eyedat.x, enum.eyedat.y]), lsac );

    [lusac_idx] = find( lmags < S.Stage_1_Options.Maximum_usac_magnitude );
    lusac = lsac(lusac_idx,:);
    lsac(lusac_idx,:)   = [];
elseif ( RIGHT )
    % rmags = bct_ms.getmagnitude( dat.right_eyedat(:,[1 2]), rsac );
    rmags = bct_ms.getmagnitude( dat.right_eyedat(:,[enum.eyedat.x, enum.eyedat.y]), rsac );
    
    [rusac_idx] = find( rmags < S.Stage_1_Options.Maximum_usac_magnitude );
    rusac = rsac(rusac_idx,:);
    rsac(rusac_idx,:)  = [];
end
if isempty(lusac)
    fprintf('>>>> No microsaccade detected in LEFT eye. <<<<\n')
    LEFT = false;
end % if
if isempty(rusac)
    fprintf('>>>> No microsaccade detected in RIGHT eye. <<<<\n')
    RIGHT = false;
end % if


%% ========================================================================
%% = Calculate eye movement properties ====================================
%% ========================================================================
% if the saccades are detected irrelavent to trial info, we need correct
% trial info to get properties
% if flag_DetectAllSaccades == true
%         datiit = this.db.getsessvars(sname, {'isInTrial'});
%         dat.isInTrial = datiit.isInTrial;
% end % if

% update enums
% --------------
dat.enum.usacc_props    = bct_ms.getEnum();
dat.enum.saccade_props  = bct_sa.getEnum();
dat.enum.blink_props    = bct_bk.getEnum();
dat.enum.fixation_props = bct_fx.getEnum();
dat.enum.trial_props    = bct_tr.getEnum();
dat.enum.driftdat       = DriftAlgorithmAbstract.getEnum();
dat.enum.drift_props    = DriftProperties.getEnum;

% (7) Calculate flags
% ---------------------
if ( LEFT )
    dat.left_eyeflags = saccadeDetection.FindFlags( dat.isInTrial, dat.blinkYesNo, lusac, lsac, dat.left_overshoots, dat.left_monoculars, dat.enum);
end
if ( RIGHT )
    dat.right_eyeflags = saccadeDetection.FindFlags( dat.isInTrial, dat.blinkYesNo, rusac, rsac, dat.right_overshoots, dat.right_monoculars, dat.enum );
end

% Sort events
% ------------
trial = [find( diff([0;dat.isInTrial])>0), find( diff([dat.isInTrial;0])<0)];
blink = [find( diff([0;dat.blinkYesNo])>0), find( diff([dat.blinkYesNo;0])<0)];
if ( LEFT )
    [left_events, dat.enum.event] = sort_events( lusac, lsac, blink, trial);
end
if ( RIGHT )
    [right_events, dat.enum.event]  = sort_events( rusac, rsac, blink, trial);
end

% Calculate properties of microsaccades, saccades, blinks and fixations
% ---------------------------------------------------------------------
if ( LEFT )
    dat.left_usacc_props = bct_ms.getprops( dat.left_eyedat, lusac , dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, left_events, dat.enum.event );
    dat.left_saccade_props = bct_sa.getprops( dat.left_eyedat, lsac , dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, left_events, dat.enum.event );
    dat.left_blink_props = bct_bk.getprops( dat.blinkYesNo, dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, left_events, dat.enum.event);
    dat.left_fixation_props =  bct_fx.getprops( dat.blinkYesNo, dat.left_eyeflags(:,dat.enum.eyeflags.saccade), dat.isInTrial, dat.isInTrialSequence, dat.isInTrialCond, dat.samplerate, dat.left_usacc_props, dat.enum.usacc_props );
end
if ( RIGHT )
    dat.right_usacc_props = bct_ms.getprops( dat.right_eyedat, rusac , dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, right_events, dat.enum.event );
    dat.right_saccade_props = bct_sa.getprops( dat.right_eyedat, rsac , dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, right_events, dat.enum.event );
    dat.right_blink_props = bct_bk.getprops( dat.blinkYesNo, dat.samplerate, dat.isInTrialSequence, dat.isInTrialCond, right_events, dat.enum.event );
    dat.right_fixation_props =  bct_fx.getprops( dat.blinkYesNo, dat.right_eyeflags(:,dat.enum.eyeflags.saccade), dat.isInTrial, dat.isInTrialSequence, dat.isInTrialCond, dat.samplerate, dat.right_usacc_props, dat.enum.usacc_props );
end

% Calculate properties of trials
% -------------------------------
timestamps = dat.samples(:, enum.samples.timestamps);
if LEFT || RIGHT
    dat.trial_props = bct_tr.getprops( timestamps, dat.isInTrialCond, dat.isInTrialSequence );
end

%% ========================================================================
%% = SWJ detection  =======================================================
%% ========================================================================
enum = dat.enum;
if ( S.Stage_1_Options.Detect_SWJ )
    
    % get blinkYesNo
    blinkyn = dat.blinkYesNo;
    
    % get swj detection parameters
    paras.DM    = S.Stage_1_Options.Detect_SWJ_options.DM;
    paras.DS    = S.Stage_1_Options.Detect_SWJ_options.DS;
    paras.DR    = S.Stage_1_Options.Detect_SWJ_options.DR;
    paras.RM    = S.Stage_1_Options.Detect_SWJ_options.RM;
    paras.RS    = S.Stage_1_Options.Detect_SWJ_options.RS;
    paras.RR    = S.Stage_1_Options.Detect_SWJ_options.RR;
    paras.ISIP  = S.Stage_1_Options.Detect_SWJ_options.ISIP;
    paras.swjindexth = S.Stage_1_Options.Detect_SWJ_options.swjindexth;
    paras.samplerate = dat.samplerate;
    
    % detect SWJs from usacc only now
    if LEFT
        % microsaccades
        lusac = dat.left_usacc_props;
        lusac_swj = detUsaccSWJ(lusac, paras, blinkyn, enum);
        dat.left_usacc_props = lusac_swj;
    end % if
    
    if RIGHT
        rusac = dat.right_usacc_props;
        rusac_swj = detUsaccSWJ(rusac, paras, blinkyn, enum);
        dat.right_usacc_props = rusac_swj;
    end % if

end

% update flags
% ---------------------
if ( LEFT )
    dat.left_eyeflags = saccadeDetection.FindFlags( dat.isInTrial, dat.blinkYesNo, lusac, lsac, dat.left_overshoots, dat.left_monoculars, dat.enum);
end
if ( RIGHT )
    dat.right_eyeflags = saccadeDetection.FindFlags( dat.isInTrial, dat.blinkYesNo, rusac, rsac, dat.right_overshoots, dat.right_monoculars, dat.enum );
end

% update info of the detected eye events
% --------------------------------------
if LEFT
    lusac   = dat.left_usacc_props;
    lsacc   = dat.left_saccade_props;
    los     = dat.left_overshoots;
    lmon    = dat.left_monoculars;
    lblink  = dat.left_blink_props;
    
    num_lusac   = size(lusac, 1);
    % num_lswj    = sum(lusac(:, enum.usacc_props.swj_pair) == 1);    % number of swj pairs
    num_lsac    = size(lsacc, 1);
    num_los     = size(los, 1);
    num_lmon    = size(lmon, 1);
    num_lbink   = size(lblink, 1);
    
    % fprintf(sprintf('  - LEFT: usacc(%d), usacc_swj(%d), saccade(%d), os(%d), mon(%d), blink(%d)\n', num_lusac, num_lswj, num_lsac, num_los, num_lmon, num_lbink) ); 
    fprintf(sprintf('  - LEFT: usacc(%d), saccade(%d), os(%d), mon(%d), blink(%d)\n', num_lusac, num_lsac, num_los, num_lmon, num_lbink) ); 
end
if RIGHT 
    rusac   = dat.right_usacc_props;
    rsacc   = dat.right_saccade_props;
    ros     = dat.right_overshoots;
    rmon    = dat.right_monoculars;
    rblink  = dat.right_blink_props;
    
    num_rusac   = size(rusac, 1);
    % num_rswj    = sum(rusac(:, enum.usacc_props.swj_pair) == 1);    % number of swj pairs
    num_rsac    = size(rsacc, 1);
    num_ros     = size(ros, 1);
    num_rmon    = size(rmon, 1);
    num_rbink   = size(rblink, 1);
    
    % fprintf(sprintf('  - RIGHT: usacc(%d), usacc_swj(%d), saccade(%d), os(%d), mon(%d), blink(%d)\n', num_rusac, num_rswj, num_rsac, num_ros, num_rmon, num_rbink));
    fprintf(sprintf('  - RIGHT: usacc(%d), saccade(%d), os(%d), mon(%d), blink(%d)\n', num_rusac, num_rsac, num_ros, num_rmon, num_rbink));
end

%% ========================================================================
%% = Process stats =======================================================
%% ========================================================================
if ( LEFT )
    dat.left_totaltime	= sum(  dat.isInTrial ) / dat.samplerate * 1000;
    [   dat.left_pus, ...
        dat.left_pif, ...
        dat.left_mus, ...
        dat.left_mag, ...
        dat.left_dus, ...
        dat.left_mps, ...
        dat.left_filter_averages...
        ] = process_averages( this, sname,  dat.left_eyedat(:,5), dat.left_eyeflags(:,2), dat.left_totaltime, dat.samplerate, dat.enum, dat.left_usacc_props, dat.trial_props);
end
if ( RIGHT )
    dat.right_totaltime = sum(  dat.isInTrial ) / dat.samplerate * 1000;
    [   dat.right_pus, ...
        dat.right_pif, ...
        dat.right_mus, ...
        dat.right_mag, ...
        dat.right_dus, ...
        dat.right_mps, ...
        dat.right_filter_averages...
        ] = process_averages( this, sname, dat.right_eyedat(:,5), dat.right_eyeflags(:,2), dat.right_totaltime, dat.samplerate, dat.enum, dat.right_usacc_props, dat.trial_props);
end


% =========================================================================
%% Calculate Envelope and statistics of the envelope
% =========================================================================
% Calculate drift??
% ------------------
if S.Stage_1_Options.Calculate_Drift
    disp('Calculating Envelope')
    [dat.session_start,dat.session_end] = get_session_start_stop_idx( sname );
    if ( LEFT )
        [dat.left_envlp_x_up, dat.left_envlp_x_down] = Envelope.GetEnvelope(dat.samples(:,dat.enum.samples.left_x),...
            dat.left_eyeflags(:,dat.enum.eyeflags.drift),dat.samplerate);
        
        [dat.left_envlp_y_up, dat.left_envlp_y_down] = Envelope.GetEnvelope(dat.samples(:,dat.enum.samples.left_y),...
            dat.left_eyeflags(:,dat.enum.eyeflags.drift),dat.samplerate);
        
        [dat.left_x_envlp_size_mean, dat.left_x_envlp_size_std, dat.left_x_envlp_size_min, dat.left_x_envlp_size_max] =...
            Envelope.GetEnvelopeStats(dat.left_envlp_x_up, dat.left_envlp_x_down, dat.left_eyeflags(:,dat.enum.eyeflags.drift), 'Left Horizontal', dat.session_start, dat.session_end);
        
        [dat.left_y_envlp_size_mean, dat.left_y_envlp_size_std, dat.left_y_envlp_size_min, dat.left_y_envlp_size_max] =...
            Envelope.GetEnvelopeStats(dat.left_envlp_y_up, dat.left_envlp_y_down, dat.left_eyeflags(:,dat.enum.eyeflags.drift), 'Left Vertical', dat.session_start, dat.session_end);
    end
    if ( RIGHT )
        [dat.right_envlp_x_up, dat.right_envlp_x_down] = Envelope.GetEnvelope(dat.samples(:,dat.enum.samples.right_x),...
            dat.right_eyeflags(:,dat.enum.eyeflags.drift),dat.samplerate);
        
        [dat.right_envlp_y_up, dat.right_envlp_y_down] = Envelope.GetEnvelope(dat.samples(:,dat.enum.samples.right_y),...
            dat.right_eyeflags(:,dat.enum.eyeflags.drift),dat.samplerate);
        
        [dat.right_x_envlp_size_mean, dat.right_x_envlp_size_std, dat.right_x_envlp_size_min, dat.right_x_envlp_size_max] =...
            Envelope.GetEnvelopeStats(dat.right_envlp_x_up, dat.right_envlp_x_down, dat.right_eyeflags(:,dat.enum.eyeflags.drift), 'Right Horizontal', dat.session_start, dat.session_end);
        
        [dat.right_y_envlp_size_mean, dat.right_y_envlp_size_std, dat.right_y_envlp_size_min, dat.right_y_envlp_size_max] =...
            Envelope.GetEnvelopeStats(dat.right_envlp_y_up, dat.right_envlp_y_down, dat.right_eyeflags(:,dat.enum.eyeflags.drift), 'Right Vertical', dat.session_start, dat.session_end);
    end
    if S.Low_pass_filter %dont want already filtered data (so go back to original)
        dat.samples = CorruiDB.Getsessvar(sname,'samples');
    end
    
    switch( S.Stage_1_Options.Drift_Options.Drift_Algorithm )
        case 'HP_Filter'
            DriftAlgorithm = DriftHPFilter();
        case 'Low_Pass_Filter'
            DriftAlgorithm = DriftLowPassFilter();
        case 'Smoothing_Filter'
            DriftAlgorithm = DriftSmoothingFilter();
    end
    
    
    drift_params = S.Stage_1_Options.Drift_Options;
    disp(['Calculating Drift Using: ' deunderscore(S.Drift_Options.Drift_Algorithm)])
    
    if (LEFT && RIGHT)
        [dat.left_driftdat, dat.right_driftdat, driftalg_params] = DriftAlgorithm.CalculateDrift(dat.samples(:,[dat.enum.samples.left_x,dat.enum.samples.left_y]), dat.left_eyeflags(:,dat.enum.eyeflags.drift),...
            dat.samples(:,[dat.enum.samples.right_x,dat.enum.samples.right_y]), dat.right_eyeflags(:,dat.enum.eyeflags.drift), dat.session_start, dat.session_end, dat.samplerate, drift_params);
    end
    if (LEFT && ~RIGHT)
        [dat.left_driftdat, ~, driftalg_params] = DriftAlgorithm.CalculateDrift(dat.samples(:,[dat.enum.samples.left_x,dat.enum.samples.left_y]), dat.left_eyeflags(:,dat.enum.eyeflags.drift),...
            [],[], dat.session_start, dat.session_end, dat.samplerate, drift_params);
    end
    if (~LEFT && RIGHT)
        [~, dat.right_driftdat, driftalg_params] = DriftAlgorithm.CalculateDrift([],[],...
            dat.samples(:,[dat.enum.samples.right_x,dat.enum.samples.right_y]), dat.right_eyeflags(:,dat.enum.eyeflags.drift), dat.session_start, dat.session_end, dat.samplerate, drift_params);
    end
    if ~isempty(driftalg_params)
        dat = mergestructs(dat,driftalg_params);
    end
    
    
    % Calculate Drift Properties
    if ( LEFT )
        [dat.left_driftdat, dat.left_drift_props, dat.left_percent_contained_envlp] = DriftProperties.getprops(dat.left_driftdat, dat.left_eyeflags(:,dat.enum.eyeflags.drift),...
            dat.samplerate, dat.isInTrialCond, dat.left_envlp_x_down, dat.left_envlp_x_up, dat.left_envlp_y_down, dat.left_envlp_y_up, drift_params.Window_Around_Drift_For_Properties,...
            left_events, dat.enum, dat.left_usacc_props, dat.left_saccade_props);
        
        left_drift_speed = nanmean(dat.left_driftdat(:,dat.enum.driftdat.instspeed));
        left_drift_speed_std = nanstd(dat.left_driftdat(:,dat.enum.driftdat.instspeed));
        
        disp(['Mean Left Drift Speed: ' num2str(left_drift_speed,3) ' +/- ' num2str(left_drift_speed_std,3) ' deg/sec']);
    end
    if ( RIGHT )
        [dat.right_driftdat, dat.right_drift_props, dat.right_percent_contained_envlp] = DriftProperties.getprops(dat.right_driftdat, dat.right_eyeflags(:,dat.enum.eyeflags.drift),...
            dat.samplerate, dat.isInTrialCond, dat.right_envlp_x_down, dat.right_envlp_x_up, dat.right_envlp_y_down, dat.right_envlp_y_up, drift_params.Window_Around_Drift_For_Properties,...
            right_events, dat.enum, dat.right_usacc_props, dat.right_saccade_props);
        
        right_drift_speed = nanmean(dat.right_driftdat(:,dat.enum.driftdat.instspeed));
        right_drift_speed_std = nanstd(dat.right_driftdat(:,dat.enum.driftdat.instspeed));
        disp(['Mean Right Drift Speed: ' num2str(right_drift_speed,3) ' +/- ' num2str(right_drift_speed_std,3) ' deg/sec']);
        
    end
    if LEFT && RIGHT
        if abs(left_drift_speed - right_drift_speed) > .4
            disp('Careful, the left and right drift speed differ a lot so one eye may be too noisy.');
        end
    end
    
    
    % Calculate Drift filter averages
    filters = CorrGui.filter_conditions('get_condition_names', this);
    if ( LEFT )
        left_filter_averages = DriftProperties.GetFilterAverages(this, dat.left_driftdat, dat.left_drift_props, dat.trialMatrix, filters, dat.enum, sname);
        dat.left_filter_averages = mergestructs(dat.left_filter_averages, left_filter_averages);
        dat.left_driftdat = dat.left_driftdat(:,1:3); %% for now I dont want to save horizontal and vertical speeds, its too big
    end
    if ( RIGHT )
        right_filter_averages = DriftProperties.GetFilterAverages(this, dat.right_driftdat, dat.right_drift_props, dat.trialMatrix, filters, dat.enum, sname);
        dat.right_filter_averages = mergestructs(dat.right_filter_averages, right_filter_averages);
        dat.right_driftdat = dat.right_driftdat(:,1:3); %% for now I dont want to save horizontal and vertical speeds, its too big
    end
    
end

% ------------------------------------------------------------------------
%% subroutines ------------------------------------------------------------
% ------------------------------------------------------------------------
function is = isAllNaN( v )
% is = any(isnan(v));
is = sum(isnan(v)) == length(v);
% if ( ~is )
%     is = (var(v) < .01 );
% end


function [events, event] = sort_events( usac, sac, blink, trial)

event.USACC = 1;
event.SACC = 2;
event.BLINK = 3;
event.TRIALSTART = 4;
event.TRIALSTOP = 5;

% I will put togheter all the possible events
% I will sort them by index number keeping the type of event and the index
% index of the event related (microsaccade, saccade, or blink

usacc_starts = zeros(size(usac,1),4);
if ( ~isempty( usac) )
    usacc_starts(:,1) = 1:size(usac,1);
    usacc_starts(:,2) = event.USACC*ones(size(usac,1),1);
    usacc_starts(:,3) = usac(:,1);
    usacc_starts(:,4) = usac(:,2);
end

saccade_starts = zeros(size(sac,1),4);
if ( ~isempty(sac))
    saccade_starts(:,1) = 1:size(sac,1);
    saccade_starts(:,2) = event.SACC*ones(size(sac,1),1);
    saccade_starts(:,3) = sac(:,1);
    saccade_starts(:,4) = sac(:,2);
end

blink_starts = zeros(size(blink,1),4);
if ( ~isempty(blink))
    blink_starts(:,1) = 1:size(blink,1);
    blink_starts(:,2) = event.BLINK*ones(size(blink,1),1);
    blink_starts(:,3) = blink(:,1);
    blink_starts(:,4) = blink(:,2);
end

trial_starts = zeros(size(trial,1),4);
trial_ends = zeros(size(trial,1),4);
if ( ~isempty(trial))
    trial_starts(:,1) = 1:size(trial,1);
    trial_starts(:,2) = event.TRIALSTART*ones(size(trial,1),1);
    trial_starts(:,3) = trial(:,1);
    trial_starts(:,4) = trial(:,1);
    
    trial_ends(:,1) = 1:size(trial,1);
    trial_ends(:,2) = event.TRIALSTOP*ones(size(trial,1),1);
    trial_ends(:,3) = trial(:,2);
    trial_ends(:,4) = trial(:,2);
end

events = [usacc_starts;saccade_starts;blink_starts;trial_starts;trial_ends];

events = sortrows(events,3);


% ------------------------------------------------------------------------
% -- process_pupil -------------------------------------------------------
% ------------------------------------------------------------------------
% function [ pup_percent_increase, pup_change ] = process_pupil( pup , trials_on, trials_off, isGoodSample  )
% 
% % trials_on	= find(  diff( [0;isInTrial]) > 0);
% % trials_off	= find( diff( [isInTrial;0])  < 0 );
% 
% pup( not( isGoodSample ) ) = NaN; %make blinks (eyelink blinks + our extra suround)= NaN
% 
% pup_percent_increase = NaN( size( pup ) );
% 
% for i = 1 : length(trials_on),
%     %     baseline = Means(pup(trials_on(i):trials_off(i)));
%     baseline = nanmean(pup(trials_on(i):trials_off(i))); %much faster
%     pup_percent_increase(trials_on(i):trials_off(i)) = devmn( pup(trials_on(i):trials_off(i)), baseline );
% end
% pup_change = [0;abs(diff(pup_percent_increase))];
% 
% 

%% ------------------------------------------------------------------------
%% -- process_averages ----------------------------------------------------
%% ------------------------------------------------------------------------

function [ pus, pif, mus, mag, dus, mps, filter_averages ] = process_averages( this, sname, rhos, usaccYesNo, good_len_ms, samplerate, enum,  usacc_props, trial_props)

usacc_magnitudes = usacc_props(:,enum.usacc_props.magnitude);

usacc_on	=  max( full(diff([0;usaccYesNo])), 0 );

% backfill
%bmag = backfill( usaccYesNo, rhos );				% backfill of magnitud
usacc_off	=  max( -diff([usaccYesNo;0 ]), 0);
rho2		= usacc_off;
rho2((usacc_off~=0)) = usacc_magnitudes;
bmag = backfill( usaccYesNo, rho2);

%bmag = bmag.*[0;diff(bmag)>0];
bdur = backfill( usaccYesNo, sawbin( double(usaccYesNo) ) );	% backfill of duration
bdur = bdur.*[0;diff(bdur)>0];
bdur = bdur / samplerate * 1000;

%% - Averages
% average microsaccade rate, the number of microsaccades divided by time
pus = sum(usacc_on) / good_len_ms * 1000; % (in microsaccades per second)
% prob of usacc in-flight , total time inside the microsaccades divided by the time
pif = sum(usaccYesNo)*(1000/samplerate) / good_len_ms;
% avg. magnitude, only milliseconds where usacc present
% dat.mus = ones(wind_size,1) * mean(bmag(intersect(good_idx,find(bmag))));
% dat.mus = ones(wind_size,1) * mean(bmag(good_idx)); %weight_sum(bmag)/good_len;
mus = mean( bmag((bmag~=0)) );

% avg. magnitude, all milliseconds
mag	= sum(rhos) / good_len_ms;

% average duration
% dat.dus=ones(wind_size,1)*mean(bdur(intersect(good_idx,find(bdur))));
% dat.dus=ones(wind_size,1)*mean(bdur(good_idx));
dus = mean( bdur( (bdur~=0) ) );


% pupil baseline: average size of pupil over all experiment (skiping blinks
% and inter-trial-intervals) - xgt - aug 26, 2006
% good_pupil = find(pup>0);
%good_pupil = find(not(isnan(pup)));
%mean_pupil_size = mean(pup(good_pupil));
%dat.mps = mean_pupil_size * ones(wind_size+shift,1);
mps = 0;
% mps_change = Means(pup_change);
% mps_change = nanmean(pup_change); %much faster


filter_averages = [];
%% - Average using filters
filters = CorrGui.filter_conditions( 'get_condition_names', this );
for i=1:length(filters)
    
    usacc_idx = CorrGui.filter_conditions(this, usacc_props(:,enum.usacc_props.condition), i, enum, sname);
    trial_idx = CorrGui.filter_conditions(this, trial_props(:,enum.trial_props.CondIndex), i, enum, sname);
    
    isInTrialFilter = make_isInTrialFilter(trial_props(:,enum.trial_props.CondIndex), enum, sname, this, i);
    trialOnOffIdxFilter = [trial_props(isInTrialFilter, enum.trial_props.StartIndex), trial_props(isInTrialFilter, enum.trial_props.EndIndex)];
    idx = make_YesNo_vector(trialOnOffIdxFilter(:,1), trialOnOffIdxFilter(:,2), length(usaccYesNo));
    
    %idx = CorrGui.filter_conditions(this, isInTrialCond, i, enum, sname);
    
    %% - Averages
    % average microsaccade rate, the number of microsaccades divided by time
    pus = length(usacc_idx) / sum(trial_props(trial_idx,enum.trial_props.Duration))*1000; % (in microsaccades per second)
    filter_averages.(['pus_' filters{i}]) = pus;
    
    % prob of usacc in-flight , total time inside the microsaccades divided by the time
    pif = sum(usacc_props(usacc_idx, enum.usacc_props.duration))*(1000/samplerate) / sum(trial_props(trial_idx,enum.trial_props.Duration));
    filter_averages.(['pif_' filters{i}]) = pif;
    
    % avg. magnitude, only milliseconds where usacc present
    bmagfilter = bmag(idx);
    mus = mean( bmagfilter((bmagfilter~=0)) );
    filter_averages.(['mus_' filters{i}]) = mus;
    
    % avg. magnitude, all milliseconds
    rhosfilter = rhos(idx);
    mag	= sum(rhosfilter) / sum(trial_props(trial_idx,enum.trial_props.Duration));
    filter_averages.(['mag_' filters{i}]) = mag;
    
    % average duration
    bdurfilter = bdur(idx);
    dus = mean( bdurfilter( (bdurfilter~=0) ) );
    filter_averages.(['dus_' filters{i}]) = dus;
    
    
    % pupil baseline: average size of pupil over all experiment (skiping blinks
    mps = 0;
    filter_averages.(['mps_' filters{i}]) = mps;
%     pup_chage_filter = pup_change(idx);
    %     mps_change = Means(pup_chage_filter);
%     mps_change = nanmean(pup_chage_filter); %much faster
%     filter_averages.(['mps_change_' filters{i}]) = mps_change;
end



% ------------------------------------------------------------------------
% -- backfill ------------------------------------------------------------
% ------------------------------------------------------------------------
function bfilldat = backfill(onoff,bfilldat)
% backfill data
donset	= find( diff( onoff ) == 1 ) + 1;
doffset = find( diff( onoff ) == -1 );
if length(donset) > length(doffset)
    doffset(end+1) = length(bfilldat);
end
for j=1:length(doffset)
    bfilldat(donset(j):doffset(j)) = bfilldat(doffset(j));
end

function enum = get_enums( enum )
enum.eyedat.x           = 1;
enum.eyedat.y           = 2;
enum.eyedat.vx          = 3;
enum.eyedat.vy          = 4;
enum.eyedat.accrho      = 5;
enum.eyedat.polar_vel   = 6;
enum.eyedat.turn        = 7;
enum.eyedat.turn_vel    = 8;
enum.eyedat.acceleration = 9;

enum.eyeflags.good_sample   = 1;
enum.eyeflags.usacc         = 2;
enum.eyeflags.blink         = 3;
enum.eyeflags.saccade       = 4;
enum.eyeflags.drift         = 5;
enum.eyeflags.overshoot     = 6;
enum.eyeflags.monocular     = 7;
enum.eyeflags.nothing       = 8;

% enum.pup_dat.pupil_size = 1;
% enum.pup_dat.pupil_change = 2;
% 
% enum.pupil_samples.left = 1;
% enum.pupil_samples.right = 2;


% function dat = fix_variables(dat)
% enum = get_enums(dat.enum);
% dat.enum = enum;
% 
% % if ( isfield(dat, 'trialMatrix' ) && ~isempty(dat.trialMatrix) && (sum(dat.trialMatrix(~isnan(dat.trialMatrix(:))))>0))
% %     trialStartRecording = binscr(dat.samples(:,1),dat.trialMatrix(dat.enum.trialMatrix.recstartTS,:));
% %
% %     dat.isInTrialNumber = zeros(size(dat.isInTrial));
% %     dat.isInTrialNumber(trialStartRecording)=1;
% %     dat.isInTrialNumber = int16(cumsum(dat.isInTrialNumber).*dat.isInTrial);
% %
% %     dat.isInTrialCond = zeros(size(dat.isInTrial),'int16');
% %     dat.isInTrialCond(dat.isInTrialNumber > 0) = dat.trialMatrix(dat.enum.trialMatrix.condition,dat.isInTrialNumber(dat.isInTrialNumber > 0));
% % else
% 
% if ( ~isfield(dat, 'isInTrialNumber' ) )
%     trialStartRecording = diff([0;dat.isInTrial])==1;
%     dat.isInTrialNumber = zeros(size(dat.isInTrial));
%     dat.isInTrialNumber(trialStartRecording)=1;
%     dat.isInTrialNumber = cumsum(dat.isInTrialNumber).*dat.isInTrial;
% end
% 
% if ( ~isfield(dat, 'isInTrialCond' ) )
%     dat.isInTrialCond = zeros(size(dat.isInTrial),'int16');
%     dat.isInTrialCond(dat.isInTrialNumber > 0) = dat.trialMatrix(1,dat.isInTrialNumber(dat.isInTrialNumber > 0));
% end
% % end


% function dat = surrogate( sname, dat, S )
% % S.Surrogate = 1;
% if ( isfield( S, 'Surrogate' ) )
%     SURROGATE = S.Surrogate;
%     if ( SURROGATE ==2)
%         dat.samples =  CorruiDB.Getsessvar(sname, 'surrsamples');
%     elseif ( SURROGATE ==1 )
%         dat.samples = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'samples');
%         if ( LEFT )
%             eyeflags = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'left_eyeflags');
%             fixations = eyeflags(:,1) & ~eyeflags(:,4);
%             
%             idx_fixations = find(fixations);
%             %x
%             vx_fixation = [0;diff(dat.samples(:,2))];
%             vx_fixation(idx_fixations) = shuffle(vx_fixation(idx_fixations));
%             dat.samples(:,2) = cumsum(vx_fixation);
%             
%             %y
%             vy_fixation = [0;diff(dat.samples(:,3))];
%             vy_fixation(idx_fixations) = shuffle(vy_fixation(idx_fixations));
%             dat.samples(:,3) = cumsum(vy_fixation);
%         end
%         if ( RIGHT )
%             eyeflags = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'right_eyeflags');
%             fixations = eyeflags(:,1) & ~eyeflags(:,4);
%             
%             idx_fixations = find(fixations);
%             %x
%             vx_fixation = [0;diff(dat.samples(:,4))];
%             vx_fixation(idx_fixations) = shuffle(vx_fixation(idx_fixations));
%             dat.samples(:,4) = cumsum(vx_fixation);
%             
%             %y
%             vy_fixation = [0;diff(dat.samples(:,5))];
%             vy_fixation(idx_fixations) = shuffle(vy_fixation(idx_fixations));
%             dat.samples(:,5) = cumsum(vy_fixation);
%         end
%         dat2.surrsamples = dat.samples;
%         CorruiDB.Add(sname, dat2);
%         clear dat2;
%     elseif ( SURROGATE ==3 )
%         if ( RIGHT )
%             % orig_samples = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'samples');
%             % usacc_props = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'right_usacc_props');
%             eyeflags = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'right_eyeflags');
%             fixations = eyeflags(:,1) & ~eyeflags(:,4);
%             starts = find(diff([0;fixations(:,1)])>0);
%             ends = find(diff([fixations(:,1);0])<0);
%             for i=1:length(starts)
%                 s = starts(i);
%                 e = ends(i);
%                 if ( mod(s-e,2)==1)
%                     x = dat.samples(s:e-1,4);
%                     xx = cumsum(shuffle([0;diff(x)]));
%                     dat.samples(s:e-1,4) = dat.samples(s,4)+xx;
%                     dat.samples(e:end,4) = dat.samples(e:end,4) - dat.samples(e,4) + dat.samples(e-1,4);
%                     y = dat.samples(s:e-1,5);
%                     yy = cumsum(shuffle([0;diff(y)]));
%                     dat.samples(s:e-1,5) = dat.samples(s,5)+yy;
%                     dat.samples(e:end,5) = dat.samples(e:end,5) - dat.samples(e,5) + dat.samples(e-1,5);
%                 else
%                     x = dat.samples(s:e,4);
%                     xx = cumsum(shuffle([0;diff(x)]));
%                     dat.samples(s:e,4) = dat.samples(s,4)+xx;
%                     dat.samples(e+1:end,4) = dat.samples(e+1:end,4) - dat.samples(e+1,4) + dat.samples(e,4);
%                     y = dat.samples(s:e,5);
%                     yy = cumsum(shuffle([0;diff(y)]));
%                     dat.samples(s:e,5) = dat.samples(s,5)+yy;
%                     dat.samples(e+1:end,5) = dat.samples(e+1:end,5) - dat.samples(e+1,5) + dat.samples(e,5);
%                 end
%             end
%         end
%         if ( LEFT )
%             % usacc_props = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'left_usacc_props');
%             eyeflags = CorruiDB.Getsessvar(strrep(sname,'surr',''), 'left_eyeflags');
%             fixations = eyeflags(:,1) & ~eyeflags(:,4);
%             starts = find(diff([0;fixations(:,1)])>0);
%             ends = find(diff([fixations(:,1);0])<0);
%             for i=1:length(starts)
%                 s = starts(i);
%                 e = ends(i);
%                 if ( mod(s-e,2)==1)
%                     x = dat.samples(s:e-1,2);
%                     xx = cumsum(shuffle([0;diff(x)]));
%                     dat.samples(s:e-1,2) = dat.samples(s,2)+xx;
%                     dat.samples(e:end,2) = dat.samples(e:end,2) - dat.samples(e,2) + dat.samples(e-1,2);
%                     y = dat.samples(s:e-1,3);
%                     yy = cumsum(shuffle([0;diff(y)]));
%                     dat.samples(s:e-1,3) = dat.samples(s,3)+yy;
%                     dat.samples(e:end,3) = dat.samples(e:end,3) - dat.samples(e,3) + dat.samples(e-1,3);
%                 else
%                     x = dat.samples(s:e,2);
%                     xx = cumsum(shuffle([0;diff(x)]));
%                     dat.samples(s:e,2) = dat.samples(s,2)+xx;
%                     dat.samples(e+1:end,2) = dat.samples(e+1:end,2) - dat.samples(e+1,2) + dat.samples(e,2);
%                     y = dat.samples(s:e,3);
%                     yy = cumsum(shuffle([0;diff(y)]));
%                     dat.samples(s:e,3) = dat.samples(s,3)+yy;
%                     dat.samples(e+1:end,3) = dat.samples(e+1:end,3) - dat.samples(e+1,3) + dat.samples(e,3);
%                 end
%             end
%         end
%         dat2.surrsamples = dat.samples;
%         CorruiDB.Add(sname, dat2);
%         clear dat2;
%     end
% end
function opt = getProcessStage1Options( this )
% EXPERIMENT.GETPROCESSSTAGE1OPTIONS default stage 1 process options
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: 03/16/2014  9:18:23.078 PM
% $Revision: 0.2 $  $Date: Thu 08/18/2016 12:09:35.283 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% S.Do_Stage_1			= { {'{0}','1'} };
% ----- filter eye signal options -----
% (1) boxcar lpf
S.Low_pass_filter		= { {'{0}','1'} };
S.Low_pass_filter_freq  = { 100 '* (Hz)'};
% (2) wavelet filter
S.Wavelet_Filter = { {'{0}','1'} };
S.Wavelet_Filter_Options.Wavelet_Name = {{'db1','{db4}','dmey'}};
S.Wavelet_Filter_Options.Decomposition_Level = {3 '' [1 100]};

% ----- microsaccade detection algorithm options -----
% (1) Engbert approach
S.Use_Engbert_Algorithm = { {'0','{1}'} };
S.Engbert_options.velocity_factor  = { 6 '* (times std)' };
S.Engbert_options.minimum_duration = { 12 '* (samples)' };

% (2) MMC approach
S.Use_MMC_Algorithm                 = { {'{0}','1'} };
S.MMC_options.Smoothing_Method		= {{'None' '{Boxcar}' 'Savitsky-Golay'}};
S.MMC_options.Smoothing_Parameter_1 = { 31 '* (ms)' [1 1000]};
S.MMC_options.Smoothing_Parameter_2 = { 31 '* (ms)' [1 1000] };
S.MMC_options.Velocity_threshold    = { 3 '* (deg/s)' [0 200] };

% other options for microsaacade detection
S.Remove_Overshoots		= { {'0','{1}'} };
S.Overshoot_Time        = { 20 '* (ms)' };     % 100 ms another option (definition overshoot time, refraction?)
S.Remove_Monoculars		= { {'{0}','1'} };
S.Binoculars_Minimum_Overlap    = { 1 '* (samples)' };
S.Maximum_usac_magnitude = { 2 '* (deg)' [0 200] };

% ----- SWJ detection algorithm options -----
S.Detect_SWJ                = { {'{0}','1'}, 'Detect Square-wave-jerks' };
% direction difference
S.Detect_SWJ_options.DM     = { [180 180], 'Means of direction difference' [0 360] };
S.Detect_SWJ_options.DS     = { [40 40], 'SD of direction difference', [0 Inf] };
S.Detect_SWJ_options.DR     = { [0.4 0.6], 'Relative weight for direction difference', [0 1]};
% relative magnitude
S.Detect_SWJ_options.RM     = { [0 0], 'Means of relative magnitue' [-1 1] };
S.Detect_SWJ_options.RS     = { [0.26 0.26], 'SD of relative magnitue', [0 Inf] };
S.Detect_SWJ_options.RR     = { [0.4 0.6], 'Relative weight for relative magnitude', [0 1]};
% swj isi
S.Detect_SWJ_options.ISIP   = { [70 25 260], 'Parameters of inter SWJ interval', [0 1000] };
S.Detect_SWJ_options.swjindexth = { 0.0029, 'SWJ Index threshold', [0 1] };

% ----- drifting analysis options -----
S.Calculate_Drift = { {'{0}','1'} };
% S.Drift_Options.Window_Around_Drift_For_Filter = 5; %ms time cut at beginning and end of each drift
% S.Drift_Options.Window_Around_Drift_For_Properties = 40; %ms time cut at beginning and end of each drift%
% S.Drift_Options.Drift_Algorithm = {{'{HP_Filter}','Low_Pass_Filter','Smoothing_Filter'}};
% S.Drift_Options.Minimum_Drift_Length = 200; %ms minimimum drift length to consider

opt = S;

end % function getProcessStage1Options

% [EOF]

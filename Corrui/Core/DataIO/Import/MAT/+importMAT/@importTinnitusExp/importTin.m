function tin = importTin(this, datafile)
% IMPORTTINNITUSEXP.IMPORTTIN imports Tinnitus MAT file to MatLab space
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

% Copyright 2013 Richard J. Cui. Created: 11/03/2013  1:04:47.492 AM
% $Revision: 0.2 $  $Date: Tue 11/26/2013  4:43:16.822 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

subj_class = this.Clinic.SubjectClass;
dat = load(datafile, '-mat');     % tinnitus subject data

switch subj_class
    case 'Patient'  % patient data
        tin = getPatientData(this, dat);
    case 'Control'  % control subject data
        tin = getControlData(this, dat);
end % switch    

% output to class properties
this.enum           = tin.enum;
this.ExpSR          = tin.ExpSR;
this.EyeSignal      = tin.EyeSignal;
this.CH1            = tin.CH1;
this.ExpBlinkYN     = tin.ExpBlinkYN;
this.Comment        = tin.Comment;
this.ExpDate        = tin.ExpDate;
this.OriginalFile   = tin.OriginalFile;
this.StartTime      = tin.StartTime;

end % function importTin

% =========================================================================
% subroutines
% =========================================================================
function tin = getPatientData(this, dat)

% get data
% ---------
ExpSR           = dat.SamplingRate;
Comment         = dat.Comment;
ExpDate         = dat.Date;
OriginalFile    = dat.OriginalFile;
StartTime       = str2double(dat.Start_Time);

eye_data    = dat.Data;
data_name   = dat.DataNames;
data_unit   = dat.DataUnits;
[EyeSignal, CH1, enum] = getEyeSig(eye_data, data_name, data_unit, this.sessname);

[expblinkyn, enum]  = getExpBlinkYN(EyeSignal, enum);

tin.enum           = enum;
tin.ExpSR          = ExpSR;
tin.EyeSignal      = EyeSignal;
tin.CH1            = CH1;
tin.ExpBlinkYN     = expblinkyn;
tin.Comment        = Comment;
tin.ExpDate        = ExpDate;
tin.OriginalFile   = OriginalFile;
tin.StartTime      = StartTime;

end % function

function [eye_sig, ch1, enum] = getEyeSigCtrl(eye_data, data_name, data_unit, sessname, fix_pos_index)
% for control subject

% enum.EyeSignal
% --------------
enum.EyeSignal.left_x   = 1;
enum.EyeSignal.left_y   = 2;
enum.EyeSignal.right_x  = 3;
enum.EyeSignal.right_y  = 4;
eye_sig_field = fieldnames(enum.EyeSignal);
num_fields = length(eye_sig_field);

dname = cellstr(data_name);
dunit = cellstr(data_unit);
num_name = length(dname);

% fixation in center in Control
sig_len = length(eye_data(:, enum.EyeSignal.left_x));  % signal length
ch1 = fix_pos_index.Center * ones(sig_len, 1);

% get eye signal
eye_sig = NaN(sig_len, num_fields);
for k = 1:num_name
    name_k = dname{k};
    switch name_k
        case 'leftX'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.left_x) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in data %s.', sessname)
            end % if

        case 'leftY'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.left_y) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if

        case 'rightX'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.right_x) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if

        case 'rightY'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.right_y) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if
            
    end % switch
end % for

% check completeness
for k = 1:num_fields
    eye_sig_k = eye_sig(:, k);
    if logical(sum(eye_sig_k(~isnan(eye_sig_k)))) == false
        warning('importTinnitusExp:importTin', ...
                    '%s eye data is not provided in dataset %s.', ...
                    eye_sig_field{k}, sessname)
    end % if
end % for

end % function

function tin = getControlData(this, dat)

% get data
% ---------
ExpSR           = dat.SamplingRate;
Comment         = dat.Comment;
ExpDate         = dat.Date;
OriginalFile    = dat.OriginalFile;
StartTime       = str2double(dat.Start_Time);

eye_data    = dat.Data;
data_name   = dat.DataNames;
data_unit   = dat.DataUnits;
[EyeSignal, CH1, enum] = getEyeSigCtrl(eye_data, data_name, data_unit, ...
    this.sessname, this.FixPosIndex);

[expblinkyn, enum]  = getExpBlinkYN(EyeSignal, enum);

tin.enum           = enum;
tin.ExpSR          = ExpSR;
tin.EyeSignal      = EyeSignal;
tin.CH1            = CH1;
tin.ExpBlinkYN     = expblinkyn;
tin.Comment        = Comment;
tin.ExpDate        = ExpDate;
tin.OriginalFile   = OriginalFile;
tin.StartTime      = StartTime;

end % function

function [eye_sig, ch1, enum] = getEyeSig(eye_data, data_name, data_unit, sessname)

% enum.EyeSignal
% --------------
enum.EyeSignal.left_x   = 1;
enum.EyeSignal.left_y   = 2;
enum.EyeSignal.right_x  = 3;
enum.EyeSignal.right_y  = 4;
eye_sig_field = fieldnames(enum.EyeSignal);
num_fields = length(eye_sig_field);

dname = cellstr(data_name);
dunit = cellstr(data_unit);
num_name = length(dname);

% get CH1 info
if strcmp(dname{num_name}, 'CH1')
    ch1 = eye_data(:, num_name);
else
    error('importTinnitusExp:importTin', ...
        'No CH1 data can be found in data %s.', sessname)
end % if

% get eye signal
sig_len = length(ch1);
eye_sig = NaN(sig_len, num_fields);
for k = 1:num_name - 1
    name_k = dname{k};
    switch name_k
        case 'leftX'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.left_x) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in data %s.', sessname)
            end % if

        case 'leftY'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.left_y) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if

        case 'rightX'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.right_x) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if

        case 'rightY'
            if strcmpi(dunit{k}, 'deg')
                eye_sig(:, enum.EyeSignal.right_y) = eye_data(:, k);
            else
                error('importTinnitusExp:importTin', ...
                    'Unit of eye data is not deg in dataset %s.', sessname)
            end % if
            
    end % switch
end % for

% check completeness
for k = 1:num_fields
    eye_sig_k = eye_sig(:, k);
    if logical(sum(eye_sig_k(~isnan(eye_sig_k)))) == false
        printf('%s eye data is not provided in dataset %s.\n', ...
                    eye_sig_field{k}, sessname)
    end % if
end % for

end % function

function [blink_yn, enum] = getExpBlinkYN(eye_sig, enum)

enum.ExpBlinkYN.left_x  = 1;
enum.ExpBlinkYN.left_y  = 2;
enum.ExpBlinkYN.right_x = 3;
enum.ExpBlinkYN.right_y = 4;

blink_yn = false(size(eye_sig));

num_ch = size(eye_sig, 2);
for k = 1:num_ch
    sig_k = eye_sig(:, k);
    yn_k = isnan(sig_k);
    blink_yn(:, k) = yn_k;
end % for
end

% [EOF]

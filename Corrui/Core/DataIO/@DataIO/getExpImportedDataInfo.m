function imported_data = getExpImportedDataInfo(imported_data)
% DATAIO.GETEXPIMPORTEDDATAINFO gets info about experiment specified imported data
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

% Copyright 2013-2020 Richard J. Cui. Created: 11/02/2013  4:26:27.119 PM
% $Revision: 0.2 $  $Date: Wed 03/25/2020 12:06:03.605 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% TODO: thie following parts should be implemented by different experiment
% eye sample info
% ----------------
% construct enum if necessary
if isfield(imported_data, 'samples')   % RJC - Nov'11
    imported_data.info.samples_length = length( imported_data.samples );
end

if isfield(imported_data, 'samples') && (~isfield(imported_data, 'enum')||~isfield(imported_data.enum, 'samples'))
    imported_data.enum.samples.timestamps   = 1;
    imported_data.enum.samples.left_x       = 2;
    imported_data.enum.samples.left_y       = 3;
    imported_data.enum.samples.right_x      = 4;
    imported_data.enum.samples.right_y      = 5;
    imported_data.enum.pupil_samples.left_pupil_size    = 1;
    imported_data.enum.pupil_samples.right_pupil_size   = 2;
end

% spike time info
% ----------------
if isfield(imported_data, 'spiketimes')
    imported_data.enum.spiketimes.timestamps    = 1;
    imported_data.enum.spiketimes.timeindex     = 2;
end % if

end % function getExpImportedDataInfo

% [EOF]

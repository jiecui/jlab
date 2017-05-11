function result_dat = CellGratingResponse(current_tag, name, S, dat)
% CELLGRATINGRESPONSE analyzes the grating response of the cell, i.e.
%       firing rate of the cells in response to grating stimuli with different
%       spatial frequencies and drifting speeds.
%
% Syntax:
%   result_dat = CellGratingResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat      - .GratReponse = number of speed x number of spatial
%                                    freq x 3 array, where the first matrix
%                                    is the mean rate, 2nd std, and 3rd
%                                    sem.
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Thu 05/24/2012 10:25:30.379 PM
% $Revision: 0.1 $  $Date: Thu 05/24/2012 10:25:30.379 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% input parameters
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    %     opt.tfmethod = {'{affine}|lwm'};
    %     opt.Latency = {30 '* (ms)' [0 1000]};
    %     opt.spike_map_threshold = {3 '* (std)' [1 10]}; % Spike map thres. The spikes mapped
    %         % outside the fix grid more than SMThres * STDs will be discarded
    %     opt.normalized_spike_map = { {'{0}','1'} };
    %     opt.smooth_size = {40 '' [1 100]};
    %     opt.smooth_sigma = {10 '' [1 100]};
    
    %     opt.smoothed_image = {{'0','{1}'}};
    
    opt = [];
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'LastGratChunk'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
grat = dat.LastGratChunk;

% find the number of repeats
% --------------------------
tse = grat.TrialStartEnd;       % time stamps of trial start-end
start1 = [tse(1,:).start];      % start time for condition 1
numrep = sum(start1 > 0);

% get mean rate of channel A
% --------------------------
mra = grat.MeanRateA;

% get std of rate
% ----------------
std = grat.StdRateA;

% get sem of rate
% ----------------
sem = std./sqrt(numrep);

grat_response = cat(3, mra, std, sem);

% max / min response for speed = 0
mra0 = mra(1,:);
sem0 = sem(1,:);

[maxmra, maxidx] = max(mra0);
[minmra, minidx] = min(mra0);

max_sem = sem0(maxidx);
min_sem = sem0(minidx);
maxdis = maxmra-minmra;
maxerr = max_sem+min_sem;

fprintf(sprintf('max mean rate = %g\n', maxmra))
fprintf(sprintf('min mean rate = %g\n', minmra))
fprintf(sprintf('dis - maxerror = %g\n', maxdis - maxerr))

% ++++++++++++++++++++++++
% commit results
% ++++++++++++++++++++++++
result_dat.GratResponse = grat_response;   % grating response

end % function CellContrastResponse


% ====================================
% subroutines
% ====================================



% [EOF]

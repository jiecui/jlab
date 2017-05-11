function result_dat = AggCellMetrics(current_tag, sname, S, dat)
% MSACCCONTRASTANALYSIS.AGGANAECCENTRICITY Analysis of eccentricity
% 
% Description:
%   This function analyzes the cell's metrics in the aggregated data set.
%
% Syntax:
%   result_dat = AggPMT1Analysis(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat
%
% Example:
%
% See also .

% Copyright 2014 Richard J. Cui. Created: Thu 06/19/2014  9:02:13.323 AM
% $Revision: 0.2 $  $Date: Thu 06/19/2014  3:53:42.679 PM $
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
if strcmpi(current_tag,'get_options')
    % opt.signal_type = {'Spike rate|{Spike rate normalized}', 'Signal type'};
    opt = [];
    
    result_dat = opt;
    return
end % if

% =========================================================================
% load data need for analysis
% =========================================================================
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'LastConChunk'};
    
    result_dat = dat_var;
    return
end % if


% =========================================================================
% main body
% =========================================================================
% get the options
% ----------------
% signal_type = S.Stage_2_Options.([mfilename, '_options']).signal_type;

% get the data
% -------------
lcc = dat.LastConChunk;

% processing
% -------------
N = length(lcc);    % number of cells
fix = zeros(N, 2);  % fixation in pix
loc = zeros(N, 2);  % stimulus locations in pix
rf_size = zeros(N, 2);    % stimulus/RF size in pix = [width length]
ort = zeros(N, 1);  % preferred orientation (deg)
for k = 1:N
    cev_k = lcc{k}.ConEnvVars;  % condition enviornment variables of session k
    
    % fixation location
    fixx_k = cev_k.fixx;
    fixy_k = cev_k.fixy;
    fix(k, :) = [fixx_k, fixy_k];
    
    % stimulus location
    locx_k = cev_k.locx;
    locy_k = cev_k.locy;
    loc(k, :) = [locx_k, locy_k];
    
    % simulus size
    width_k = cev_k.bwidth;
    lengt_k = cev_k.blength;
    rf_size(k, :) = [width_k, lengt_k];
    % orientation
    ort_k = -cev_k.bangle;
    if ort_k < 0
        ort_k = 180 + ort_k;
    end % if
    ort(k) = ort_k;
end % for

% get relative loc in pix
relative_loc = loc - fix;
mean_rel = mean(relative_loc);

% get relative loc in dva
relative_loc_dva = relative_loc / 16;
mean_rel_dva = mean(relative_loc_dva);

% get simulus size in dva
rf_size_dva = rf_size / 16;

% quick check
% -----------
figure
plot(0, 0, 'r+')
hold on
plot(relative_loc(:, 1), relative_loc(:, 2), 'bo')
plot(mean_rel(1), mean_rel(2), 'b.', 'MarkerSize', 8)

figure
plot(0, 0, 'r+')
hold on
plot(relative_loc_dva(:, 1), relative_loc_dva(:, 2), 'bo')
plot(mean_rel_dva(1), mean_rel_dva(2), 'b.', 'MarkerSize', 8)

% =========================================================================
% commit results
% =========================================================================
result_dat.CellMetrics.Eccentricity.Fix = fix;
result_dat.CellMetrics.Eccentricity.Loc = loc;
result_dat.CellMetrics.Eccentricity.RelativeLoc.Pix = relative_loc;
result_dat.CellMetrics.Eccentricity.RelativeLoc.Dva = relative_loc_dva;
result_dat.CellMetrics.RFSize.Pix = rf_size;
result_dat.CellMetrics.RFSize.Dva = rf_size_dva;
result_dat.CellMetrics.Orientation = ort;

end % function StepContrastAnalysis

% =========================================================================
% subfunctions
% =========================================================================


% [EOF]

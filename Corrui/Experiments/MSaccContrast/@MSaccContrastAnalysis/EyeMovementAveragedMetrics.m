function result_dat = EyeMovementAveragedMetrics(current_tag, sname, S, dat)
% MSACCCONTRASTANALYSIS.EYEMOVEMENTAVERAGEDMETRICS get averaged eye characters
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Sat 08/06/2016  3:01:18.557 PM
% $ Revision: 0.1 $  $ Date: Sat 08/06/2016  3:01:18.564 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

% =========================================================================
% Input parameters and options
% =========================================================================
% specific options for the current process
if strcmpi(current_tag,'get_options')
    % opt.example = {2, 'AR order', [1 Inf]};
    opt = [];
    result_dat = opt;
    
    return
end % if

% =========================================================================
% Load data need for analysis
% =========================================================================
% specific data for the current process
if strcmpi(current_tag,'get_big_vars_to_load')
    result_dat = { 'samples', 'isInTrial', 'samplerate', 'left_eyedat',...
        'right_eyedat', 'left_eyeflags', 'right_eyeflags', 'enum', ...
        'left_usacc_props', 'right_usacc_props', 'trial_props'};
    
    return
end % if

% =========================================================================
% Get options and data
% =========================================================================
% options and parameters
% example = S.Stage_2_Options.([mfilename, '_options']).example;

% data
% example_dat = dat.example_dat;

% =========================================================================
% Main process
% =========================================================================
curr_exp = CorrGui.CheckTag(current_tag);

samples = array2table(dat.samples);
samples.Properties.VariableNames = {'Timestamps', 'LeftX', 'LeftY', 'RightX', 'RightY'};
[LEFT, RIGHT] = getWhichEye(samples);

if ( LEFT )
    result_dat.left_totaltime	= sum(  dat.isInTrial ) / dat.samplerate * 1000;
    [   result_dat.left_pus, ...
        result_dat.left_pif, ...
        result_dat.left_mus, ...
        result_dat.left_mag, ...
        result_dat.left_dus, ...
        result_dat.left_mps, ...
        result_dat.left_filter_averages...
        ] = process_averages( curr_exp, sname,  dat.left_eyedat(:,5), dat.left_eyeflags(:,2), result_dat.left_totaltime, dat.samplerate, dat.enum, dat.left_usacc_props, dat.trial_props);
end
if ( RIGHT )
    result_dat.right_totaltime = sum(  dat.isInTrial ) / dat.samplerate * 1000;
    [   result_dat.right_pus, ...
        result_dat.right_pif, ...
        result_dat.right_mus, ...
        result_dat.right_mag, ...
        result_dat.right_dus, ...
        result_dat.right_mps, ...
        result_dat.right_filter_averages...
        ] = process_averages( curr_exp, sname, dat.right_eyedat(:,5), dat.right_eyeflags(:,2), result_dat.right_totaltime, dat.samplerate, dat.enum, dat.right_usacc_props, dat.trial_props);
end

% =========================================================================
% Output
% =========================================================================

end % function EyeMovementAveragedMetrics

% =========================================================================
% Subroutines
% =========================================================================
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

% - Averages
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
% - Average using filters
filters = CorrGui.filter_conditions( 'get_condition_names', this );
for i=1:length(filters)
    
    usacc_idx = CorrGui.filter_conditions(this, usacc_props(:,enum.usacc_props.condition), i, enum, sname);
    trial_idx = CorrGui.filter_conditions(this, trial_props(:,enum.trial_props.condition), i, enum, sname);
    
    isInTrialFilter = make_isInTrialFilter(trial_props(:,enum.trial_props.condition), enum, sname, this, i);
    trialOnOffIdxFilter = [trial_props(isInTrialFilter, enum.trial_props.start_index), trial_props(isInTrialFilter, enum.trial_props.end_index)];
    idx = make_YesNo_vector(trialOnOffIdxFilter(:,1), trialOnOffIdxFilter(:,2), length(usaccYesNo));
    
    %idx = CorrGui.filter_conditions(this, isInTrialCond, i, enum, sname);
    
    % - Averages
    % average microsaccade rate, the number of microsaccades divided by time
    pus = length(usacc_idx) / sum(trial_props(trial_idx,enum.trial_props.duration))*1000; % (in microsaccades per second)
    filter_averages.(['pus_' filters{i}]) = pus;
    
    % prob of usacc in-flight , total time inside the microsaccades divided by the time
    pif = sum(usacc_props(usacc_idx, enum.usacc_props.duration))*(1000/samplerate) / sum(trial_props(trial_idx,enum.trial_props.duration));
    filter_averages.(['pif_' filters{i}]) = pif;
    
    % avg. magnitude, only milliseconds where usacc present
    bmagfilter = bmag(idx);
    mus = mean( bmagfilter((bmagfilter~=0)) );
    filter_averages.(['mus_' filters{i}]) = mus;
    
    % avg. magnitude, all milliseconds
    rhosfilter = rhos(idx);
    mag	= sum(rhosfilter) / sum(trial_props(trial_idx,enum.trial_props.duration));
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

end % function

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

end % function

% [EOF]

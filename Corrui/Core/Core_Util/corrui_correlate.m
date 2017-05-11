function  result_dat = corrui_correlate( varargin )
% dat = CORRUI_CORRELATE( data, events, options .. )
% dat = CORRUI_CORRELATE( dat, session_name, correlation_name, data, events, options .. )
% dat = CORRUI_CORRELATE( correlations, options .. )
% dat = CORRUI_CORRELATE( dat, session_name, correlation_name, correlations, options .. )
%
% DATA is the data we want to correlate
% EVENTS is the events we will correlate with
%   EVENTS can be a single event or two events. we will use two events to
%   calculate two different correlations when the two events interfire with
%   each other to limit the correlation window. For instance if you want to
%   go back only until the previous ovent of the other type. Events can
%   either be indices or an onset vector the length of the data vector we
%   are correlating to.
% DAT is the corrui variable with all the data loaded from the session
% SESSION_NAME is the name of the session in corrui
% CORRELATION_NAME is the name it will be given to the correlation variable
% CORRELATIONS is a cell of structures with one item per correlation to be
%   calculated. The fields are NAME (of the correlation), DATA and EVENTS.
%   In the case of double events two names should be provided too.
%
% OPTIONS:
%
%   - window_backward =
%   - window_forward =
%   - samplerate =
%   - isInTrial = can be a 1) logical YesNo vector indicating where we are in
%                    trial or 2) an nx2 matrix with trial onset indices in
%                    column 1 and trial offset indicies in column 2
%   - type of result =
%     1-AVERAGE : average of the lines of the raster (for continuous data)
%     2-HISTOGRAM : sum of the lines of the raster (for discrete data)
%     3-PROBABILITY : sum of the lines of the raster divided by the number of lines in the raster (for discrete data)
%     4-RATE : sum of the lines of the raster  divided by the number of lines in the raster times the samplerate (for discrete data)
%   - doraster =
%   - ONLY_PREVIOUS_PERIOD =
%   - PREV_PERIOD_FRACTION =
%   - NEXT_PERIOD_FRACTION =
%   - MIN_PREV_PERIOD_LENGTH =
%   - MIN_NEXT_PERIOD_LENGTH =
%   - INTERMEDIATE_SAVE = FLAG (save after any given correlation)
%   - SAVE_TOTALINFO = FLAG (save both the amount of time in trial for any given
%   point in the correlation and save the number of nonzero data points in
%   any given point in the correlation
%  
%
% EXAMPLES:
%
%     dat1 = corrui_correlate( left_usacc_on, pr_on , 'type_of_result', 4);
%     dat1 = corrui_correlate( dat, sname, correlation_name, left_usacc_on, pr_on ,window_backward, window_forward, 'type_of_result', 4);
%     dat1 = corrui_correlate( dat, sname, correlation_name, left_usacc_on, pr_on ,window_backward, window_forward, 'type_of_result', 4);
%     dat1 = corrui_correlate( dat, sname, correlation_name, left_usacc_on, pr_on ,window_backward, window_forward, samplerate, dat.isInTrial, 'type_of_result', 4);
%
%     options.window_backward = window_backward;
%     options.window_forward = window_forward;
%     options.samplerate = samplerate;
%     options.isInTrial = dat.isInTrial;
%     options.type_of_result = 4;
%     dat1 = corrui_correlate( dat, sname, correlation_name, left_usacc_on, pr_on , options);
%
%
%     correlations{1}.name = {'left_corr_on_pr_on' 'left_corr_on_re_on'};
%     correlations{1}.data = left_usacc_on;
%     correlations{1}.events = {pr_on, re_on};
%     correlations{2}.name = {'right_corr_on_pr_on' 'right_corr_on_re_on'};
%     correlations{2}.name = {'right_corr_on_pr_on' 'right_corr_on_re_on'}
%     NOTE: if you pass only one name it will only do the first correlation and
%     no the second
%     correlations{2}.data = right_usacc_on;
%     correlations{2}.events = {pr_on, re_on};
%     options.window_backward = window_backward;
%     options.window_forward = window_forward;
%     options.samplerate = samplerate;
%     options.isInTrial = dat.isInTrial;
%     options.type_of_result = 4;
%     dat1 = corrui_correlate( dat, sname, correlations , options);
%
%     correlations{1}.name = {'left_corr_usacc_on_pupsize'};
%     correlations{1}.data = left_pupsize;
%     correlations{1}.events = left_usacc_on;
%     correlations{2}.name = {'right_corr_usacc_on_pupsize'};
%     correlations{2}.data = right_pupsize;
%     correlations{2}.events = right_usacc_on;
%     dat1 = corrui_correlate( dat, sname, correlations , window_backward, window_forward, samplerate, dat.isInTrial, 'type_of_result', 1, 'ONLY_PREVIOUS_PERIOD', 1);


%-- Parse imput parameters
p = check_parameters( varargin{:} );


if ( isfield(p, 'dat') )
    dat = p.dat;
    p = rmfield(p, 'dat');
end

if size(p.isInTrial,2) == 2
    trials_on_idx = p.isInTrial(:,1); % IF THE INDICIES ARE PASSED, THEN USE THEM (NOT REQUIRED THOUGH)
    trials_off_idx = p.isInTrial(:,2);% IF THE INDICIES ARE PASSED, THEN USE THEM (NOT REQUIRED THOUGH)
else
    trials_on_idx	= find(diff( [0;p.isInTrial]) > 0);		% indices of the trials onsets
    trials_off_idx	= find(diff( [p.isInTrial;0]) < 0);		% indices of the trials offsets
end

% convert window size to samples
wind_back	= round( p.window_backward / 1000 * p.samplerate );
wind_for	= round( p.window_forward / 1000 * p.samplerate );

% for each correlation we are going to do
for i=1:length(p.correlations)
    % corrent for cells of length 1
    if ( iscell( p.correlations{i}.events) && length( p.correlations{i}.events ) == 1 )
        p.correlations{i}.events = p.correlations{i}.events{1};
    end
    if ( iscell( p.correlations{i}.name) && length( p.correlations{i}.name )== 1  )
        p.correlations{i}.name = char( p.correlations{i}.name{1} );
    end
    
    % %      MAYBE UNECCESSARY
    %         if ~strcmp(class(p.correlations{i}.data), 'double')
    %             data = double(p.correlations{i}.data).* p.isInTrial;
    %         else
    %             data = p.correlations{i}.data.* p.isInTrial;
    %         end
        
    data = p.correlations{i}.data;
        
    % it can be a correlation with two different events or just one
    % that will matter when we want to go to the previous period specially
    if ( ~iscell( p.correlations{i}.events) ) % ONE EVENT, ONE NAME
        
        
        if ~isempty( p.correlations{i}.events )
            if length(data) == length(p.correlations{i}.events)
                evt1_idx = find(p.correlations{i}.events); % indices of the events
            else
                evt1_idx = p.correlations{i}.events;
            end
            
            [ correlation raster info] = ...
                correlate_data_with_events( data, evt1_idx, evt1_idx, trials_on_idx, trials_off_idx, wind_back, wind_for, p.samplerate, p.doraster, p.type_of_result, ...
                p.ONLY_PREVIOUS_PERIOD, p.PREV_PERIOD_FRACTION, p.NEXT_PERIOD_FRACTION, p.MIN_PREV_PERIOD_LENGTH, p.MIN_NEXT_PERIOD_LENGTH,p.SAVE_TOTALINFO,p.CONTINUOUS_DATA);
            
            result_dat.(p.correlations{i}.name) = correlation;
            result_dat.([p.correlations{i}.name '_raster']) = raster;
            result_dat.([p.correlations{i}.name '_info']) = info;
        end
        
    elseif ( iscell( p.correlations{i}.name)  )  % TWO EVENTS, TWO NAMES
        
        if length(data) == length( p.correlations{i}.events{1})
            evt1_idx = find( p.correlations{i}.events{1});		% indices of the events
            evt2_idx = find( p.correlations{i}.events{2});
        else
            evt1_idx = p.correlations{i}.events{1};
            evt2_idx = p.correlations{i}.events{2};
        end
        
        
        
        
        % run correlation for first event
        [ correlation raster info] = ...
            correlate_data_with_events( data, evt1_idx, evt2_idx, trials_on_idx, trials_off_idx, wind_back, wind_for, p.samplerate, p.doraster, p.type_of_result, ...
            p.ONLY_PREVIOUS_PERIOD, p.PREV_PERIOD_FRACTION, p.NEXT_PERIOD_FRACTION, p.MIN_PREV_PERIOD_LENGTH, p.MIN_NEXT_PERIOD_LENGTH,p.SAVE_TOTALINFO,p.CONTINUOUS_DATA);
        
        result_dat.(p.correlations{i}.name{1}) = correlation;
        result_dat.([p.correlations{i}.name{1} '_raster']) = raster;
        result_dat.([p.correlations{i}.name{1} '_info']) = info;
        
        % run correlation for second event
        [ correlation raster info] = ...
            correlate_data_with_events( data, evt2_idx, evt1_idx, trials_on_idx, trials_off_idx, wind_back, wind_for, p.samplerate, p.doraster, p.type_of_result, ...
            p.ONLY_PREVIOUS_PERIOD, p.PREV_PERIOD_FRACTION, p.NEXT_PERIOD_FRACTION, p.MIN_PREV_PERIOD_LENGTH, p.MIN_NEXT_PERIOD_LENGTH,p.SAVE_TOTALINFO,p.CONTINUOUS_DATA);
        
        result_dat.(p.correlations{i}.name{2}) = correlation;
        result_dat.([p.correlations{i}.name{2} '_raster']) = raster;
        result_dat.([p.correlations{i}.name{2} '_info']) = info;
        
    else   % TWO EVENTS, ONE NAME
        
        if length(data) == length( p.correlations{i}.events{1})
            evt1_idx = find(p.correlations{i}.events{1});		% indices of the events
            evt2_idx = find( p.correlations{i}.events{2});
        else
            evt1_idx = p.correlations{i}.events{1};
            evt2_idx = p.correlations{i}.events{2};
        end
        
        
        
        % run correlation for first event
        [ correlation raster info] = ...
            correlate_data_with_events( data, evt1_idx, evt2_idx, trials_on_idx, trials_off_idx, wind_back, wind_for, p.samplerate, p.doraster, p.type_of_result, ...
            p.ONLY_PREVIOUS_PERIOD, p.PREV_PERIOD_FRACTION, p.NEXT_PERIOD_FRACTION, p.MIN_PREV_PERIOD_LENGTH, p.MIN_NEXT_PERIOD_LENGTH,p.SAVE_TOTALINFO,p.CONTINUOUS_DATA);
        
        result_dat.(p.correlations{i}.name) = correlation;
        result_dat.([p.correlations{i}.name '_raster']) = raster;
        result_dat.([p.correlations{i}.name '_info']) = info;
    end
    
    % save data in the database
    if ( isfield(p,'sessname') && ~isempty(p.sessname) && p.INTERMEDIATE_SAVE )
        save_windows( p.sessname, p.window_backward, p.window_forward,  p.correlations{i}.name );
        save_vars( p.sessname, result_dat );
        result_dat = [];
    else
        result_dat = save_windows( result_dat, p.window_backward, p.window_forward,  p.correlations{i}.name );
    end
end



function p = check_parameters( varargin )

if ( nargin >=2)
    p = inputParser;   % Create an instance of the class.
    if ( (isstruct( varargin{1}) || isempty(varargin{1})) && ischar( varargin{2}) && ( iscell( varargin{3})) )
        p.addRequired('dat',@(x)isstruct(x)||isempty(x));
        p.addRequired('sessname', @isstr);
        p.addRequired('correlations',@iscell);
    elseif ( (isstruct( varargin{1}) || isempty(varargin{1})) && ischar( varargin{2}) && ( ~iscell( varargin{3})) )
        p.addRequired('dat',@(x)isstruct(x)||isempty(x));
        p.addRequired('sessname', @ischar);
        p.addRequired('name', @(x)ischar(x)||iscell(x));
        p.addRequired('data',@(x)(isnumeric(x)&& length(x)>1)||iscell(x));
        p.addRequired('events',@(x)(isnumeric(x)&& length(x)>1)||iscell(x));
    elseif ( iscell( varargin{1}))
        p.addRequired('correlations',@iscell);
    else
        p.addRequired('data',@(x)(isnumeric(x)&& length(x)>1)||iscell(x));
        p.addRequired('events',@(x)(isnumeric(x)&& length(x)>1)||iscell(x));
    end
    
    p.addOptional('window_backward', 1000, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('window_forward', 1000, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('samplerate',1000, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('isInTrial',[], @(x)isnumeric(x)||islogical(x));
    p.addOptional('type_of_result',1, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('doraster',0, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('ONLY_PREVIOUS_PERIOD',1, @(x)isscalar(x)&&~isstruct(x));
    p.addOptional('PREV_PERIOD_FRACTION',1, @(x)isscalar(x) && x>=0 && x<=1);
    p.addOptional('NEXT_PERIOD_FRACTION',1, @(x)isscalar(x) && x>=0 && x<=1);
    p.addOptional('MIN_PREV_PERIOD_LENGTH',0, @(x)isscalar(x) && x>=0);
    p.addOptional('MIN_NEXT_PERIOD_LENGTH',0, @(x)isscalar(x) && x>=0);
    p.addOptional('INTERMEDIATE_SAVE', 1, @(x)isscalar(x) && (x==0||x==1));
    p.addOptional('SAVE_TOTALINFO',0,@(x)isscalar(x) && (x==0||x==1));
    p.addOptional('CONTINUOUS_DATA',0,@(x)isscalar(x) && (x==0||x==1));
    
    
    p.StructExpand = true;
    p.parse(varargin{:});
    
    p = p.Results;
    if ( isfield(p,'data') && isfield(p,'events') )
        if ( isfield(p,'name') )
            p.correlations{1}.name = p.name;
        else
            p.correlations{1}.name = 'corr';
        end
        p.correlations{1}.data = p.data;
        p.correlations{1}.events = p.events;
    end
    if ( isempty( p.isInTrial ) )
        p.isInTrial = ones(size(p.correlations{1}.data));
    end
else
    throw('at least one parameter is necessary');
end


function [ corr, raster, info ]  = correlate_data_with_events( data, evt1_idx, evt2_idx, trials_on_idx, trials_off_idx, window_backward, window_forward, samplerate, DO_RASTER, TYPE_OF_RESULT, ...
    ONLY_PREVIOUS_PERIOD, PREV_PERIOD_FRACTION, NEXT_PERIOD_FRACTION, MIN_PREV_PERIOD_LENGTH, MIN_NEXT_PERIOD_LENGTH,SAVE_TOTALINFO,CONTINUOUS_DATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Params Check --------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ( ~exist( 'ONLY_PREVIOUS_PERIOD','var' ) )
    ONLY_PREVIOUS_PERIOD = 1;
end
if ( ~exist( 'PREV_PERIOD_FRACTION','var' ) )
    PREV_PERIOD_FRACTION = 1; % between 0 and 1!
end
if ( ~exist( 'NEXT_PERIOD_FRACTION','var' ) )
    NEXT_PERIOD_FRACTION = 1; % between 0 and 1!
end
if ( ~exist( 'MIN_PREV_PERIOD_LENGTH','var' ) )
    MIN_PREV_PERIOD_LENGTH = 0; %% in samples!
end
if ( ~exist( 'MIN_NEXT_PERIOD_LENGTH','var' ) )
    MIN_NEXT_PERIOD_LENGTH = 0; %% in samples!
end

doraster = DO_RASTER; % xgt tst


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Init ----------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BETTER TO JUST CALCULATE THE INDICIES ONCE AND SEND THOSE IN
% % % % trials_on_idx	= find(trials_on);		% indices of the trials onsets
% % % % trials_off_idx	= find(trials_off);		% indices of the trials offsets
% % % % evt1_idx			= find(events1);		% indices of the events
% % % % evt2_idx			= find(events2);		% indices of the events

sumdat			= zeros(window_backward + window_forward, 1);	% total data found in the window
to_add			= sumdat;
total_window	= sumdat;				% total possible amount of data found
avg				= sumdat;               % correlation result
nonzero_dat     = sumdat;
sumdat_squared  = sumdat;

li          = length(evt1_idx);        % number of events
dataLength  = size(data,1);            % size of data


if(doraster) % xgt tst
    raster = zeros(li,length(sumdat));
else
    raster = [];
end % end xgt tst

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Process -------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
    k=1;
    bad_evt1_idx = zeros(li,1);
    for n=1:li
        % start from the event time
        n_ms = evt1_idx(n);                

        % find the nearest event2 before and after
        prev_evt2_ms	=  evt2_idx(find(evt2_idx < n_ms,1,'last'));
        next_evt2_ms	=  evt2_idx(find(evt2_idx > n_ms,1,'first'));  %changed for drift to usacc correlations
        
      

        % find the nearest trial start and end before and after this event
        tstart_ms	=  trials_on_idx(find(trials_on_idx <= n_ms, 1, 'last')) ;
        tend_ms		=  trials_off_idx(find(trials_off_idx >= n_ms, 1, 'first'));    
        
        % check if the event is out of the trials
        tlastend_ms	=  trials_off_idx(find(trials_off_idx <= n_ms, 1, 'last')) ;    
        if ( tlastend_ms > tstart_ms )
            continue;
        end

        
        if ( ONLY_PREVIOUS_PERIOD )
            % get the length of the previous period
            if ( ~isempty(prev_evt2_ms) )
                prev_period_length = n_ms - max(prev_evt2_ms, tstart_ms);
            else
                prev_period_length = n_ms - tstart_ms;
            end
            % get the length of the previous period
            if ( ~isempty(next_evt2_ms) )
                next_period_length = min(next_evt2_ms, tend_ms) - n_ms;
            else
                next_period_length = tend_ms - n_ms;
            end
            
            % skip too short periods
            if ( prev_period_length < MIN_PREV_PERIOD_LENGTH )
                bad_evt1_idx(k) = n;
                k=k+1;
                continue;
            end
            if ( next_period_length < MIN_NEXT_PERIOD_LENGTH )
                bad_evt1_idx(k) = n;
                k=k+1;
                continue;
            end
            
            % modify tstart_ms/tend_ms to go only to the previous/next
            % period or fraction of it
            tstart_ms   = n_ms - floor( prev_period_length * PREV_PERIOD_FRACTION );
            tend_ms     = n_ms + floor( next_period_length * NEXT_PERIOD_FRACTION );
        end
        
        % -- Limits in the data -------------------------------------------
        % go back to window_backward before the event OR beginning of the trial
        dat_begin	= max( tstart_ms, max( n_ms - window_backward, 0 ) + 1 );
        % go ahead to window_forward after the event OR the ending of the trial
        dat_end		= min( n_ms + window_forward, tend_ms );
        
        % -- Limits in the correlation result -----------------------------
        sum_begin	=  window_backward - ( n_ms - dat_begin );
%         sum_end		=  window_backward - ( n_ms - dat_end ); 
        
        
        %THIS IS FASTER (MIKE)
          % skip NaNs (if they are there they indicate parts shouldn't add for the correlations)
        % from the part of the data you are looking at (dat_begin:dat_end)
        good_indices = find( ~ isnan( data(dat_begin:dat_end) ) );        
  
            
       % in case there are no good indicies
        if isempty(good_indices)
            continue
        end
        to_add(:)                               = 0;
        to_add(good_indices + sum_begin - 1)	= data(good_indices + dat_begin - 1);
        sumdat		= sumdat + to_add;
      
        
        %This will keep track of how many times nonzero data was in any
        %given spot for the correlation
        if SAVE_TOTALINFO
            sumdat_squared = sumdat_squared + to_add.^2;
            
            if ~CONTINUOUS_DATA
                current_nonzero_data_points = zeros(size(sumdat));
                idx = data(good_indices + dat_begin - 1) ~= 0;
                current_nonzero_data_points(good_indices(idx)+ sum_begin - 1) = 1;
                nonzero_dat = nonzero_dat + current_nonzero_data_points;
            end
            
        end
        
        if(doraster) % xgt tst
            raster(n,:) = NaN; % xgt tst
            raster(n,good_indices + sum_begin - 1) = data(good_indices + dat_begin - 1);
        end % end xgt tst
        
        to_add(good_indices + sum_begin - 1)	= 1;
        total_window = total_window + to_add;
        
    end
    
    if doraster && ~isempty(find(bad_evt1_idx, 1))
        raster(bad_evt1_idx,:) = [];
    end
    
catch
    rethrow(lasterror);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Result -------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if SAVE_TOTALINFO
    info.total_window = total_window;
    if CONTINUOUS_DATA
        info.nonzero_dat  = total_window;
    else
        info.nonzero_dat  = nonzero_dat;
    end
    info.sumdat = sumdat;
    info.sumdat_squared = sumdat_squared;
else
    info = [];
end
% avoid divide by zero
total_window(total_window==0) = NaN;

% divide the sum of all the data that occurred in the window by the amount
% of data possible in that part of the window
switch(TYPE_OF_RESULT)
    case 1 % average
        corr = sumdat ./ total_window;
    case 2 % histogram
        corr = sumdat;
    case 3 % probability
        corr = sumdat ./ total_window;
    case 4 % rate
        corr = sumdat ./ total_window * samplerate;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% -- Optional smoothing ? ------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% do again the correlation but now using the raster and a sliding window
% if ( doraster )
%     avg = sliding_window_raster( raster )
% end



function datout = save_windows( dat, window_backward, window_forward, varlist)
% each time we process a correlation it is necessary to save the last size of
% the window used to be able to plot correctly later

if ( isstruct( dat ) )
    datout = dat;
    if ~iscell(varlist)
       varlist = {varlist};
    end
       
    % if we are not save the data to the database the windows can be added
    % to dat
    % update the windos for the calculated variables 
    for var = varlist
        if ( ~strcmp( var, '') )
            varname = char(var);
            datout.window_backward.(varname) = window_backward;
            datout.window_forward.(varname) = window_forward;
        end
    end
else
    sname = dat;
    % get the current windows
    datwin = CorruiDB.Getsessvars( sname, {'window_backward' 'window_forward'});
    % update the windos for the calculated variables 
    if ( ~iscell(varlist) )
        varlist = {varlist};
    end
    for var = varlist
        if ( ~strcmp( var, '') )
            varname = char(var);
            datwin.window_backward.(varname) = window_backward;
            datwin.window_forward.(varname) = window_forward;
        end
    end
    % save the windows with the new values
    CorruiDB.Add( sname, datwin);
end



function save_vars( session_name, dat )
% it will save to the database all the fields that are not empty.
if ( isstruct( dat ) )
    fields = fieldnames( dat );
    for i=1:length(fields)
        fname = fields{i};
        if ( isempty( dat.( fname ) ) )
            dat = rmfield(dat, fname);
        end
    end
    CorruiDB.Add( session_name, dat);
end




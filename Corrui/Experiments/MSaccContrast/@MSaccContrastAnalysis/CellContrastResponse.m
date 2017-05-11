function result_dat = CellContrastResponse(current_tag, name, S, dat)
% CELLCONTRASTRESPONSE Analysis of the step-contrast response of the cell (archaic)
%
% Syntax:
%   result_dat = CellContrastResponse(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%   result_dat.cont_spkc
%               - number of spikes counted in the time interval (timeint)
%   result_dat.
%               -
% 
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 02/10/2012 11:45:21.187 AM
% $Revision: 0.8 $  $Date: Thu 10/04/2012 10:55:52.358 AM $
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

    opt.show_confidence_ellipse = {{'{0}', '1'}};
    opt.confidence_ellipse = {'{Not use}|FR based center|Mass center'};
    opt.normalization = {'{No}|Max %'};
    opt.plot_contrast_response = {{'{0}', '1'}};
    result_dat = opt;
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'mSaccConSig', 'FixSpot'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
mSaccConSig = dat.mSaccConSig;
FixSpot     = dat.FixSpot;
tran_time   = 300;      % transient portion of response (ms)
numCondition = size(mSaccConSig, 1);
numCycle = size(mSaccConSig(1).blink, 1);

% --------------------------------------------
% obtain valid time indexes of eye positions
% --------------------------------------------
% valid_time_YN = [];
% 
% for m = 1:numCondition
%     blink = [];
%     valid_time_YNm = [];
%     
%     for n = 1:numCycle
%         % stage 1 - blank
%         pos1_x = mSaccConSig(m, 1).eye_position.signal(:, n, 1);    % hor
%         pos1_y = mSaccConSig(m, 1).eye_position.signal(:, n, 2);    % hor
%         time1  = mSaccConSig(m, 1).eye_position.time_index(:, n);
%         % stage 2 - contrast 1
%         pos2_x = mSaccConSig(m, 2).eye_position.signal(:, n, 1);    % hor
%         pos2_y = mSaccConSig(m, 2).eye_position.signal(:, n, 2);    % hor
%         time2  = mSaccConSig(m, 2).eye_position.time_index(:, n);
%         % stage 3 - contrast 2
%         pos3_x = mSaccConSig(m, 3).eye_position.signal(:, n, 1);    % hor
%         pos3_y = mSaccConSig(m, 3).eye_position.signal(:, n, 2);    % hor
%         time3  = mSaccConSig(m, 3).eye_position.time_index(:, n);
%         % assemble eye positions
%         pos_x = [pos1_x; pos2_x; pos3_x];
%         pos_y = [pos1_y; pos2_y; pos3_y];
%         time  = [time1; time2; time3];
%         
%         % remove blinks
%         % =============
%         blink1 = mSaccConSig(m, 1).blink{n};
%         blink2 = mSaccConSig(m, 2).blink{n};
%         blink3 = mSaccConSig(m, 3).blink{n};
%         if blink1(1,1) ~= false
%             blink = cat(1, blink, blink1);
%         end % if
%         if blink2(1,1) ~= false
%             blink = cat(1, blink, blink2);
%         end % if
%         if blink3(1,1) ~= false
%             blink = cat(1, blink, blink3);
%         end % if
%         % some blinks may go cross over two stages, so need to find the
%         % unique blinks
%         if ~isempty(blink)
%             [~, idx] = unique(blink(:,1), 'first');
%             blink = blink(idx, :);
%             if ~isempty(blink)
%                 tmYN = removeBlink(time, blink);
%             else
%                 tmYN = ones(size(time));
%             end % if
%         else
%             tmYN = ones(size(time));
%         end % if
%         
%         % cal. confidence ellipse
%         % =======================
%         % get the eye position data
%         valid_x = pos_x(tmYN);
%         valid_y = pos_y(tmYN);
%         valid_seq = find(tmYN);     % sequence of valid time point
%         
%         % ++ get the center of the ellipse ++
%         % Note: Yoda's eye coil doesn't fix well, so this approach is not
%         % good. Try it on Hellboy.
%         if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'FR based center')
%             ellcent = FixSpot(n, :);    % ellipse center
%         end % if
%         
%         % Or, use mass center
%         if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Mass center')
%             ellcent = mean([valid_x, valid_y]);
%         end % if
%         % ++++++++++++++++++++++++++++++++++++
%         
%         if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'FR based center')...
%                 || strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Mass center')
%             % find the ellipse
%             [pc, ~, latent] = princomp([valid_x, valid_y]);
%             semi_x = sqrt(latent(1));
%             semi_y = sqrt(latent(2));
%             k1 = pc(2,1)/pc(1,1);   % k of the first pc
%             tilt_x = atan(k1);      % angle from the x-axis
%             
%             % cal points & draw the CE if required
%             % ========================
%             if plot_ellipse == true
%                 figure
%                 plot(valid_x, valid_y, '.')
%                 hold on
%                 plot(ellcent(1), ellcent(2), 'r+')
%                 axis equal
%                 
%                 [~, ex, ey] = ellipse(ellcent(1), ellcent(2), semi_x, semi_y,...
%                     plot_ellipse, tilt_x, 'k');
%             else
%                 [ex, ey] = ellipse(ellcent(1), ellcent(2), semi_x, semi_y, ...
%                     plot_ellipse, tilt_x, 'k');
%             end % if
%             ce = CEFit([ex, ey]);
%             
%             % find the area includes valid eye position
%             % =========================================
%             D = [valid_x.*valid_x, valid_x.*valid_y, valid_y.*valid_y, valid_x, valid_y, ones(size(valid_x))];
%             E = D*ce;
%             in_index = E <= 0;
%             
%             if plot_ellipse == true
%                 in_x = valid_x(in_index);
%                 in_y = valid_y(in_index);
%                 plot(in_x, in_y, 'r.')
%             end % if
%         end % if
%         
%         % save the valid time indexes
%         % ===========================
%         valid_time_YNmn = tmYN(:)';
%         % ** use all time
%         if ~strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Not use')
%             valid_time_YNmn(valid_seq(~in_index)) = 0;
%         end % if
%         
%         valid_time_YNm = cat(1, valid_time_YNm, valid_time_YNmn);
%         
%     end % for
%     
%     valid_time_YN = cat(3, valid_time_YN, valid_time_YNm);
%     
% end % for

valid_time_YN = obtainValidEyeYN(mSaccConSig, numCycle, numCondition, S, FixSpot);

% +++++++++++++++++++++++++++++++++++++
% cell response to Blank (0%) contrast
% +++++++++++++++++++++++++++++++++++++
blank_spike_account = zeros(numCycle, numCondition);

for k = 1:numCondition  % number of conditions
    % Blank is always Stage 1
    stage_blank = mSaccConSig(k, 1);
    for m = 1:numCycle  % number of cycles
        start_time = stage_blank.eye_position.time_index(1, m);
        sig_len = size(stage_blank.eye_position.time_index(:, 1), 1);
        begin = start_time + tran_time;   % get rid of the transient part
        
        % valid eye time of stage1
        valid_eye = squeeze(valid_time_YN(m, 1:(1+sig_len-1), k));
        valid_eye(1:tran_time) = [];  % get rid of the transient part
        
        % spike time
        spike_time = stage_blank.spikes{m};
        
        % account valid spikes
        if spike_time(1,1) ~= false
            spike_YN = zeros(1, sig_len - tran_time);
            spike_idx = spike_time - begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spike_YN(spike_idx) = 1;
            blank_spike_account(m, k) = sum(valid_eye & spike_YN);
        end % if
        
    end % for
    
end % for

% +++++++++++++++++++++++++++++++++++++
% cell response to contrast in exp
% +++++++++++++++++++++++++++++++++++++
cont_spkc_stage2 = zeros(numCycle, 11, 11); % 11 responses if the specified contrast presented in stage 2
cont_spkc_stage3 = zeros(numCycle, 11, 11); % in stage 3, numCycle x 11 reponses x 11 contrast levels

for k = 1:11    % 11 contrast levels
    contrast = (k - 1) * 10;
    % p = 0;
    for m = 1:11    % 2nd contrast
        % desired contrast in stage 2
        % ---------------------------
        cont1 = contrast;
        cont2 = (m - 1) * 10;
        numcond = Cont2Condnum(cont1, cont2);   % condition number is not the sequence of trials presented in the exp

        stage2 = mSaccConSig(numcond, 2);
        valid_time_YNm = valid_time_YN(:, :, numcond);
        cont_spkc_stage2(:, m, k) = getSpikeCount(stage2, valid_time_YNm, 2, tran_time);
        
        % desigred contrast in stage 3
        % ----------------------------
        %         if m ~= k
        %             p = p+1;
        %             cont1 = (m-1) * 10;
        %             cont2 = contrast;
        %             numcond = Cont2Condnum(cont1, cont2);
        %             stage3 = mSaccConSig(numcond, 3);
        %             valid_time_YNm = valid_time_YN(:, :, numcond);
        %             cont_spkc_stage3(:, p, k) = getSpikeCount(stage3, valid_time_YNm, 3);
        %
        %         end % if
        %
        cont1 = (m-1) * 10;
        cont2 = contrast;
        numcond = Cont2Condnum(cont1, cont2);   % condition number is not the sequence of trials presented in the exp

        stage3 = mSaccConSig(numcond, 3);
        valid_time_YNm = valid_time_YN(:, :, numcond);
        [cont_spkc_stage3(:, m, k), timeint] = getSpikeCount(stage3, valid_time_YNm, 3, tran_time);
        
    end % for
    
end % for

% contrast response
% -----------------
% spike counts and rates
cont_spkc = cat(2, cont_spkc_stage2, cont_spkc_stage3); % numCycles x 22 x 11
cdata = squeeze(mean(cont_spkc,1));         % average spike counts of contrast data, 22 x 11
cont_spkr = cont_spkc/timeint*1000;         % spike rates
rdata = squeeze(mean(cont_spkr,1));

nrm_method = S.Stage_2_Options.CellContrastResponse_options.normalization;
switch nrm_method
    case 'No'
        
    case 'Max %'
        m = cdata';
        max_m = ones(size(cdata',1),1)*max(m);
        cdata = (m./max_m)';
        r = rdata;
        max_r = ones(size(rdata',1),1)*max(r);
        rdata = (r./max_r)';
end % switch

% counts
avgCont = mean(cdata);
stdCont = std(cdata);
semCont = stdCont/sqrt(size(cdata, 1));
% rates
avgContR = mean(rdata);
stdContR = std(rdata);
semContR = stdCont/sqrt(size(rdata, 1));


contaxis = 0:10:100;
ContResp = [contaxis', avgCont', stdCont', semCont'];    % contrast response function
ContRespR = [contaxis', avgContR', stdContR', semContR'];    % rate, contrast response function

% plot
if S.Stage_2_Options.CellContrastResponse_options.plot_contrast_response
    figure
    plot(ContResp(:,1), ContResp(:,2), '-o')
    figure
    plot(ContRespR(:,1), ContRespR(:,2), '-^')
end % if

% ++++++++++++++++++++++++++++++++++
% Dynamic cell reponse to contrasts
% ++++++++++++++++++++++++++++++++++

% ------------------------------------
% A. ensemble of the spike YN
% ------------------------------------
% siglen = size(mSaccConSig(1,1).eye_position.signal, 1); % signal length
Cond_SpikeYN = zeros(numCondition, numCycle, sig_len, 3);      % spike YN = condition num x cycle num x signal length x three stages (blank, contrast 1, contrast 2)

for k = 1:numCondition  % number of conditions
    % Stage 1 - Blank
    stage_blank = mSaccConSig(k, 1);
    % Stage 2 - Contrast 1
    stage_cont1 = mSaccConSig(k, 2);
    % stage 3 - contrast 2
    stage_cont2 = mSaccConSig(k, 3);
    
    for m = 1:numCycle  % number of cycles
        % (1) spike YN of stage 1 - Blank
        % --------------------------------
        begin = stage_blank.eye_position.time_index(1, m);
        % sig_len = size(stage_blank.eye_position.time_index(:, 1), 1);
        % begin = start_time + tran_time;   % get rid of the transient part
        
        % valid eye time of stage1
        % valid_eye = squeeze(valid_time_YN(m, 1:(1+sig_len-1), k));
        % valid_eye(1:tran_time) = [];  % get rid of the transient part
        
        % spike time
        spike_time = stage_blank.spikes{m};
        
        % account valid spikes
        if spike_time(1,1) ~= false
            spike_YN = zeros(1, sig_len);
            spike_idx = spike_time - begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spike_YN(spike_idx) = 1;
            Cond_SpikeYN(k, m, :, 1) = spike_YN;
        end % if
        
        % (2) spike YN of stage 2 - Contrast1
        % -----------------------------------
        begin = stage_cont1.eye_position.time_index(1,m);
        spike_time = stage_cont1.spikes{m};
        % account valid spikes
        if spike_time(1,1) ~= false
            spike_YN = zeros(1, sig_len);
            spike_idx = spike_time - begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spike_YN(spike_idx) = 1;
            Cond_SpikeYN(k, m, :, 2) = spike_YN;
        end % if
        
        % (3) spike YN of stage 3 - Contrast1
        % -----------------------------------
        begin = stage_cont2.eye_position.time_index(1,m);
        spike_time = stage_cont2.spikes{m};
        % account valid spikes
        if spike_time(1,1) ~= false
            spike_YN = zeros(1, sig_len);
            spike_idx = spike_time - begin + 1;
            spike_idx(spike_idx <= 0) = [];
            spike_YN(spike_idx) = 1;
            Cond_SpikeYN(k, m, :, 3) = spike_YN;
        end % if
    end % for
end % for

% check linearity of the reaponse
% -------------------------------
x = ContRespR(:,1);
y = ContRespR(:,2);
[fobj, gof] = fit(x, y, 'poly1');

k = fobj.p1;    % slop 
rsquare = gof.rsquare;

fprintf(sprintf('slop = %g, R^2 = %g\n', k, rsquare))


% ++++++++++++++++++++++++
% commit results
% ++++++++++++++++++++++++
result_dat.cont_spkc = cont_spkc;   % raw data of spike counts of contrast response (see corrui Description)
result_dat.ContResp  = ContResp;    % average of spike counts at different contrast levels
result_dat.cont_spkr = cont_spkr;   % rates
result_dat.ContRespR = ContRespR;   % average of spike rates at different contrast levels


end % function CellContrastResponse


% ====================================
% subroutines
% ====================================
function tmYN = removeBlink(time, blink)
% tmYN  - logical, if 1, good time; 0, do not account

nBlinks = size(blink, 1);   % number of blinks
blk_start = blink(:, 1);
blk_end   = blink(:, 2);
tmYN = ones(size(time));

for k = 1:nBlinks
    
    tmYN_k = time <= blk_start(k) | time >= blk_end (k);
    tmYN = tmYN .* tmYN_k;
    
end % for

tmYN = logical(tmYN);

end % function


function [spikec, timeint] = getSpikeCount(stage, valid_time_YN, stagenum, tran_time)
% Inputs:
%   stage       - a data structure, see mSaccConSig
%   valid_time_YN
%               - logic valid time of eye movements (0 when the eyes
%                 were blinking)
%   stagenum    - 2 for stage 2, and 3 for stage 3
%   tran_time   - transient portion of response (ms)
% 
% Outputs:
%   spikeacc    - number of spikes counted in the time interval (timeint)
%   timeint     - the time interval in which the spikes are counted (ms)

% =========================================================================
% main
% =========================================================================
numCycle = length(stage.spikes);
spikec = zeros(numCycle, 1);

% find time interval
% -------------------
sig_len = size(stage.eye_position.time_index(:, 1), 1); % time length of each stage
timeint = sig_len - tran_time;
for m = 1:numCycle  % number of cycles
    start_time = stage.eye_position.time_index(1, m);
    %ignore the transient part
    begin = start_time + tran_time;     % begin time of signal analysis
    
    % valid eye time at different stages
    valid_eye = valid_time_YN(m, (stagenum-1)*sig_len+1:(stagenum*sig_len));
    valid_eye(1:tran_time) = [];        % remove the transient part
    
    % spike time
    spike_time = stage.spikes{m};
    
    % count valid spikes
    if spike_time(1,1) ~= false
        % spike_YN = zeros(1, sig_len - tran_time);
        spike_YN = zeros(1, timeint);
        spike_idx = spike_time - begin + 1;
        spike_idx(spike_idx <= 0) = [];
        spike_YN(spike_idx) = 1;
        spikec(m) = sum(valid_eye & spike_YN);
    end % if
    
end % for

end % fucntion

function valid_eyetime_YN = obtainValidEyeYN(mSaccConSig, numCycle, numCondition, S, fixspot)
% Obtain valide eye position YN
% 
% Input(s):
%   mSaccConSig     - data structure that stores the signals of the eye
%                     movements and spike times in each experimental
%                     condition.
%   numCycle        - repeat time of each condition (number of trials)
%   numCondition    - number of conditions
%   S               - options of the analysis
%   fixspot         - estimated eye positions that 'center' the stimulus
%                     within the RF (see FixSpot)
% 
% Output(s)
%   valid_eyetime_YN
%                   - Yes/No logic array indicates the time instants of
%                     valid eye signals

% numCondition = size(mSaccConSig, 1);
% numCycle = size(mSaccConSig(1).blink, 1);
valid_eyetime_YN = [];

for m = 1:numCondition
    blink = [];
    valid_time_YNm = [];
    
    for n = 1:numCycle
        % stage 1 - blank
        pos1_x = mSaccConSig(m, 1).eye_position.signal(:, n, 1);    % hor
        pos1_y = mSaccConSig(m, 1).eye_position.signal(:, n, 2);    % hor
        time1  = mSaccConSig(m, 1).eye_position.time_index(:, n);
        % stage 2 - contrast 1
        pos2_x = mSaccConSig(m, 2).eye_position.signal(:, n, 1);    % hor
        pos2_y = mSaccConSig(m, 2).eye_position.signal(:, n, 2);    % hor
        time2  = mSaccConSig(m, 2).eye_position.time_index(:, n);
        % stage 3 - contrast 2
        pos3_x = mSaccConSig(m, 3).eye_position.signal(:, n, 1);    % hor
        pos3_y = mSaccConSig(m, 3).eye_position.signal(:, n, 2);    % hor
        time3  = mSaccConSig(m, 3).eye_position.time_index(:, n);
        % assemble eye positions
        pos_x = [pos1_x; pos2_x; pos3_x];
        pos_y = [pos1_y; pos2_y; pos3_y];
        time  = [time1; time2; time3];
        
        % remove blinks
        % =============
        blink1 = mSaccConSig(m, 1).blink{n};
        blink2 = mSaccConSig(m, 2).blink{n};
        blink3 = mSaccConSig(m, 3).blink{n};
        if blink1(1,1) ~= false
            blink = cat(1, blink, blink1);
        end % if
        if blink2(1,1) ~= false
            blink = cat(1, blink, blink2);
        end % if
        if blink3(1,1) ~= false
            blink = cat(1, blink, blink3);
        end % if
        % some blinks may go cross over two stages, so need to find the
        % unique blinks
        if ~isempty(blink)
            [~, idx] = unique(blink(:,1), 'first');
            blink = blink(idx, :);
            if ~isempty(blink)
                tmYN = removeBlink(time, blink);
            else
                tmYN = ones(size(time));
            end % if
        else
            tmYN = ones(size(time));
        end % if
        
        % cal. confidence ellipse
        % =======================
        % get the eye position data
        valid_x = pos_x(tmYN);
        valid_y = pos_y(tmYN);
        valid_seq = find(tmYN);     % sequence of valid time point
        
        % ++ get the center of the ellipse ++
        % Note: Yoda's eye coil doesn't fix well, so this approach is not
        % good. Try it on Hellboy.
        if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'FR based center')
            ellcent = fixspot(n, :);    % ellipse center
        end % if
        
        % Or, use mass center
        if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Mass center')
            ellcent = mean([valid_x, valid_y]);
        end % if
        % ++++++++++++++++++++++++++++++++++++
        
        if strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'FR based center')...
                || strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Mass center')
            % find the ellipse
            [pc, ~, latent] = princomp([valid_x, valid_y]);
            semi_x = sqrt(latent(1));
            semi_y = sqrt(latent(2));
            k1 = pc(2,1)/pc(1,1);   % k of the first pc
            tilt_x = atan(k1);      % angle from the x-axis
            
            % cal points & draw the CE if required
            % ========================
            if S.Stage_2_Options.CellContrastResponse_options.show_confidence_ellipse
                plot_ellipse = true;
            else
                plot_ellipse = false;
            end % if
            
            if plot_ellipse == true
                figure
                plot(valid_x, valid_y, '.')
                hold on
                plot(ellcent(1), ellcent(2), 'r+')
                axis equal
                
                [~, ex, ey] = ellipse(ellcent(1), ellcent(2), semi_x, semi_y,...
                    plot_ellipse, tilt_x, 'k');
            else
                [ex, ey] = ellipse(ellcent(1), ellcent(2), semi_x, semi_y, ...
                    plot_ellipse, tilt_x, 'k');
            end % if
            ce = CEFit([ex, ey]);
            
            % find the area includes valid eye position
            % =========================================
            D = [valid_x.*valid_x, valid_x.*valid_y, valid_y.*valid_y, valid_x, valid_y, ones(size(valid_x))];
            E = D*ce;
            in_index = E <= 0;
            
            if plot_ellipse == true
                in_x = valid_x(in_index);
                in_y = valid_y(in_index);
                plot(in_x, in_y, 'r.')
            end % if
        end % if
        
        % save the valid time indexes
        % ===========================
        valid_time_YNmn = tmYN(:)';
        % ** use all time
        if ~strcmpi(S.Stage_2_Options.CellContrastResponse_options.confidence_ellipse, 'Not use')
            valid_time_YNmn(valid_seq(~in_index)) = 0;
        end % if
        
        valid_time_YNm = cat(1, valid_time_YNm, valid_time_YNmn);
        
    end % for
    
    valid_eyetime_YN = cat(3, valid_eyetime_YN, valid_time_YNm);
    
end % for

end % function

% [EOF]

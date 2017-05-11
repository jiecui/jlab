function result_dat = MSaccStat(current_tag, name, S, dat)
% MSACCSTAT Microsaccades statistics in contrast-microsaccade experiments (archaic)
%
% Syntax:
%    result_dat = MSaccStat(current_tag, name, S, dat)
% 
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: 03/12/2012  3:30:31.568 PM
% $Revision: 0.2 $  $Date: 03/12/2012  3:30:31.568 PM $
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

%     result_dat = opt;
result_dat = [];
    return
end % if

% load data need for analysis
if strcmpi(current_tag,'get_big_vars_to_load')
    dat_var = { 'AllUsacc'};
    result_dat = dat_var;
    return
end % if

% =========================================================================
% main body
% =========================================================================
% mSaccConSig = dat.mSaccConSig;
AllUsacc = dat.AllUsacc;    % cell array = cycles x 3 stages x conidtions
% TrialTime = dat.TrialTime;

% --------------------------------------------
% obtain valid microsaccades
% --------------------------------------------
[numCycle, ~ , numConditions] = size(AllUsacc);
% numCycle = size(mSaccConSig(1).blink, 1);

usacc = [];
for k = 1:numCycle
    usacc_k = [];
    for m = 1:numConditions
        usacc_km = [];
        usacc1_km = AllUsacc{k, 1, m};
        usacc2_km = AllUsacc{k, 2, m};
        usacc3_km = AllUsacc{k, 3, m};
        
        usacc_km = cat(1, usacc_km, usacc1_km, usacc2_km, usacc3_km);
        usacc_k = cat(1, usacc_k, usacc_km);
    end % for
    usacc = cat(1, usacc, usacc_k);
end % for

% get rid of duplicated one
[~, idx] = unique(usacc(:, 1));
Usacc = usacc(idx, :);

% --------------------------------------------
% main sequence
% --------------------------------------------
amp = Usacc(:, 4);  % magnitude
pkv = Usacc(:, 6);  % peak velocity

X = amp;
Y = pkv;
mainseqfit = fit(X, Y, 'poly1');

figure
plot(X, Y, '.')
hold on
plot(mainseqfit)

% % whole_usacc = cell(numCycle, 3, numCondition);
% all_usacc = cell(numCycle, 3, numCondition);    % all usacc includes those that part of the usacc is included in the trial
% for m = 1: numCondition
%     all_usacc1 = {};    % in stage one. Note: there may be one usacc could cross over two stages
%     all_usacc2 = {};    % in stage two.       so there may be repeats of usacc
%     all_usacc3 = {};    % in stage three.
%     for n = 1: numCycle
%         % stage 1 - blank
%         % ----------------
%         % get usacc
%         usacc1  = mSaccConSig(m, 1).usacc{n};
%         time1 = mSaccConSig(m, 1).eye_position.time_index(:, n);
%         % *** remove non-complete usacc ***
%         whole_usacc1_n = getWholeUsacc(usacc1, time1);
%         whole_usacc1 = cat(1, whole_usacc1, whole_usacc1_n);
%         
%         % stage 2 - contrast 1
%         usacc2  = mSaccConSig(m, 2).usacc{n};
%         time2 = mSaccConSig(m, 2).eye_position.time_index(:, n);
%         whole_usacc2_n = getWholeUsacc(usacc2, time2);
%         whole_usacc2 = cat(1, whole_usacc2, whole_usacc2_n);
%         
%         % stage 3 - contrast 3
%         usacc3  = mSaccConSig(m, 3).usacc{n};
%         time3 = mSaccConSig(m, 3).eye_position.time_index(:, n);
%         whole_usacc3_n = getWholeUsacc(usacc3, time3);
%         whole_usacc3 = cat(1, whole_usacc3, whole_usacc3_n);
%         
%     end % for
%     
%     whole_usacc(m, 1, :) = whole_usacc1; 
%     whole_usacc(m, 2, :) = whole_usacc2; 
%     whole_usacc(m, 3, :) = whole_usacc3; 
% end % for
% 
% % +++++++++++++++++++++++++++++++++++++
% % usaccs in Blank (0%) contrast
% % +++++++++++++++++++++++++++++++++++++
% blank_usacc = [];
% 
% for m = 1:numCondition
%     % blank is always at stage 1
%     whole_usacc_m = squeeze(whole_usacc(m, 1, :));
%     blank_usacc_m = [];
%     for k = 1:numCycle
%         u_k = whole_usacc_m{k};
%         if u_k == 0
%             continue
%         end % if
%         blank_usacc_m = cat(1, blank_usacc_m, u_k);
%     end % for
%     
%     blank_usacc = cat(1, blank_usacc, blank_usacc_m);
%     
% end % for
% 
% % +++++++++++++++++++++++++++++++++++++
% % usaccs in contrasts in exp
% % +++++++++++++++++++++++++++++++++++++
% numLevels = 11;
% cont_usacc_stage2 = cell(numLevels);
% cont_usacc_stage3 = cell(numLevels);
% % usacc_num_stage2 = zeros(11, 11);   % usacc numbers
% % usacc_num_stage3 = zeros(11, 11);   % put zero, if cont1 == cont2
% 
% for k = 1:11    % 11 contrast level
%     contrast = (k - 1) * 10;
%     p = 0;
%     % usacc_stage2 = [];
%     % usacc_stage3 = [];
%     for m = 1:11    % 2nd contrast
%         % desired contrast in stage 2
%         cont1 = contrast;
%         cont2 = (m - 1) * 10;
%         
%         numcond = Cont2Condnum(cont1, cont2);
%         stage2 = squeeze(whole_usacc(numcond, 2, :));
%         usacc_stage2_m = [];
%         for n = 1:numCycle
%             u_n = stage2{n};
%             if u_n == 0
%                 continue
%             end % if
%             usacc_stage2_m = cat(1, usacc_stage2_m, u_n);
%         end % for
%         % usacc_num_stage2(k, m) = size(usacc_stage2_m, 1);
%         % usacc_stage2 = cat(1, usacc_stage2, usacc_stage2_m);
%         cont_usacc_stage2{k,m} = usacc_stage2_m;
%         
%         % desigred contrast in stage 3
%         if m ~= k
%             p = p+1;
%             cont1 = (m-1) * 10;
%             cont2 = contrast;
%             numcond = Cont2Condnum(cont1, cont2);
%             stage3 = squeeze(whole_usacc(numcond, 3, :));
%             usacc_stage3_m = [];
%             for n = 1:numCycle
%                 u_n = stage3{n};
%                 if u_n == 0
%                     continue
%                 end % if
%                 usacc_stage3_m = cat(1, usacc_stage3_m, u_n);
%             end % for
%             cont_usacc_stage3{k,m} = usacc_stage3_m;
%         else
%             cont_usacc_stage3{k,m} = 0;
%         end % if
%         %         if m == k
%         %             % usacc_num_stage3(m, k) = 0;
%         %             cont_usacc_stage3{k,m} = 0;
%         %         else
%         %             % usacc_num_stage3(m, k) = size(usacc_stage3_m, 1);
%         %             cont_usacc_stage3{k,m} = usacc_stage3_m;
%         %         end % if
%     end % for
%     
%     % cont_usacc_stage2 = cat(1, cont_usacc_stage2, usacc_stage2);
%     % cont_usacc_stage3 = cat(1, cont_usacc_stage3, usacc_stage3);
%     
% end % for
% 
% % ++++++++++++++++++++++++++++++++
% % stats
% % ++++++++++++++++++++++++++++++++
% % sort usacc as a function of contrast levels
% % -------------------------------------------
% cont_usacc = cell(1, numLevels);
% for k = 1:numLevels
%     stage2 = cont_usacc_stage2(k, :);
%     stage3 = cont_usacc_stage3(:, k);
%     u2 = [];
%     u3 = [];
%     for m = 1:numLevels
%         st2_m = stage2{m};
%         st3_m = stage3{m};
%         if ~isscalar(st2_m)
%             u2 = cat(1, u2, st2_m);
%         end % if
%         if ~isscalar(st3_m)
%             u3 = cat(1, u3, st3_m);
%         end % if
%     end % for
%     cont_usacc{k} = [u2;u3];
% end % for
% 
% % number of usacc
% % ----------------
% usacc_num = zeros(1, numLevels);     % number of usacc
% for k = 1:numLevels
%     usacc_k = cont_usacc{k};
%     usacc_num(k) = size(usacc_k, 1);
% end % for
% 
% % average amplitude of usacc
% % ---------------------------
% usacc_amp = zeros(1, numLevels);     % usacc amplitude
% for k = 1:numLevels
%     usacc_k = cont_usacc{k};
%     usacc_amp(k) = mean(usacc_k(:, 4));
% end % for
% 
% % average duration of usacc
% % --------------------------

% ++++++++++++++++++++++++++++++++
% commit
% ++++++++++++++++++++++++++++++++
result_dat.usacc_stat.MainSequence.X = amp;
result_dat.usacc_stat.MainSequence.Y = pkv;

end % function MSaccStat

% % =========================================================================
% % subroutines
% % =========================================================================
% function whole_usacc = getWholeUsacc(usacc, time)
% 
% if usacc == 0
%     whole_usacc = 0;
% else
%     t_b = time(1);      % time begin index
%     t_e = time(end);    % time end index
%     u_b = usacc(:, 1);  % usacc starts
%     u_e = usacc(:, 2);  % usacc ends
%     idx = u_b >= t_b & u_e <= t_e;     % usacc must be completed
%     whole_usacc = usacc(idx, :);
%     if isempty(whole_usacc)
%         whole_usacc = 0;
%     end % if
% end % if
% 
% end % funciton

% [EOF]

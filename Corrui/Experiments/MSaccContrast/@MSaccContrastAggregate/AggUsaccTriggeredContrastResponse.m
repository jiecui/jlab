function [mn, se] = AggUsaccTriggeredContrastResponse( curr_exp, sessionlist, S)
% AGGUSACCTRIGGEREDCONTRASTRESPONSE Assembles the results of UsaccTriggeredContrastResponse
%
% Syntax:
%   [mn se] = AggUsaccTriggeredContrastResponse( curr_exp, sessionlist, S)
%
% Input(s):
%
% Output(s):
%   mn      - store
%   se      - not store
%
% Example:
%
% See also .

% Copyright 2013 Richard J. Cui. Created: Wed 06/20/2012  8:49:22.313 AM
% $Revision: 0.4 $  $Date: Sun 03/03/2013 11:06:20.866 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% options
if ( nargin == 1 )
    switch( curr_exp)
        case 'get_options'
            % variables_avg = EyeMovementAggregate.get_variable_list( curr_exp, 'Average' );
            %
            % options = [];
            % for i=1:length( variables_avg )
            %     options.(variables_avg{i}) = { {'{0}', '1'} };
            % end
            % mn = options;
            
            mn.select = { {'{0}', '1'} };   % select this or not
            
            opt.spikerate = { {'0', '{1}'}, 'Aggregate spike rate' };
            opt.spktime_msnum = { {'0', '{1}'}, 'Aggregate spike times and MS numbers' };
            opt.wincent_paras = { {'0', '{1}'}, 'Aggregate spike rate win center and other paras' };
            opt.surspkrate = { {'{0}', '1'}, 'Aggregate surrogate spike rate' };
            mn.options = opt;
            
            return
    end
end

% =======
% main
% =======
se = [];

% get the options
do_spikerate = S.(mfilename).options.spikerate;
do_spktime_msnum = S.(mfilename).options.spktime_msnum;
do_wincent_paras = S.(mfilename).options.wincent_paras;
do_surspkrate = S.(mfilename).options.surspkrate;

% read the variable
numSess = length(sessionlist);  % number of sessions

% aggreate
% =========================================================================
% SpikeRate
% =========================================================================
if do_spikerate
    vars = {'UsaccTriggeredContrastResponse'};
    
    SpikeRate = [];
    SpikeRateOff = [];
    SpikeRate_Norm = [];
    SpikeRateOff_Norm = [];
    for k = 1:numSess
        data = CorruiDB.Getsessvars(sessionlist{k}, vars);
        spk_k = data.UsaccTriggeredContrastResponse.SpikeRate;
        spk_off_k = data.UsaccTriggeredContrastResponse.SpikeRate_off;
        spk_norm_k = data.UsaccTriggeredContrastResponse.SpikeRate_Norm;
        spk_off_norm_k = data.UsaccTriggeredContrastResponse.SpikeRate_Norm_off;
        
        SpikeRate           = cat(3, SpikeRate, spk_k);
        SpikeRateOff        = cat(3, SpikeRateOff, spk_off_k);
        SpikeRate_Norm      = cat(3, SpikeRate_Norm, spk_norm_k);
        SpikeRateOff_Norm   = cat(3, SpikeRateOff_Norm, spk_off_norm_k);
    end % for
    
    mn.UsaccTriggeredSpikeRate                  = SpikeRate;
    mn.UsaccTriggeredSpikeRateOff               = SpikeRateOff;
    mn.UsaccTriggeredSpikeRate_Norm             = SpikeRate_Norm;
    mn.UsaccTriggeredSpikeRateOff_Norm          = SpikeRateOff_Norm;
    
end

% =========================================================================
% SpikeRate using surrogate
% =========================================================================
if do_surspkrate
    vars = {'SurrogateMSTriggeredResponse'};
    
    SurSpikeRate = [];
    SurSpikeRateOff = [];
    SurSpikeRate_Norm = [];
    SurSpikeRateOff_Norm = [];
    for k = 1:numSess
        data = CorruiDB.Getsessvars(sessionlist{k}, vars);
        spk_k = data.SurrogateMSTriggeredResponse.SpikeRate;
        spk_off_k = data.SurrogateMSTriggeredResponse.SpikeRate_offset;
        spk_norm_k = data.SurrogateMSTriggeredResponse.SpikeRate_Norm;
        spk_off_norm_k = data.SurrogateMSTriggeredResponse.SpikeRate_offset_Norm;
        
        SurSpikeRate           = cat(3, SurSpikeRate, spk_k);
        SurSpikeRateOff        = cat(3, SurSpikeRateOff, spk_off_k);
        SurSpikeRate_Norm      = cat(3, SurSpikeRate_Norm, spk_norm_k);
        SurSpikeRateOff_Norm   = cat(3, SurSpikeRateOff_Norm, spk_off_norm_k);
    end % for
    
    mn.SurrogateUsaccTriggeredSpikeRate         = SurSpikeRate;
    mn.SurrogateUsaccTriggeredSpikeRateOff      = SurSpikeRateOff;
    mn.SurrogateUsaccTriggeredSpikeRate_Norm    = SurSpikeRate_Norm;
    mn.SurrogateUsaccTriggeredSpikeRateOff_Norm = SurSpikeRateOff_Norm;
    
end

% =========================================================================
% SpikeTimes, MSNumbers
% =========================================================================
if do_spktime_msnum
    vars = {'UsaccTriggeredContrastResponse'};
    data = CorruiDB.Getsessvars(sessionlist{1}, vars);
    
    trl_len = data.UsaccTriggeredContrastResponse.Paras.TrialLength;
    
    spktimes = data.UsaccTriggeredContrastResponse.SpikeTimes;
    spktimes_off = data.UsaccTriggeredContrastResponse.SpikeTimes_off;
    
    usa_num  = data.UsaccTriggeredContrastResponse.MSNumbers;
    usa_num_off = data.UsaccTriggeredContrastResponse.MSNumbers_off;
    for k = 2:numSess
        data = CorruiDB.Getsessvars(sessionlist{k}, vars);
        
        spktimes_k = data.UsaccTriggeredContrastResponse.SpikeTimes;
        spktimes = concatSpkTimes(spktimes, usa_num, spktimes_k, trl_len);
        spktimes_off_k = data.UsaccTriggeredContrastResponse.SpikeTimes_off;
        spktimes_off = concatSpkTimes(spktimes_off, usa_num_off, spktimes_off_k, trl_len);
        
        usa_num_k = data.UsaccTriggeredContrastResponse.MSNumbers;
        usa_num = usa_num + usa_num_k;
        usa_num_off_k = data.UsaccTriggeredContrastResponse.MSNumbers_off;
        usa_num_off = usa_num_off + usa_num_off_k;
    end % for
    mn.SpikeTimes = spktimes;
    mn.SpikeTimesOff = spktimes_off;
    mn.UsaccNumbersOff = usa_num_off;
    mn.UsaccNumbers = usa_num;
    
end

% =========================================================================
% (3) SpikeRateWinCenter and other parameters
% =========================================================================
if do_wincent_paras
    vars = {'UsaccTriggeredContrastResponse'};
    
    data = CorruiDB.Getsessvars(sessionlist{1}, vars);
    
    spk_c = data.UsaccTriggeredContrastResponse.SpikeRateWinCenter;
    grattime = data.UsaccTriggeredContrastResponse.Paras.GratTime;
    post_onset = data.UsaccTriggeredContrastResponse.Paras.PostOnsetIntv;
    pre_ms = data.UsaccTriggeredContrastResponse.Paras.PreMSIntv;
    post_ms = data.UsaccTriggeredContrastResponse.Paras.PostMSIntv;
    trl_len = data.UsaccTriggeredContrastResponse.Paras.TrialLength;
    
    % =======================================================
    % commit results
    % =======================================================
    
    mn.SpikeRateWinCenter = spk_c;
    mn.GratTime = grattime;
    mn.PostOnsetIntv = post_onset;
    mn.PreMSIntv = pre_ms;
    mn.PostMSIntv = post_ms;
    mn.TrialLength = trl_len;
    
end

end % function MSaccStat

function spkt_out = concatSpkTimes(spktimes, usa_num, spkt_in, trl_len)

N = length(spkt_in);
spkt_out = cell(1, N);
for k = 1:N
    
    spkt_in_k = spkt_in{k};
    spkt_k = spkt_in_k + usa_num(k) * trl_len;
    spkt_out{k} = cat(1, spktimes{k}, spkt_k);
    
end % for

end % for

% [EOF]

function options = Grating_response(current_tag, snames, S)
% GRATING_RESPONSE This function plots the tuning curves before and after and experiment for checking.
%
% Syntax:
%
% Input(s):
%   current_tag         - current tag
%   snames              - session names, in cells
%   S                   - options
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2012 Richard J. Cui. Created: Fri 05/25/2012  8:56:20.883 AM
% $Revision: 0.1 $  $Date: Fri 05/25/2012  8:56:20.883 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% ========================
% options
% ========================
if ( nargin == 1 )
    if ( strcmp( current_tag, 'get_options' ) )
        
        % options.Something   = { {'0','{1}'} };
        % options.normalization = {'{No}|Max %'};
        options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'GratResponse'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);

grat_resp = dat.GratResponse;
mean_rate = grat_resp(:,:,1);
sem_rate  = grat_resp(:,:,3);

spa_frq = 16./[50 32 16 8 4];    % spatial freq (cycles/deg)
speed = [0 20 40 60 80]./16;    % drfiting speed (deg/s)

% ========================
% plot
% ========================
figure('name','Grating Response')

h5 = errorbar(spa_frq, mean_rate(5,:),sem_rate(5,:),'v-');
set(h5, 'color', [0.5 0.5 0.5], 'LineWidth', 1.5)
hold on

h4 = errorbar(spa_frq, mean_rate(4,:),sem_rate(4,:),'s-');
set(h4, 'color', [0.5 0.5 0.5], 'LineWidth', 1.5)

h3 = errorbar(spa_frq, mean_rate(3,:),sem_rate(3,:),'x-');
set(h3, 'color', [0.5 0.5 0.5], 'LineWidth', 1.5)

h2 = errorbar(spa_frq, mean_rate(2,:),sem_rate(2,:),'+-');
set(h2, 'color', [0.5 0.5 0.5], 'LineWidth', 1.5)

h1 = errorbar(spa_frq, mean_rate(1,:),sem_rate(1,:),'o-');
set(h1, 'color', [0 0 0], 'LineWidth', 2.5)

xlabel('Spatial frequency (cycles/deg)')
ylabel('Firing rate (spikes/s)')

legend(sprintf('%-3.2f',speed(5)),sprintf('%-3.2f',speed(4)),sprintf('%-3.2f',speed(3)),...
               sprintf('%-3.2f',speed(2)), sprintf('%-3.2f',speed(1)))
% 
% nrm_method = S.Contrast_response_function_options.normalization;
% switch nrm_method
%     case 'No'
%         ylabel('Response (spikes/s)')
%     case 'Max %'
%         ylabel('Response (%)')
% end % switch

end % function Plot_ABS_Example

% [EOF]

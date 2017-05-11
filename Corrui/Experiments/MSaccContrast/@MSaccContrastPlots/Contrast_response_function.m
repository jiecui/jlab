function options = Contrast_response_function(current_tag, snames, S)
% CONTRAST_RESPONSE_FUNCTION This function plots the contrast response function of the cell.
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

% Copyright 2012 Richard J. Cui. Created: Sun 02/26/2012  1:40:42.817 PM
% $Revision: 0.1 $  $Date: Sun 02/26/2012  1:40:42.817 PM $
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
        options.normalization = {'{No}|Max %'};
        % options = [];
        return
    end
end

% ========================
% get data wanted
% ========================
dat_var = {'ContResp'};
dat = CorruiDB.Getsessvars(snames{1},dat_var);

cr = dat.ContResp;
cont = cr(:, 1);
resp = cr(:, 2);

figure('name','Conrast Response Function')
plot(cont, resp, '-o')
xlabel('Michelson Contrast (%)')

nrm_method = S.Contrast_response_function_options.normalization;
switch nrm_method
    case 'No'
        ylabel('Response (spikes/s)')
    case 'Max %'
        ylabel('Response (%)')
end % switch

end % function Plot_ABS_Example

% [EOF]

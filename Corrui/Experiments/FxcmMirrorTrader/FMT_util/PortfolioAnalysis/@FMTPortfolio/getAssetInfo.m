function asset_info = getAssetInfo( this )
% FMTPORTFOLIO.GETASSETINFO (summary)
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

% Copyright 2015 Richard J. Cui. Created: Thu 01/01/2015 10:09:11.719 AM
% $Revision: 0.2 $  $Date: Tue 02/24/2015  8:24:48.370 AM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

property = this.Property;

num_asset   = numel(property);
pair_name   = cell(num_asset, 1);   % currency pair name
stra_name   = cell(num_asset, 1);   % strategy
asset_name  = cell(num_asset, 1);   % asset name
max_numpos  = zeros(num_asset, 1);  % max number of opening positions
for k = 1:num_asset
    pair_name{k}    = property{k}.CurrencyPair;
    stra_name{k}    = property{k}.StrategyName;
    asset_name{k}   = [pair_name{k}, stra_name{k}];
    max_numpos(k)   = property{k}.MaxNumPos;
end % for

% get the table
asset_idx = (1:num_asset)';
asset_info = table(asset_idx, asset_name, pair_name, stra_name, max_numpos);
asset_info.Properties.VariableNames = this.AssetInfoVarNames;

end % function getAssetInfo

% [EOF]

function this = setPortMV(this, date_start, date_end, pname)
% FMTPORTFOLIO.SETPORTMV setup the FMT portfolio - MV (monthly V.)
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

% Copyright 2015 Richard J. Cui. Created: Thu 01/01/2015 11:25:51.643 AM
% $Revision: 0.1 $  $Date: Thu 01/01/2015 11:25:51.652 AM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

this = setMonthlyReturnFts(this, date_start, date_end);

% p = Portfolio('Name', pname, 'AssetList', this.AssetInfo.AssetName); 
this.Name = pname;
this.AssetList = this.AssetInfo.AssetName;

this = estimateAssetMoments(this, this.MonRetFts);   % estimate asset moments

end % function setPortMV

% [EOF]

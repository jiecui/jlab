function getBeforeAfterChunk(this)
% GETBEFOREAFTERCHUNK gets the tune chunks before and after the experiments
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

% Copyright 2012-2014 Richard J. Cui. Created: Tue 05/22/2012  2:19:41.409 PM
% $Revision: 0.2 $  $Date: Tue 04/29/2014  4:10:32.462 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

data = this.Data;
if ~isempty(data)
    this.BeforeExpTuneChunk = data(1);
    this.AfterExpTuneChunk  = data(length(data));
else
    this.BeforeExpTuneChunk = [];
    this.AfterExpTuneChunk  = [];
end % if

end % function getLastConChunk

% [EOF]

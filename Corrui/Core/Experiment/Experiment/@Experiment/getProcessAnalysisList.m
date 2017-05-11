function analysisList = getProcessAnalysisList( this )
% GETPROCESSANALYSISLIST (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/16/2014  9:29:42.426 PM
% $Revision: 0.1 $  $Date: 03/16/2014  9:29:42.427 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

methods = this.getStaticMethodNames( [class(this) 'Analysis'] );
methods = fliplr(methods);
analysisList = methods(~strcmp(methods, 'get_options'));

end % function getProcessAnalysisList

% [EOF]

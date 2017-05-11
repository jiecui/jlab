function aggregateList = getAggregateList( this )
% GETAGGREGATELIST (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/25/2014  9:40:43.519 AM
% $Revision: 0.1 $  $Date: 03/25/2014  9:40:43.519 AM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

aggclass = [class(this) 'Aggregate'];

if  exist( aggclass , 'class') 
    methods = this.getStaticMethodNames( [class(this) 'Aggregate'] );
else
    methods = this.getStaticMethodNames( 'EyeMovementAggregate' );
end

aggregateList = fliplr(methods);

end % function getAggregateList

% [EOF]

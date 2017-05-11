function S = getStaticMethodNames( clsName )
% GETSTATICMETHODNAMES (summary)
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

% Copyright 2014 Richard J. Cui. Created: 03/16/2014  9:33:24.421 PM
% $Revision: 0.1 $  $Date: 03/16/2014  9:33:24.422 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% getStaticMethodNames gets a list of static method names for class clsName

%   Copyright 2008 The MathWorks, Inc.

S = {};

C = meta.class.fromName(clsName);
if ~isempty(C)
    M = C.Methods;
    for i = 1:length(M)
        if M{i}.Static && ~M{i}.Hidden && strcmp(M{i}.Access , 'public')
            % S{end+1} = M{i}.Name;
            S = cat(2, S, M{i}.Name);
        end
    end
end

end % function getStaticMethodNames

% [EOF]

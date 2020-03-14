function strct = mergestructs(varargin)
% MERGESTRUCTS merges N structures, if both have the same structure,
% replace the 1st with the 2nd structure
% 
% strct = mergestructs(s1, s2, ..., s_n)

% Copyright 2012-2016 Richard J. Cui. Created: 10/24/2012  9:09:33.593 AM
% $Revision: 0.2 $  $Date: Thu 06/02/2016 10:07:02.911 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

n = nargin;

if n > 2
    s = mergestructs(varargin{1:end-1});
    strct = mergestructs(s, varargin{end});
else
    s1 = varargin{1};
    s2 = varargin{2};
    strct = s1;
    if ( ~isempty( s2) )
        snames = fieldnames(s2);
        for fname=snames'
            fname_k = char(fname);
            if (isfield(s1, fname_k) && isstruct(s1.(fname_k))&& isstruct(s2.(fname_k)))
                strct.(fname_k) = mergestructs(s1.(fname_k),s2.(fname_k));
            else
                strct.(fname_k) = s2.(fname_k);
            end
        end
    end
end

end % function

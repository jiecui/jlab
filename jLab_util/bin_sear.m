function i=bin_sear(x,v);
%--------------------------------------------------------------------
% bin_sear function         binary search on a vector.
% input  : - sorted vector (ascending).
%	     - value to search.
% output : - index of closest value.
%    By  Eran O. Ofek           September 1994
%--------------------------------------------------------------------
N = length(x);
if nargin~=2,
    error('2 args only');
end
if N~=0,
    i1 = 1;
    i2 = N;
    if v>x(i2),
        %error('v>set');
        % return last index;
        i = i2;
        break;
    elseif v<x(i1),
        %error('v<set');
        %return first index
        i = 0;
        break;
    end
    while x(i1)~=v,
        if i1==i2,
            break;
        elseif (i2 - i1)==1,
            if (x(i2) + x(i1))<2.*v,
                i1 = i2;
            end
            break;
        end
        mdi = round((i1 + i2)./2);
        mdv = x(mdi);
        if v>mdv,
            i1 = mdi;
        elseif v<mdv,
            i2 = mdi;
        else
            i1 = mdi;
            break;
        end
    end
    i = i1;
else
    i=0;
end

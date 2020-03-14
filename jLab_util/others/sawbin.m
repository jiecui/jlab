function sawvec = sawbin(vec)
sawvec	= vec;
idxon	= find( diff([0;vec]) == 1 );
idxoff	= find( diff([vec;0]) == -1 );
for i = 1:length(idxon)
    if idxoff(i) - idxon(i) > 1
        sawvec(idxon(i):idxoff(i)-1 ) = cumsum( vec(idxon(i):idxoff(i)-1) );
    end
end

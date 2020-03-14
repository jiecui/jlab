function deviation = devmn(dat, avg, dim)
if ( avg ~= 0 )
	% find deviation from average, given average and data
	deviation = 100.*((dat-avg)./avg);
else
	deviation = 100.*dat;
end
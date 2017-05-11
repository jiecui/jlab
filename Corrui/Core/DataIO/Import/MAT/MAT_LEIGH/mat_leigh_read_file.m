function [samples, samplerate] = lab_leigh_read_file(filename, path)

load( [path '\' filename]);


samples(:,1) = 1:length(lh);
samples(:,2) = lh;
samples(:,4) = lv;
if ( exist( 'rh', 'var' ) )
	samples(:,3) = rh;
	samples(:,5) = rv;
else
	samples(:,3) = NaN*lh;
	samples(:,5) = NaN*rh;
end

samplerate = 500;
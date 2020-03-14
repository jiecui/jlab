function spikeplot(spikes)
spk= find(spikes);
x = spk(ones(1,3),:);
x = x(:).';
y = repmat([0 1 0],1,3);
line(x,y);
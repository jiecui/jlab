function plot_fixation_nusaccs( gca, S, durs, nusaccs, nusaccsbin, usacc_delay, usaccbin_delay)


durs = durs{1};
nusaccs = nusaccs{1};
nusaccsbin = nusaccsbin{1};
usacc_delay = usacc_delay{1};
usaccbin_delay = usaccbin_delay{1};

durbins = 100:50:1000;

navg = zeros(length(durbins)-1,1);
rateavg = zeros(length(durbins)-1,1);
prob = zeros(length(durbins)-1,1);
prob2 = zeros(length(durbins)-1,1);
avgdelay = zeros(length(durbins)-1,1);
warning('off', 'MATLAB:divideByZero');

for i=1:length(durbins)-1
    binstart = durbins(i);
    binend = durbins(i+1);
    
    dur_in_bin = find( durs > binstart & durs <= binend );
    
    navg(i) = sum(nusaccsbin(dur_in_bin)) / length(dur_in_bin);
    rateavg(i) = sum(nusaccsbin(dur_in_bin)) / sum(durs(dur_in_bin))*1000;
    prob(i) = length(find(nusaccsbin(dur_in_bin)>0)) / length(dur_in_bin); 
    prob2(i) = length(find(nusaccsbin(dur_in_bin)>0));
    prob2(i) = length((dur_in_bin));
    
     avgdelay(i) = Means(usaccbin_delay(dur_in_bin));
end
durbins = durbins/1000;
% plotyy(gca, durbins(1:end-1)+diff(durbins)/2, navg, durbins(1:end-1)+diff(durbins)/2 , rateavg);
% plotyy(gca, durbins(1:end-1)+diff(durbins)/2, navg, durbins(1:end-1)+diff(durbins)/2 , prob);
% plotyy(gca, durbins(1:end-1)+diff(durbins)/2, rateavg, durbins(1:end-1)+diff(durbins)/2 , prob);
% plot(gca, durbins(1:end-1)+diff(durbins)/2, avgdelay);

% plot(gca,durbins(1:end-1)+diff(durbins)/2 , rateavg);
plot(gca,durbins(1:end-1)+diff(durbins)/2 , navg);
function plot_inter_times(gca, S, pretimes, preevents, timebins, title, xlab, ylab, totaltimes, enum )

    %% No more than 1 type of microsaccade
    
    
enum.event.USACC = 1;
enum.event.SACC = 2;
enum.event.BLINK = 3;
enum.event.TRIALSTART = 4;
enum.event.TRIALSTOP = 5;

preevents = preevents{1};
pretimes = pretimes{1};

USACC_events        = find(preevents == enum.event.USACC);
SACC_events         = find(preevents == enum.event.SACC);
BLINK_events        = find(preevents == enum.event.BLINK);
TRIALSTART_events   = find(preevents == enum.event.TRIALSTART);
TRIALSTOP_events    = find(preevents == enum.event.TRIALSTOP);


times = { pretimes(USACC_events), pretimes(SACC_events), pretimes(BLINK_events), pretimes(TRIALSTART_events)};
% times = { pretimes(USACC_events), pretimes(SACC_events)};
% times = { pretimes(BLINK_events), pretimes(TRIALSTART_events), pretimes(USACC_events), pretimes(SACC_events)};

plot_histogram(gca, S, times, timebins, title, xlab, ylab, totaltimes );

legend({'usacc' 'sacc' 'blink' 'trialstart'});
end
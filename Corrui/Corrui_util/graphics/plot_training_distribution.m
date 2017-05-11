function  plot_training_distribution( ax,sname,press_hist, release_hist, press_hist_error, release_hist_error,S)

if  ~exist('ax','var')
    figure;
    set(gcf,'position',CorrGui.get_default_dlg_pos())
end

lastedge = PressReleaseAnalysis.Histogram_Press_Time_Length; %(sec) longest time to look forward in training distribution plot
bin_width = PressReleaseAnalysis.Histogram_Press_Time_Length_Bin_Width ;
samplerate = 1/bin_width; % need to convert to bin rate (ie bins per second)
baseline = 0;
window_backward = -bin_width*1000/2 ;
window_forward = lastedge + bin_width*1000/2 +1;

titl = ['Training ' sname];
xlab = 'Percept duration (sec)';
ylab = 'Number of percepts (N)';
legend = {'Fade','Intensify'};

if ( exist( 'press_hist_error', 'var' ) )
    plot_correlation( ax, {press_hist,release_hist}, {press_hist_error,release_hist_error}, {baseline,baseline}, window_backward, window_forward,samplerate,titl,xlab,ylab,legend, S )
else
    plot_correlation( ax, {press_hist,release_hist},  {baseline,baseline}, window_backward, window_forward,samplerate,titl,xlab,ylab,legend, S )
end


end
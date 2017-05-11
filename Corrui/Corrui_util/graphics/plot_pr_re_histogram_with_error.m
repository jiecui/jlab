function  plot_pr_re_histogram_with_error( ax,sname,press_hist, release_hist, press_hist_error, release_hist_error,titl,xlab,ylab,leg,...
    lastedge,bin_width,S)
% function  plot_pr_re_histogram_with_error( ax,sname,press_hist, release_hist, press_hist_error, release_hist_error,titl,xlab,ylab,leg,...
%     lastedge,bin_width,S)
% This function will plot histograms with errors
% ax:
% sname:
% press_hist: histogram of things for the press
% release_hist: histogram of things for teh release
% press_hist_error:
% release_hist_error:
% titl:
% xlab:
% ylab:
% leg:
% lastedge: end of histogram time in (sec)
% bin_width: width of bins in (sec)
% S:

if  ~exist('ax','var')
    figure;
    set(gcf,'position',CorrGui.get_default_dlg_pos())
end

baseline = 0;
% window_backward = -bin_width*1000/2 ;
window_backward = 1 ;
% window_forward = lastedge*1000 + bin_width*1000/2 +1;
window_forward = lastedge*1000 + 1;
samplerate = 1/bin_width;

if ( exist( 'press_hist_error', 'var' ) )&&~isempty(press_hist_error)
    plot_correlation( ax, {release_hist,press_hist}, {release_hist_error,press_hist_error}, {baseline,baseline}, window_backward, window_forward,samplerate,titl,xlab,ylab,leg, S )
else
    plot_correlation( ax, {release_hist,press_hist},{} , {baseline,baseline}, window_backward, window_forward,samplerate,titl,xlab,ylab,leg, S )
end

end
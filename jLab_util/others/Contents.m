% VNL_UTIL
%
% Files
%   areashade              - Shades areas between a curve and a fixed threshold
%   arrow                  - Adds/edits an arrow object
%   auroc                  - - area under ROC curve
%   autocolor              - function colors = autocolor(num_colors)
%   barstderror            - 
%   barweb                 - Usage: handles = barweb(barvalues, errors, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend)
%   be2yn                  - convers begin and end pair of intervals to a vector of true or
%   bin_sear               - --------------------------------------------------------------------
%   binplot                - 
%   bins                   - Binary search.
%   binscr                 - call bins, adjusting rows and columns
%   binsearch              - binsearch.m
%   blktridiag             - BLKTRIDIAG: computes a sparse (block) tridiagonal matrix with n blocks
%   bluewhitered           - Blue, white, and red color map.
%   boxcar                 - Fast function to apply a boxcar filter
%   bsearch                - 
%   cat_struct_arrays      - 
%   cline2                 - This function plots a 2D line (x,y) encoded with scalar color data (c)
%   collapse_struct_arrays - 
%   combine_struct_arrays  - make big x-y array to pass into histogram
%   confidence_plot_test   - 
%   confplot               - Linear plot with continuous confidence/error boundaries.
%   copy_many_sess         - 
%   correlate_data         - given a single column of the "standard" data matrix, with 1 ms resolution in the rows,
%   daqwaterfall           - daqwaterfall
%   ddeconv                - A dde conversation plugin for PPLOT. (Excel etc.)
%   desGUIDE               - Simplify a GUI m file produced by GUIDE -> Export
%   devmn                  - 
%   dist_to_line           - - calculates distance a group of points is to a line.
%   dualcursor             - dualcursor       Add dual vertical cursors to a plot
%   eloglog                - *****************************************************************************************************
%   eplot                  - *****************************************************************************************************
%   esemilogx              - *****************************************************************************************************
%   esemilogy              - *****************************************************************************************************
%   estmovingwin           - Estimates moving window centers and number of windows needed
%   exmanager              - M-file for exmanager.fig
%   fastsmooth             - fastbsmooth(Y,w,type,ends) smooths vector Y with smooth 
%   find_array_index       - (summary)
%   find_variable_in_files - Search for a variable in a list of *.mat files
%   fixdec                 - Round towards zero with a specified number of decimals.
%   fixdig                 - Round towards zero with a specified number of digits.
%   fscatter3              - [h] = fscatter3(X,Y,Z,C,cmap);
%   function_paired_obs    - seeks numerically the function between the paired
%   get_ALLdata            - function to read the cortex datafile 
%   get_nice_colors        - (summary)
%   gui_active             - gui_active - used to implement an abort function in a GUI
%   herrorbar              - Horizontal Error bar plot.
%   hist2d                 - function mHist = hist2d ([vY, vX], vYEdge, vXEdge)
%   houghline              - - detects lines in a binary image using common computer vision operation known as the Hough Transform.
%   jbfill                 - USAGE: [fillhandle,msg]=jbfill(xpoints,upper,lower,color,edge,add,transparency)
%   lohi2idx               - from matlab tips trix, convert vectors of lo and hi indices to
%   lr                     - linear regression by least squares.
%   make_gabor             - 
%   make_gabor2            - 
%   make_scroller          - makes the passed in axis a scrolling axis with window size dx
%   matbrowse              - -  MAT-File manager. Allows one to:
%   matbrowse_gui          - This is the machine-generated representation of a Handle Graphics object
%   merge_struct_arrays    - function newarray = merge_struct_arrays(arr1,arr2)
%   merge_structs          - Merge two structures.
%   mergestructs           - strct = mergestructs(s1, s2)
%   mmpolar                - Polar Plot with Settable Properties. (MM)
%   mmpolar_old            - MMPOLAR Polar Plot with Settable Properties. (MM)
%   mmrose                 - ROSE   Angle histogram plot.
%   ms_modal               - Mode function for Matlab 6.1 or above
%   multiscroll            - FUNCTION MULTISCROLL(varargin)
%   mypolytool             - POLYTOOL Fits a polynomial to (x,y) data and displays an interactive graph.
%   myrobustfit            - here, stats contains the fit confidence intervals, but I have to make
%   mytight                - function mytight(ax, margin_percent)
%   optionsdlg             - 
%   package                - This function makes a zip file archive from an m-file and its
%   perl1                  - Execute Perl command and return the result.
%   plot2axes              - Graphs one set of data with two sets of axes
%   Plot2dHist             - function Plot2dHist(mHist2d, vEdgeX, vEdgeY, strLabelX, strLabelY, strTitle)
%   plot_colors            - (as many as lines you are planning to plot)
%   plot_dir               - function [h1, h2] = plot_dir (vX, vY)
%   plot_mean_error        - (summary)
%   plota                  - 
%   ploterr                - 
%   pplot                  - A graphical plot layout and design tool. (Shareware)
%   progressbar            - progressbar - shows a progress bar dialog based on the function "waitbar"
%   qp                     - 
%   qsg                    - 
%   quiet_filter           - filter out usaccs that are preceded by usaccs that end less than
%   range_intersection     - Purpose: Range/interval intersection
%   rasterplot             - RASTERPLOT.M Display spike rasters.
%   rasterplot_yn          - rasterplots spike Y/N
%   readstack              - read either a list of 2D images (slices), or a 3D image
%   reshape_dat            - 
%   rho_polar              - function rho_polar(hrudat,expname), plots microsaccades in polar format
%   RigidBody              - Rigid Body Simulation
%   roc                    - - generate a receiver operating characteristic curve
%   rocch                  - - generate a receiver operating characteristic convex hull 
%   rocdemo                - - demonstrate use of ROC tools
%   rose                   - Angle histogram plot.
%   rotateticklabel        - rotates tick labels
%   rounddec               - Round to a specified number of decimals.
%   rplot                  - Just your basic plot from the nature neuroscience paper
%   saveppt                - saves plots to PowerPoint.
%   sawbin                 - 
%   sbprogress             - Creates a progress bar in the "status-bar section" of the figure
%   scrollfigdemo          - Created by Evan Brooks, evan.brooks@wpafb.af.mil
%   scrollplot             - scrollplot	Linear plot with multiple subplot and horizontal scrollbar
%   scrollsubplot          - Cette fonction permet l'ajout d'un curseur dynamique sur les figures
%   se_of_percent          - function se = se_of_percent(val1,err1,val2,err2)
%   sessdb                 - function varargout = sessdb(cmd,varargin)
%   sessdb2                - function varargout = sessdb(cmd,varargin)
%   setylimpercent         - function setylimpercent(ax1,ax2,avg)
%   skekurtest             - Hypotheses test concerning skewness and kurtosis.
%   slicer                 - interactive visualization of 3D images
%   smith                  - A PPLOT plugin to plot impedances on smith-chart
%   spar                   - A general purpose s-parameter plugin for PPLOT
%   spikeplot              - 
%   struct2array           - 
%   stsbar                 - Creates a status-bar at the bottom of a figure
%   theta_polar            - function rho_polar(thta,expname), plots microsaccades in polar format
%   thresh_tool            - Interactively select intensity level for image thresholding.
%   truncdec               - Truncate to a specified number of decimals.
%   truncdig               - Truncate to a specified number of digits.
%   uiedit                 - multi-line edit box
%   uiListFiles            - Files = uiListFiles
%   yn2be                  - converts a logic vector to begin and end points arrays
%   yn2onoff               - Converts yes/no trials to onset trial and offest trials
%   zumax                  - - graphic - create a new figure with a copy of axis hx

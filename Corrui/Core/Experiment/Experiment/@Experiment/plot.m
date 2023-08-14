function figures = plot( this, sessions, opt )
% PLOT (summary)
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also .

% Copyright 2014-2016 Richard J. Cui. Created: 03/24/2014 10:11:56.010 PM
% $Revision: 0.2 $  $Date: Tue 12/06/2016  5:55:30.860 PM $
%
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

figures = [];
plotList = this.getPlotList();

for i = 1:length(plotList)
    if isfield( opt, plotList{i} ) && opt.( plotList{i} )
        try
            if ( ~this.is_Avg )
                this.plotClass.(plotList{i})(  class(this), sessions, opt );
            else
                this.plotClass.(plotList{i})(  [class(this) '_Avg'], sessions, opt );
            end
        catch ex
            fprintf('\n\nCORRUI ERROR PLOTTING :: experiment -> %s, plot -> %s\n\n', class(this), plotList{i} );
            ex.getReport()
        end
    end
end

end % function plot

% [EOF]

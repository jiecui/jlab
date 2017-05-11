function new_session_name = aggregate( this , sessionlist, opt )
% AGGREGATE (summary)
%
% aggregate( curr_exp , sessionlist, new_session_name)
%
% Aggregates several sessions into one aggregated session withe new
% variables that can be the result of: concatenation, average, addition or
% just copy of the variables of the single session. It also accepts
% specific process for each experiment with the functions
% "experiment_aggregate"
%
% Imput:
%   sessions: list of sessions to be aggregated
%   [new_session_name]: name for the new session in the case of batch
%   aggregation
% Output
%
% Revised by Richard J. Cui
% $Revision: 0.4 $  $Date: Tue 03/24/2015  5:01:26.250 PM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

try
    % common variables
    midname = 'ag';
    
    new_session_name = opt.Name_of_New_Aggregated_Session;
    
    % Tag the sessions
    mn.internalTag = [class(this) '_Avg'];
    mn.sessions = sessionlist;
    % mn.associatedSESession = [this.prefix 'se' new_session_name];
    
    se.internalTag = [class(this) '_SE'];
    % se.internalTag = [class(this) '_Avg'];
    
    % save information about associated se session into mn session
    this.db.add( [this.prefix, midname, new_session_name], mn );
    this.db.add(  [this.prefix 'se' new_session_name], se );
    
    aggregateList = this.getAggregateList(  );
        
    for i=1:length(aggregateList)
        if isfield(opt, aggregateList{i})
            if isfield(opt.(aggregateList{i}),'select')
                selected = opt.(aggregateList{i}).select;
            else
                selected = opt.(aggregateList{i});
            end % if
            if selected
                try
                    % call the aggregate method
                    tic;
                    disp( [' -- Running ' aggregateList{i} ' ...'])
                    
                    % ----- aggregate INFO is a must in aggregating -----
                    opt.Concatenate.options.info = true;
                    [ag, se] = this.aggregateClass.Concatenate( this, sessionlist, opt);
                    % save the data
                    this.db.add( [this.prefix, midname, new_session_name], ag );
                    this.db.add( [this.prefix, 'se', new_session_name], se );
                    
                    % ----- then aggregate others -----
                    [ag, se] = this.aggregateClass.(aggregateList{i})( this, sessionlist, opt);
                    % save the data
                    this.db.add( [this.prefix midname new_session_name], ag );
                    this.db.add( [this.prefix 'se' new_session_name], se );
                    
                    t=toc;
                    disp( [' -- Done with ' aggregateList{i} '. Time: ' num2str(t/60) ' minutes']);
                catch ex
                    ex.getReport()
                    fprintf('\n\nCORRUI ERROR PLOTTING :: experiment -> %s, agg -> %s\n\n', class(this), aggregateList{i} );
                end
            end
        end
    end
    
catch ex
    fprintf('\n\nCORRUI ERROR AGGREGATING :: experiment -> %s\n\n', ...
        class(this));
    ex.getReport()
end

new_session_name = [this.prefix, midname, new_session_name];

end % function aggregate

% =========================================================================
% subroutines
% =========================================================================

% [EOF]

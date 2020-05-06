function  newsessions = batch_operation(this, operation, varargin)
% EXPERIMENT.BATCH_OPERATION porcesses batch operations
%
% Syntax:
%   newsessions = batch_operation(this, operation)
%   newsessions = batch_operation(__, tag_choice)
%
% Input(s):
%   this            - [obj] Experiment object
%   operation       - [cell struct] options of processing operations
%   tag_choice      - [char] (opt) {'Current Exp', 'Specified in Batch'}.
%                     'Current Exp'     : 'Tag' is the name the current 
%                                        experiment (default)
%                     'Specified in Batch'
%                                       : 'Tage' is specified in batch
%                                         operation
%
% Output(s):
%   newsessions     - [cell char] cell arrays of names of new sessions
% 
% Example:
%
% See also .

% Copyright 2014-2020 Richard J. Cui. Created: 04/28/2013  1:32:49.953 PM
% $Revision: 0.6 $  $Date: Wed 05/06/2020  9:53:23.151 AM $
%
% Multimodal Neuroimaging Lab (Dr. Dora Hermes)
% Mayo Clinic St. Mary Campus
% Rochester, MN 55905, USA
%
% Email: richard.cui@utoronto.ca (permanent), Cui.Jie@mayo.edu (official)

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(this, operation, varargin{:});
tag_choise = q.tag_choice;

% =========================================================================
% main
% =========================================================================
% process operations one by one
% -----------------------------
n_opr = numel(operation); % number of operations
for i = 1:n_opr
    % --------------------
    % check operation type
    % --------------------
    if isfield(operation{i}.Is, 'Import')
        Import_yn = operation{i}.Is.Import;
    else
        Import_yn = false;
    end
    
    if isfield(operation{i}.Is, 'Process')
        Process_yn = operation{i}.Is.Process;
    else
        Process_yn = false;
    end
    
    if isfield(operation{i}.Is, 'Aggregate')
        Aggregate_yn = operation{i}.Is.Aggregate;
    else
        Aggregate_yn = false;
    end
    
    if isfield(operation{i}.Is, 'Plot')
        Plot_yn = operation{i}.Is.Plot;
    else
        Plot_yn = false;
    end
    
    if isfield(operation{i}.Is, 'Combine')
        Combine_yn = operation{i}.Is.Combine;
    else
        Combine_yn = false;
    end
    
    isImport    = Import_yn & ~Process_yn & ~Aggregate_yn & ~Plot_yn & ~Combine_yn;
    isProcess   = ~Import_yn & Process_yn & ~Aggregate_yn & ~Plot_yn & ~Combine_yn;
    isAggregate = ~Import_yn & ~Process_yn & Aggregate_yn & ~Plot_yn & ~Combine_yn;
    isPlot      = ~Import_yn & ~Process_yn & ~Aggregate_yn & Plot_yn & ~Combine_yn;
    isCombine   = ~Import_yn & ~Process_yn & ~Aggregate_yn & ~Plot_yn & Combine_yn;
    
    % --------------
    % choose tag
    % --------------
    switch tag_choise
        case 'Current Exp'
            current_tag = class(this);
            if ( isfield( operation{i}, 'Tag') )
                current_tag_batch = operation{i}.Tag;
                if ~strcmp(current_tag, current_tag_batch)
                    warning('off', 'backtrace')
                    warning('Tag of current exp and that in batch file are not consistent!')
                    warning('on', 'backtrace')
                end % if
            end % if
        case 'Specified in Batch'
            if ( isfield( operation{i}, 'Tag'))
                current_tag = operation{i}.Tag;
            else
                error('The batch analysis needs to provide a tag');
            end
    end % switch
    
    % ++++++++++++++++++++++++++++
    % importing sessions / block
    % ++++++++++++++++++++++++++++
    if isImport == true
        datafiles = operation{i}.DataFiles;
        S = operation{i}.S;
        newsessions = this.import(datafiles, S);
    end
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++
    % processing individual (or aggregated) sessions /
    % blocks
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++
    if isProcess == true
        S = operation{i};
        sessions = S.Sessions.Old;   
        S.newsessions = S.Sessions.New;
        newsessions = this.process(sessions, S);
    end
    
    % +++++++++++++++++++++++++++++++++
    % combine blocks
    % +++++++++++++++++++++++++++++++++
    if isCombine == true
        datablocks = operation{i}.Sessions.Old;
        newsessions = operation{i}.Sessions.New;
        S = operation{i};
        S.newsessions = newsessions;
        
        newsessions = this.blocks2session(datablocks, S, S.do_waitbar);
    end % if
    
    % +++++++++++++++++++++
    % aggregating sessions
    % +++++++++++++++++++++
    if isAggregate == true
        sessionlist = operation{i}.Sessions.Old;
        S =  operation{i}.Options;
        CorrGui.Aggregate( current_tag , sessionlist, S, S.do_waitbar ); % TODO
        
        newsessions = S.Name_of_New_Aggregated_Session;
    end
    
    % +++++++++++++++++++++
    % ploting sessions
    % +++++++++++++++++++++
    if isPlot == true
        sessionlist = operation{i}.Sessions.Old;
        S =  operation{i}.Options;
        CorrGui.Plot( current_tag , sessionlist, S );
        
        newsessions = [];
    end
end

% close pool if necessary
p = gcp('nocreate');
if  isempty(p) == false
    delete(p)
end

end % function batch_operation

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
default_tc = 'Current Exp';

% parse rules
p = inputParser;
p.addRequired('this', @isobject);
p.addRequired('operation', @iscell);
p.addOptional('tag_choice', default_tc, @ischar);

% parse and return
p.parse(varargin{:});
q = p.Results;

end % funciton

% [EOF]

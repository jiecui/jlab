function  newsessions = batch_operation( this, operation, tag_choise )
% EXPERIMENT.BATCH_OPERATION porcesses batch operations
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

% Copyright 2014 Richard J. Cui. Created: 04/28/2013  1:32:49.953 PM
% $Revision: 0.3 $  $Date: Sun 04/20/2014  4:58:33.525 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

N = length(operation);

for i = 1:N
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
                    warning('Tag of current exp and that in batch file are not consistent!')
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
    if isImport
        datafiles = operation{i}.DataFiles;
        S = operation{i}.S;
        newsessions = this.import( datafiles, S );
    end
    
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++
    % processing individual (or aggregated) sessions /
    % blocks
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++
    if isProcess
        sessions = operation{i}.Sessions.Old;   
        newsessions = operation{i}.Sessions.New;
        S = operation{i};
        S.newsessions = newsessions;
        newsessions = this.process( sessions, S );
    end
    
    % +++++++++++++++++++++++++++++++++
    % combine blocks
    % +++++++++++++++++++++++++++++++++
    if isCombine
        datablocks = operation{i}.Sessions.Old;
        newsessions = operation{i}.Sessions.New;
        S = operation{i};
        S.newsessions = newsessions;
        
        newsessions = this.blocks2session(datablocks, S, S.do_waitbar);
    end % if
    
    % aggregating sessions
    % ----------------------
    if isAggregate
        sessionlist = operation{i}.Sessions.Old;
        S =  operation{i}.Options;
        CorrGui.Aggregate( current_tag , sessionlist, S, S.do_waitbar );
        
        newsessions = S.Name_of_New_Aggregated_Session;
    end
    
    % ploting sessions
    % -----------------
    if isPlot
        sessionlist = operation{i}.Sessions.Old;
        S =  operation{i}.Options;
        CorrGui.Plot( current_tag , sessionlist, S );
        
        newsessions = [];
    end
end

% close pool if necessary
if  matlabpool('size')
    matlabpool('close')
end

end % function batch_operation

% [EOF]

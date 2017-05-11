function loadRF2Mat(this,filename)

% Copyright 2010 Richard J. Cui. Created: 02/22/2010  5:24:36.785 PM
% $Revision: 0.2 $  $Date: 03/05/2010 11:53:24.054 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% =========================================================================
% load from disk
% =========================================================================
[filepath,name] = fileparts(filename);
ext = '.mat';
fullname = [['S',name],ext];
if isempty(filepath)
    wholename = which(fullname);
else
    wholename = [filepath,'\',fullname];
end % if
if isempty(wholename)
    this.Option.loadRF2Mat = false;
    
    % -- echo
    fprintf('\t<!> cannot find the requested file %s ...\n',fullname)
else
    checkedname = which(wholename);
    if isempty(checkedname)
        this.Option.loadRF2Mat = false;
        % -- echo
        fprintf('\t<!> cannot find the requested file %s ...\n',fullname)

    else
        % -- echo
        fprintf('\t--> Loading %s ...\n',wholename)
        load(wholename)
        
        %         % =========================================================================
        %         % restore shown properties
        %         % =========================================================================
        %         % srf2 = rmfield(srf2,'Option');  % do not load Option
        %         fn = fieldnames(srf2);
        %         for k = 1:length(fn)
        %             this.(fn{k}) = srf2.(fn{k});
        %         end % for
        %
        %         % =========================================================================
        %         % restore hidden properties
        %         % =========================================================================
        %         this.FileLength = srf2.FileLength;
        %         this.chunks = srf2.chunks;
        
        % =========================================================================
        % restore selected properties
        % =========================================================================
        stimtype = upper(this.Stimulus.type);
        
        if ~isfield(srf2,stimtype)
            fprintf('\t<!> cannot find the requested stimulus type %s. Will calculate.\n',stimtype)
            this.Option.loadRF2Mat = false;
        elseif norm(srf2.(stimtype).ChunkRange-this.ChunkRange) ~=0
            fprintf('\t<!> chunk ranges are not consistent. Will re-calculate.\n')
            this.Option.loadRF2Mat = false;
        else
            % -- echo
            fprintf('\t\t--> loading EyePos ...\n')
            if isfield(srf2.(stimtype),'EyePos')
                this.EyePos = srf2.(stimtype).EyePos;
            else
                this.EyePos = [];
            end % if
            % -- echo
            fprintf('\t\t--> loading SpikeTime ...\n')
            if isfield(srf2.(stimtype),'SpikeTime')
                this.SpikeTime = srf2.(stimtype).SpikeTime;
            else
                this.SpikeTime = [];
            end % if
            % -- echo
            fprintf('\t\t--> loading EstFix ...\n')
            if isfield(srf2.(stimtype),'EstFix')
                this.EstFix = srf2.(stimtype).EstFix;
            else
                this.EstFix = [];
            end % if
        end % if
    end % if
end % if

end % loadRF2Mat

% [EOF]
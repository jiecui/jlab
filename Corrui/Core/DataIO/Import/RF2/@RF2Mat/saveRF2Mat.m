function saveRF2Mat(this)
% SAVERF2MAT saves the information in RF2Mat onto disk
% 
% Syntax:
%   saveRF2Mat(this)
% 
% Input(s):
% 
% Remarks:
% 
% Example:
% 
% See also .

% Copyright 2010 Richard J. Cui. Created: 02/20/2010 11:21:23.052 PM
% $Revision: 0.3 $  $Date: 03/12/2010  8:33:21.232 AM $
% 
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
% 
% Email: jie@neurocorrleate.com

% % =========================================================================
% % shown properties
% % =========================================================================
% fn = fieldnames(this);
% for k = 1:length(fn)
%     srf2.(fn{k}) = this.(fn{k});
% end % for
% % =========================================================================
% % hidden properties
% % =========================================================================
% srf2.FileLength = this.FileLength;
% srf2.chunks = this.chunks;
% srf2.DiagData = this.DiagData;
% 
% srf2 = rmfield(srf2,'Option');  %#ok<NASGU> % do not save 'Option'

% =========================================================================
% check if file exists
% =========================================================================
filename = this.FileName;
path = this.FilePath;
[~,name] = fileparts(filename);
ext = '.mat';
fullname = ['S',name,ext];
wholename = [path,fullname];

stimtype = upper(this.Stimulus.type);
s = exist(wholename,'file');
if s == 2 % file exist
    load(wholename)
end % if
srf2.(stimtype).ChunkRange = this.ChunkRange;
srf2.(stimtype).EyePos = this.EyePos;
srf2.(stimtype).SpikeTime = this.SpikeTime;
if isfield(this,'EstFix')
    srf2.(stimtype).EstFix  = this.EstFix; %#ok<STRNU>
end %if

% =========================================================================
% save selected properties to disk
% =========================================================================

fprintf('\t--> Saving %s ...\n', wholename)
save(wholename,'srf2')

end % saveRF2Mat

% [EOF]
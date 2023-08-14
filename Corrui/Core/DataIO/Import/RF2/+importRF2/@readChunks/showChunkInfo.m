function showChunkInfo( this )
% SHOWCHUNKINFO shows the chunk information
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% See also yn2be, be2yn, lohi2idx, yn2onoff.

% Copyright 2013-2014 Richard J. Cui. Created: 11/27/2011  1:48:35.834 PM
% $Revision: 0.3 $  $Date: Tue 04/29/2014  4:10:32.462 PM $
%
% Visual Neuroscience Lab (Dr. Martinez-Conde)
% Barrow Neurological Institute
% 350 W Thomas Road
% Phoenix AZ 85013, USA
%
% Email: jie@neurocorrleate.com

% find the starts and ends of continuous blocks
seq = this.ChunkInfo.sequence;

if isempty(seq)
    return
end % if

seq_yn = pointtime2yn(seq, 1, max(seq));
[bp, ep] = yn2be(seq_yn);

% display
seqmsg = [];
N = length( bp );
for k = 1: N
    bp_k = bp( k );
    ep_k = ep( k );
    
    if bp_k == ep_k
        seqmsg_k = num2str( bp_k );
    else
        seqmsg_k = [num2str( bp_k ), '-', num2str( ep_k )];
    end % if
    
    seqmsg = cat( 2, seqmsg, seqmsg_k);

    if k == N
        seqmsg = cat( 2, seqmsg, '.' );
    else
        seqmsg = cat( 2, seqmsg, ', ' );
    end % if

end % for

msg1 = sprintf('The %s chunk numbers:', this.ChunkType);
disp( msg1 );
disp( seqmsg );

end % function showChunkInfo

% [EOF]

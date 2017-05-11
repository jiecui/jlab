function getSessInfo( this )
% GMSTRIAL.GETSESSINFO get session information
%
% Syntax:
%
% Input(s):
%
% Output(s):
%
% Example:
%
% Note:
%
% References:
%
% See also .

% Copyright 2016 Richard J. Cui. Created: Fri 07/08/2016 11:33:18.539 AM
% $Revision: 0.2 $  $Date: Fri 08/12/2016 10:36:58.815 PM $
%
% 3236 E Chandler Blvd Unit 2036
% Phoenix, AZ 85048, USA
%
% Email: richard.jie.cui@gmail.com

vars = { 'SessInfo', 'ChannelInfo' };
dat = this.db.Getsessvars(this.sname, vars);

sess_info   = dat.SessInfo;
chan_info   = dat.ChannelInfo;

this.MonkeyID       = sess_info.MonkeyID;
this.RelLatShort    = sess_info.RelLatShort;
this.RelLatAll      = sess_info.RelLatAll;
this.TrialLength    = sess_info.TrialLength;
this.TargetOnset    = sess_info.TargetOnset;
this.SurroundOnset  = sess_info.SurroundOnset;
this.MaskOnset      = sess_info.MaskOnset;
this.TargetPos      = sess_info.TargetPos;
% this.SubjDispTrialNumber = numel(sess_info.RelLatShort);

this.CorAreaID      = chan_info.CorAreaID;
this.ElectrodNum    = chan_info.ElectrodNum;
this.GridIndex      = chan_info.GridIndex;
this.ChannelNumber  = numel(this.CorAreaID);

end % function getSessInfo

% [EOF]

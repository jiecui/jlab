function [samples,buttons,blinks]=edf_convert(efr)
%% [samples,buttons_on,buttons_off] = edf_read_file(fname)
%%
%% Returns arrays of sample data, buttons and blinks given a
%% com.neuralcorrelate.eyelinkaccess.EdfReader instance

% get the arrays out
smp=efr.getSamples;
but=efr.getButtons;
blk=efr.getBlinks;

% convert from arraylist to matlab arrays
len=smp.size;
samples = zeros(5,len);
for i=0:len-1,samples(:,i+1)=smp.get(i);end

len=but.size;
buttons = zeros(3,len);
for i=0:len-1,buttons(:,i+1)=but.get(i);end

len=blk.size;
blinks = zeros(2,len);
for i=0:len-1,blinks(:,i+1)=blk.get(i);end




%% old stuff trying to use their classes directly....
% op = DefaultOptionAdapter;
% edfinst = javaObject('com.srresearch.edfapi.EDF',op,fname);
% 
% type = 1;
% samples = [];
% buttons = []; 
% blinks = [];
% numsamples = 0;
% while type ~=0
%     type = edfinst.getNextData;
%     switch type
%         case EDF.BUTTONEVENT
%             fe = edfinst.getFloatData;
%             buts = fe.getButtons;
%             timest = fe.getStartTime;
%             clear fe;
%             if ~isempty(buts)
%                 start = size(buttons,1)+1;
%                 buttons(start:start+size(buts,1)-1,1) = timest;
%                 buttons(start:start+size(buts,1)-1,2:3) = buts; 
%             end
%         case EDF.ENDBLINK
%             fe = edfinst.getFloatData;
%             start = size(blinks,1)+1;
%             blinks(start,:) = [fe.getStartTime fe.getEndTime];
%             clear fe
%         case EDF.SAMPLE_TYPE
%             try
%                 fs = edfinst.getFloatData;
%                 timest = fs.getStartTime;
%                 start = size(samples,1)+1;
%                 samples(start,:) = [timest fs.getHx fs.getHy];
%             catch
%             end
%     end
% end
% 
  




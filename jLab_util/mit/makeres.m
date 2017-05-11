function res=makeres(results)
% compile a cached_results struct into efficient array (avg and std not treated yet)

%first find dims
numsubj = length(results);
numslices = length(results{1}{1});
numcond = length(results{1}{1}(1).results);
nummeas = size(results{1}{1}(1).results{1},2);

% datlen = 0;
% nsu = 0;
% nsl = 0;
% ncd = 0;
% for nsu=1:length(results),
%     subj = results{nsu}{1};
%     for nsl=1:length(subj),
%         slice = subj(nsl).results;
%         for ncd=1:length(slice),
%             cond = slice{ncd};
%             datlen=datlen+size(cond,1);
%         end
%     end
% end
% 
% % allocate arrays
% dat = zeros(datlen,nummeas);
% subji = zeros(datlen,1);
% slicei = zeros(datlen,1);
% condi = zeros(datlen,1);

dat = [];
subji = [];
slicei = [];
condi = [];

% fill arrays
dati = 1;
nsu = 0;
nsl = 0;
ncd = 0;
for nsu=1:length(results),
    subj = results{nsu}{1};
    for nsl=1:length(subj),
        slice = subj(nsl).results;
        for ncd=1:length(slice),
            cond = slice{ncd};
            datii=dati+size(cond,1)-1;
            % write data
            dat(dati:datii,:)=cond(:,2:size(cond,2));
            % write indices
            subji(dati:datii,:)= nsu;
            slicei(dati:datii,:)= nsl;
            condi(dati:datii,:)= ncd;
            dati=datii+1;
        end
    end
end

% make struct
res = [];
res.data = dat;
res.subji = subji;
res.slicei = slicei;
res.condi = condi;


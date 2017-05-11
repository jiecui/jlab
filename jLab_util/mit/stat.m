names = {'bcla1','bcla2','bcla3','bcra1','bcra2','bcra3','wdla1','wdla3','wdla4','wdra1','wdra3','wdra4'};

for n=1:12
   load(names{n});
   clear pv ext dext errrot errdst;
   
   for i=1:cnt
      pv(i) = max(HV{i})*30;
      [dummy,best] = min( sqrt(sum( (HP{i}-ones(N(i),1)*TP(i,:))'.^2 )) );
      [ext,start] = max( sqrt(sum( (HP{i}-ones(N(i),1)*HP{i}(best,:))'.^2 )) );
      errext(i) = sqrt(sum((HP{i}(start,:)-TP(i,:)).^2)) - ext;
      errdst(i) = sqrt(sum((HP{i}(best,:)-TP(i,:)).^2));
      errrot(i) = acos(min([1 abs( TX(i,:)*HY{i}(best,:)' )]))/pi*180;
      
%      f(i,:) = abs(fft(HV{i}-mean(HV{i}),64));
   end;
   
   [PV(n),PVC(n)] = robust(pv);
   [PV1(n),PVC1(n)] = robust(1./pv);
   [EXT(n),EXTC(n)] = robust(errext);
   [DST(n),DSTC(n)] = robust(errdst);
   [ROT(n),ROTC(n)] = robust(errrot);
   
%   figure;
%   subplot(3,1,1); plot(pv); title(names{n});
%   subplot(3,1,2); plot(errdst); hold on; plot(dext-ext,'r');
%   subplot(3,1,3); plot(errrot);
end;


% compute distance and orientation errors
%for i=1:cnt
%   DST{i} = sqrt(sum( (ones(N{i},1)*targetpos(i,:)-squeeze(P{i}(1,:,:)))'.^2 ));
%   OR{i} = [...
%      sum(((ones(N{i},1)*targetxv(i,:)) .* squeeze(Y{i}(1,:,:)))')' ...
%      sum(((ones(N{i},1)*targetyv(i,:)) .* squeeze(Y{i}(1,:,:)))')' ];
%end;

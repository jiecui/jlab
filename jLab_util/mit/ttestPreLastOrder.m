function crunch = ttestPreLastOrder(crunch, subjnumbers, newsubjectname, prestring, laststring, filename)
% function to collapse the "Pre" and "last" sessions for a number of patients together

try
   % search for subject
   subj_idx = strmatch(newsubjectname, crunch.subject_names);
   if isempty(subj_idx)
      subj_idx = length(crunch.subject_names)+1;
   end
catch
   warning('Uninitialized crunchStruct! Must at least have subject_names field');
   return;
end

eval(sprintf('subjs = [%s];',subjnumbers));
% check bounds
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
preavg = [];
prestd = [];
lastavg = [];
laststd = [];
order = [];
for s=subjs
   % get data for "Pre", use strmatch
   subj=crunch.subjects(s);
   match = find(strcmp(prestring, subj.slice_labels));
   if ~isempty(match)
      preavg = cat(3,preavg,subj.data.avg(:,:,match(1)));
      prestd = cat(3,prestd,subj.data.std(:,:,match(1)));
   else
      warning(sprintf('Subject %d does not have session named %s! Continuing...', s, prestring));
      continue;
   end
   % length(slice_names)-1 because we know
   lastslice = length(subj.slice_labels);
   lastispre = strcmp(prestring, subj.slice_labels{lastslice});
   if lastispre
      lastslice = lastslice - 1;
   end
   lastavg = cat(3,lastavg,subj.data.avg(:,:,lastslice));
  	laststd = cat(3,laststd,subj.data.std(:,:,lastslice));
    % order extraction
    order = cat(1,order,subj.condition_order);
end

% cut down on the crap
meas = [1:9 16:23];
meas_labels = crunch.measures(meas);
meas_labels(6) = cellstr('Average Velocity');

% how to classify these order numbers as 'early' or late?
uppercutoff = 10;
lowercutoff = 5;
class = {};
shadow = [];
class(find(order>=uppercutoff))=cellstr('late');
shadow(find(order>=uppercutoff))=3;
class(find((order<uppercutoff) & (order>lowercutoff)))=cellstr('middle');
shadow(find((order<uppercutoff) & (order>lowercutoff)))=2;
class(find(order<=lowercutoff))=cellstr('early');
shadow(find(order<=lowercutoff))=1;
class=reshape(class,size(order));
shadow=reshape(shadow,size(order));

% compute!
pvals = [];%zeros(size(preavg(:,:,1)));
for i=1:size(preavg,1)
%     mvals1 = squeeze(preavg(i,:,:));
%     mvals2 = squeeze(lastavg(i,:,:));
%     mimprov = (mvals2-mvals1)./mvals1;
%     try
%         d = manova1(mimprov',order(:,i));
%         disp('worked')
%     catch
%     end
   for j=meas
       % what about NaN's? lyngby doesn't like them, so let's 2-way filter
       keepset = intersect(find(~isnan(preavg(i,j,:))),find(~isnan(lastavg(i,j,:))));
       vals1 = squeeze(preavg(i,j,keepset));
       vals2 = squeeze(lastavg(i,j,keepset));
       % order computation requires a %improvement
       improv = vals2-vals1;
       %improv = (vals2-vals1)./vals1;
       %tvals(i,j) = anova1(improv(keepset),order(keepset,i),'off');
       pvals(i,j) = anova1(improv(keepset),class(keepset,i),'off');
       %pvals(i,j) = kruskalwallis(improv(keepset),class(keepset,i),'off');
       if pvals(i,j) == NaN | pvals(i,j) < 0.1
           disp(kruskalwallis(improv(keepset),class(keepset,i),'off'));
           subplot(2,1,1);
           bar(makebardat(improv(keepset), shadow(keepset,i))');
           subplot(2,1,2);
           bar(improv(keepset));
           titl=sprintf('%s, %s', char(crunch.conditions(i)), char(crunch.measures(j)));
           title(titl);
           saveas(gcf, titl, 'bmp'); 
       end
   end
end

pvals = pvals(:,meas);
if nargin==6
   tblwrite(pvals,char(meas_labels),char(crunch.conditions),filename,',');
else
   tblwrite(pvals,char(meas_labels),char(crunch.conditions),'pvals_prelast.csv',',');
end

      
%preavg = mean(preavg,3)
%prestd = mean(prestd,3);
%lastavg = mean(lastavg,3);
%laststd = mean(laststd,3);
function bardat = makebardat(improvement,classes)

bardat = zeros(max([length(find(classes==1))...
        length(find(classes==2))...
        length(find(classes==3))]),3);

bardat(1:length(improvement(find(classes==1))),1) = improvement(find(classes==1));
bardat(1:length(improvement(find(classes==2))),2) = improvement(find(classes==2));
bardat(1:length(improvement(find(classes==3))),3) = improvement(find(classes==3));


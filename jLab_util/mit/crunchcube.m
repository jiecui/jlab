function cube = crunchcube(crunch, subjects)
% returns a big array of the averages

eval(sprintf('subjs = [%s];',subjects));
subjs = subjs(find((subjs<=length(crunch.subjects) & (subjs>=1))));
cube=[];
% 1st find the total size, and pre-allocate cube of NaN's
max=0;
for s=subjs,
    subj=crunch.subjects(s);
    if size(subj.data.avg,3) > max
        max = size(subj.data.avg,3);
    end
end
cube = zeros(size(subj.data.avg,1), size(subj.data.avg,2), max, length(subjs));
cube(:,:,:)=NaN;
% 1st step is to re-order the Pre column to 1st column
for i=1:length(subjs),
    s=crunch.subjects(subjs(i));
    preslice = length(s.slice_labels);
    s.data.avg = cat(3,s.data.avg(:,:,preslice),s.data.avg(:,:,1:preslice-1));
    cube(:,:,1:preslice,i)=s.data.avg;
end

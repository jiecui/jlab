function idx = lohi2idx(lo,hi)
% from matlab tips trix, convert vectors of lo and hi indices to
% [lo(i):hi(i)]
idx = [];

if isempty(lo) || isempty(hi)
    return
end


% preproc
for i=1:length(hi)
    if lo(i)>hi(i)
        i = lo <= hi;
        lo = lo(i);
        hi = hi(i);
		break;
    end
end

m = length(lo); % length of input vectors
len = hi - lo + 1; % length of each "run"
n = sum(len); % length of index vector
idx = ones(1, n); % initialize index vector
idx(1) = lo(1);
len(1) = len(1)+1;
idx(cumsum(len(1:end-1))) = lo(2:m) - hi(1:m-1);
idx = cumsum(idx);
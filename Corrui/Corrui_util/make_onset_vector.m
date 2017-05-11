function onset =  make_onset_vector(varargin)
if length(varargin{2}) == 1
    isInTrial_length = varargin{2}; %can be isInTrial or isInTrialCond (really anything that is the same size as isInTrial)
else
    isInTrial_length = length(varargin{2});
end
if nargin == 3
    props = varargin{1};
    enum_props = varargin{3};
    starts = props(:,enum_props.start_index);
elseif nargin == 2
    starts = varargin{1};
end
onset = false(isInTrial_length,1);
onset(starts)=1;
end
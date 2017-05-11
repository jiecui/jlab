function[score] = score_initialize(score_struct)

score_struct.ngauss = 0;  % 0 = uniform scale
score_struct.enabled = 0;
score_struct.initialized = 0;
score_struct.num = 0;
score_struct.result = 0.0;
score_struct.rawScore = 0.0;
score_struct.mu = zeros(1,4);
score_struct.correlation = 0;
score_struct.wduration = 0;
score_struct.outrange = [0 100];
score_struct.inrange = [10 50]; 
score_struct.outliers = 0;	% percent data to eliminate as outliers
score_struct.cliptorange = 1;
score_struct.wSens = zeros(1,3);
score_struct.shape = 0;
score_struct.wsmoothness = 0;
score_struct.wspeed = 0;
score_struct.wnumvelpeaks = 0;
score_struct.subsample = 1;
score_struct.transform = 0;
score_struct.sigma = zeros(1,5);
score_struct.wgauss = zeros(1,5);
score_struct.wTpos = 0;
score_struct.wRpos = 0;
score_struct.wTvel = 0;
score_struct.wRvel = 0;
score_struct.power = 1;

score = score_struct;
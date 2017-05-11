function gl = blend2gl(blendSample)
% first flatten
bs = [0 0 reshape(blendSample',1,12)];
gl = pol2gl(bs);


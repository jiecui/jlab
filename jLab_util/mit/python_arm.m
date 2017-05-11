function armvec = python_arm(s3dat, s2dat)
blendelbow = [0 0 reshape(s2dat',1,12)];
blendwrist = [0 0 reshape(s3dat',1,12)];
[sh, elbow, forearm, wrist, wang, ...
      raw_wrist, raw_elbow, rotw, ...
      forearm_elbow, pshoulder,eshoulder,eelbow,ewrist] = arm_model(pol2gl(blendwrist),pol2gl(blendelbow));
armvec = [pshoulder' eshoulder eelbow ewrist];

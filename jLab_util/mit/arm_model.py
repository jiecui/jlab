import math

#ROTY	Rotation about Y axis
#
#	ROTY(theta) returns a homogeneous transformation representing a 
#	rotation of theta about the Y axis.
#
#	See also ROTX, ROTZ, ROTVEC.

# 	Copyright (C) Peter Corke 1990
function r = roty(t)
	ct = cos(t);
	st = sin(t);
	r =    [ct	0	st	0
		0	1	0	0
		-st	0	ct	0
		0	0	0	1];

def arm_model(wrist, elbow)
# need an arm_data function, lets call it 
# envelopeFlag should tell whether to calculte the wrist frame based on the sensor being on the surface of the envelope object rather
# than the back of the hand
	PALMLEN = 12;%not used
	FOREARMLEN = 30;%not used
	UPPERARMLEN = 30;
   
	SHOULDERWIDTH = 6#not used
	ELBOWWIDTH = 4.5#not used
	WRISTWIDTH = 2.8#not used
	FINGERWIDTH = 4#not used
	PALMASPECT = 0.5#not used
   
	WRISTOFF = 5.5
	WRISTDEPTH = 4.5
	WRISTROT = 10/180*PI
	ELBOWOFF = 12
	ELBOWDEPTH = 7
	ELBOWROT = -10/180*PI



	shoulder = [[0, 0, -1, 0], [0, 1, 0, 0], [1, 0, 0, 0], [0, 0, 0, 1]] # '??

	armdat.raw_wrist = wrist
	armdat.raw_elbow = elbow

	# transform sensors to get wrist and elbow frames

	# ROTATE y-axis -WRISTROT degrees
	wrist = wrist * roty(parms.WRISTROT);
   wrist(1:3,4) = wrist(1:3,4) - wrist(1:3,1).*(ones(1,3)*parms.WRISTOFF)';
   wrist(1:3,4) = wrist(1:3,4) - wrist(1:3,3).*(ones(1,3)*parms.WRISTDEPTH)';
   env1 = wrist;
   env2 = wrist;
   env3 = wrist;
end

elbow = elbow * roty(-parms.ELBOWROT);
elbow(1:3,4) = elbow(1:3,4) + elbow(1:3,1).*(ones(1,3)*parms.ELBOWOFF)';
elbow(1:3,4) = elbow(1:3,4) - elbow(1:3,3).*(ones(1,3)*parms.ELBOWDEPTH)';

% extract elbow-wrist vector, elbow Y Z axes
y = elbow(1:3,2);
z = elbow(1:3,3);
ew = wrist(1:3,4)-elbow(1:3,4);
ew = ew./norm(ew);

elbow(1:3,1:3) = vec2mat3(elbow(1:3,1)',ew);
% now check if elbow has flexed passed 0 degrees. If so,
% output of vec2mat3 will be pointing towards the back
% of the arm and should fail following test. If this is the case,
% I will rotate the elbow by 180 degrees around x-axis
if abs(acos(dot(elbow(1:3,3)',z))) > 5*pi/6
   elbow = elbow*rotx(pi);
end

% also, there is a problem when the elbow flexion angle is low
if abs(acos(dot(elbow(1:3,1)',ew))) < pi/9
   elbow(1:3,2:3) = [y z];
end



% rotate elbow frame around X axis - align forearm with Z axis
%if sum(ew.*z) > 0 
%   al = atan2( sum(ew.*y), sum(ew.*z) )/pi*180;
%else
%   al = atan2( -(sum(ew.*y)), -(sum(ew.*z)) )/pi*180;
%end

% ignore for small angles
%abssum_ew_z = abs(sum(ew.*z))

%if abs(sum(ew.*z)) > 0.3
   
   % pre_al = al
   %al = al * (abs(sum(ew.*z))-0.3) / 0.7
   %elbow = elbow * rotx(-al/180*pi);
%end

% extract wrist axes
x = wrist(1:3,1);
y = wrist(1:3,2);
z = wrist(1:3,3);

% compute cross product X x EW (rotation axis - in wrist frame)
rotw = cross(x,ew);
rotw = [rotw'*x rotw'*y rotw'*z];
rot_wrist = rotw;

% compute rotation angle
wang = acos(sum(x.*ew))/pi*180;
if wang>100.0 
   wang = 100.0;
end
wrist_angle = wang;

% transform to forearm frame
forearm = wrist * rotvec(rotw, wang/180*pi );
% rotate so that neutral position lines up with elbow -- 90 deg for now
supalign = -110/180*pi;
if ~LRhand
   supalign = 110/180*pi;
end
forearm_elbow = forearm * rotx(supalign);

% rotate elbow up 90 degrees since this is better for euler angle
%euler_elbow = elbow * roty(-pi/2);

% compute all euler angles
eshoulder = findeuler( elbow, shoulder, 'B' );
eelbow = findeuler( forearm_elbow, elbow, 'B' );
ewrist = findeuler( wrist, forearm, 'B' );

% compute shoulder position
pshoulder = elbow(1:3,4)-parms.UPPERARMLEN*elbow(1:3,1);
shoulder(1:3,4) = pshoulder;

% correct for pronation/supination -- supination should be positive
eelbow(2) = -eelbow(2);
% correct for L/R
if ~LRhand
	eelbow(3) = -eelbow(3);
end


% now put into struct
armdat.shoulder = shoulder;
armdat.elbow = elbow;
armdat.forearm = forearm;
armdat.wrist = wrist;
armdat.wrist_angle = wrist_angle;
armdat.rot_wrist = rot_wrist;
armdat.forearm_elbow = forearm_elbow;
armdat.pshoulder = pshoulder';
armdat.eshoulder = eshoulder;
armdat.eelbow = eelbow;
armdat.ewrist = ewrist;
armdat.env1 = env1;
armdat.env2 = env2;
armdat.env3 = env3;
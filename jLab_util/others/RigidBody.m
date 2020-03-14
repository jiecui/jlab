% Rigid Body Simulation
% Dan Massie, August 2004
% This is a fully three-dimensional rigid body simulation engine. The
% bodies are unconstrained. Bodies are defined in the Bodies structure and
% forces such as Gravity and Springs are defined in the Forces structure.
% Run the RunSimulation function.

function RunSimulation()
global STATESIZE;

% Initialize the bodies, forces (and eventually constraints)
Bodies = InitBodies;
NumBodies = length(Bodies);
Xo = BodiesToX(Bodies);
Forces = InitForces;

% Run the simulation
disp('PLEASE WAIT...')
ti = 0;
tf = 10;
options = odeset('RelTol',1e-4);
[Time,X] = ode45(@dXdt,[ti tf],Xo,options,Bodies,Forces);

% Interpolate the solution over constant time steps
Xinterp = [];
Tinterp = [ti:0.04:tf];
for t = Tinterp, Xinterp(end+1,:) = interp1(Time,X,t); end

% Plot the position of Bodies over time.
% Assumes rods are colinear and concentric to body y-axis (which is how I
% defined them in the Bodies structure). Need a better way to define a 
% body and its Ibody
for tstep = 1:length(Tinterp)
	clf
	daspect([1 1 1])
	
	% Draw the bodies
	for i = 1:NumBodies
		off = STATESIZE*(i-1);
		halfLen = Bodies(i).len/2;
		x = [Xinterp(tstep,off+1); Xinterp(tstep,off+2); Xinterp(tstep,off+3)];
		R = [Xinterp(tstep,off+4) Xinterp(tstep,off+5) Xinterp(tstep,off+6);
			Xinterp(tstep,off+7) Xinterp(tstep,off+8) Xinterp(tstep,off+9);
			Xinterp(tstep,off+10) Xinterp(tstep,off+11) Xinterp(tstep,off+12)];
		vert1 = R*[0;halfLen;0]+x;
		vert2 = R*[0;-halfLen;0]+x;
		streamtube({[vert1'; vert2']},.1,[1,8])
	end
	
	axis([-2 2 -5 0])
	shading interp;
	camlight; lighting gouraud
	box on
	pause(0.01)
end



function Bodies = InitBodies()
% The Bodies structure defines the properties, states, and intial conditions
% of all the rigid bodies being simulated. For now, the only types of bodies
% supported for graphics are prismatic rods, however, any rigid body maybe defined.
% 
% Constant quantities
% 	.mass					Mass, 1x1 scalar						(kg)
%   .len					Length (of prismatic rod), 1x1 scalar	(m)
% 	.Ibody					Body inertial tensor, 3x3 matrix		(kg-m2)
% 	.Ibodyinv 				Inverse of Ibody, 3x3 matrix			(1/kg-m2)
% State variables (X)
% 	.x 						Position, 3x1 array						(m)
% 	.R						Rotation matrix, 3x3 matrix	
% 	.P						Linear momentum, 3x1 array				(kg-m/sec)
% 	.L 						Rotational momentum, 3x1 array			(kg-rad/sec)
% Derived quatities (auxiliary variables)				
% 	.Iinv					Iverse of world inertial tensor, 3x3 matrix
% 	.v						Linear velocity, 3x1 array				(m/sec)
% 	.omega					Rotationl velocity, 3x1 array			(rad/sec)
% Computed quantities
% 	.force					Net applied force, 3x1 array			(N)
% 	.torque					Net applied torque, 3x1 array			(N-m)

global STATESIZE;
STATESIZE = 18;

% Prismatic Rod, 1 meter long, l kg
Bodies(1).mass 	= 1;
Bodies(1).len 	= 1;
Bodies(1).Ibody = [Bodies(1).len^2/12, 0, 0
			   	   0, 1/1000, 0
		           0, 0, Bodies(1).len^2/12] * Bodies(1).mass;	
Bodies(1).Ibodyinv = inv(Bodies(1).Ibody);
Bodies(1).x 	= [0; 0; 0];
Bodies(1).R 	= [1, 0, 0
			   	   0, 1, 0
		           0, 0, 1];
Bodies(1).P 	= [1; 0; 0];
Bodies(1).L 	= [0; 0; 0];
Bodies(1).Iinv 	= [0, 0, 0
				   0, 0, 0
		           0, 0, 0];
Bodies(1).v 	= [0; 0; 0];
Bodies(1).omega = [0; 0; 0];
Bodies(1).force = [0; 0; 0];
Bodies(1).torque= [0; 0; 0];

% Prismatic Rod, 1 meter long, l kg
Bodies(2).mass 	= 1;
Bodies(2).len 	= 1;
Bodies(2).Ibody = [Bodies(2).len^2/12, 0, 0
			   	   0, 1/1000, 0
		           0, 0, Bodies(2).len^2/12] * Bodies(2).mass;	
Bodies(2).Ibodyinv = inv(Bodies(2).Ibody);
Bodies(2).x 	= [0; -1.5; 0];
Bodies(2).R 	= [1, 0, 0
			   	   0, 1, 0
		           0, 0, 1];
Bodies(2).P 	= [-1; 0; 0];
Bodies(2).L 	= [0; 0; 0];
Bodies(2).Iinv 	= [0, 0, 0
				   0, 0, 0
		           0, 0, 0];
Bodies(2).v 	= [0; 0; 0];
Bodies(2).omega = [0; 0; 0];
Bodies(2).force = [0; 0; 0];
Bodies(2).torque= [0; 0; 0];

% Prismatic Rod, 1 meter long, l kg
Bodies(3).mass 	= 1;
Bodies(3).len 	= 1;
Bodies(3).Ibody = [Bodies(3).len^2/12, 0, 0
			   	   0, 1/1000, 0
		           0, 0, Bodies(3).len^2/12] * Bodies(3).mass;	
Bodies(3).Ibodyinv = inv(Bodies(3).Ibody);
Bodies(3).x 	= [0; -3; 0];
Bodies(3).R 	= [1, 0, 0
			   	   0, 1, 0
		           0, 0, 1];
Bodies(3).P 	= [-2; 0; 0];
Bodies(3).L 	= [0; 0; 0];
Bodies(3).Iinv 	= [0, 0, 0
				   0, 0, 0
		           0, 0, 0];
Bodies(3).v 	= [0; 0; 0];
Bodies(3).omega = [0; 0; 0];
Bodies(3).force = [0; 0; 0];
Bodies(3).torque= [0; 0; 0];


function Forces = InitForces()
% The Forces structure is used to keep track of forces being applied to the
% bodies. The ComputeForcesAndTorques function uses this structure to
% compute forces and torques on all the bodies at a given time step. Right
% now only gravity and spring forces are used, but any kind of force may be
% defined.
% 	.type				Type of force object
%	.params				Parameters for the force function
%	.bodies				Bodies operated on by the force object
%		.num			The location of body in Bodies structure array
%		.loc			Location in body space where force is applied
%
% 	Notes:	- Gravity forces are automatically applied to all bodies.
%			- Spring forces may only exist between two bodies.
%           - For springs, if bodies.num is 0, then one end of the spring is
%             attached to a fixed location in world space.

Forces(1).type = 'Gravity';
Forces(1).params = {0};
Forces(1).bodies(1).num = 0;
Forces(1).bodies(1).loc = [0;0;0];

Forces(2).type = 'Spring';
Forces(2).params = {[0;0;0],[0;0;0],[0;0;0],[0;0;0],50,1,0};
Forces(2).bodies(1).num = 0;
Forces(2).bodies(1).loc = [0;0;0];
Forces(2).bodies(2).num = 1;
Forces(2).bodies(2).loc = [0;0.5;0];

Forces(3).type = 'Spring';
Forces(3).params = {[0;0;0],[0;0;0],[0;0;0],[0;0;0],50,1,0};
Forces(3).bodies(1).num = 1;
Forces(3).bodies(1).loc = [0;-0.5;0];
Forces(3).bodies(2).num = 2;
Forces(3).bodies(2).loc = [0;0.5;0];

Forces(4).type = 'Spring';
Forces(4).params = {[0;0;0],[0;0;0],[0;0;0],[0;0;0],50,1,0};
Forces(4).bodies(1).num = 2;
Forces(4).bodies(1).loc = [0;-0.5;0];
Forces(4).bodies(2).num = 3;
Forces(4).bodies(2).loc = [0;0.5;0];


% dXdt calculates the dirivative of the states for all rigid bodies
function Xdot = dXdt(t,X,Bodies,Forces)
NumForces = length(Forces);
NumBodies = length(Bodies);
% Put data in X into Bodies
Bodies = XToBodies(X,Bodies);
% Compute the net forces and torques on all rigid bodies at current time
for i = 1:NumBodies
	Bodies(i).force = [0;0;0];
	Bodies(i).torque = [0;0;0];
end
for i = 1:NumForces
	Bodies = ComputeForceAndTorque(t,Bodies,Forces(i));
end
% Evaluate the state variable differentials
Xdot = [];
for i = 1:NumBodies
	for j = 1:3, Xdot(end+1,1) = Bodies(i).v(j); end					% dxdt = velocity
	Rdot = Star(Bodies(i).omega) * Bodies(i).R;							% dRdt = star(omega)*R
	for j = 1:3, for k = 1:3, Xdot(end+1,1) = Rdot(j,k); end; end 
	for j = 1:3, Xdot(end+1,1) = Bodies(i).force(j); end				% dPdt = force
	for j = 1:3, Xdot(end+1,1) = Bodies(i).torque(j); end				% dLdt = torque
end


function Bodies = XToBodies(X,Bodies)
global STATESIZE;
NumBodies = length(Bodies);
for i=1:NumBodies
	% Put data in X into Bodies
	off = STATESIZE*(i-1);
	Bodies(i).x = [X(off+1); X(off+2); X(off+3)];
	Bodies(i).R = [X(off+4) X(off+5) X(off+6);
				   X(off+7) X(off+8) X(off+9);
			       X(off+10) X(off+11) X(off+12)];
    Bodies(i).P = [X(off+13); X(off+14); X(off+15)];
	Bodies(i).L = [X(off+16); X(off+17); X(off+18)];
	% Compute initial auxiliary variables
	Bodies(i).v = Bodies(i).P / Bodies(i).mass;							% Linear velocity
	Bodies(i).Iinv = Bodies(i).R * Bodies(i).Ibodyinv * Bodies(i).R';	% World inertial tensor
	Bodies(i).omega = Bodies(i).Iinv * Bodies(i).L;						% Angular velocity
end

function X = BodiesToX(Bodies)
X = [];
NumBodies = length(Bodies);
for i=1:NumBodies
	% Put data in Bodies into X
	for j = 1:3, X(end+1,1) = Bodies(i).x(j); end
	for j = 1:3, for k = 1:3, X(end+1,1) = Bodies(i).R(j,k); end; end
	for j = 1:3, X(end+1,1) = Bodies(i).P(j); end
	for j = 1:3, X(end+1,1) = Bodies(i).L(j); end
end

function b = Star(a)
b = [ 0   -a(3)   a(2)
    a(3)     0   -a(1)
   -a(2)   a(1)     0 ];


function Bodies = ComputeForceAndTorque(t,Bodies,Force)
switch Force.type
	case 'Gravity'
		% Gravity automatically applies to all bodies
		for i = 1:length(Bodies)
			F = feval(@GravityForce,Bodies(i).mass);
			Bodies(i).force = F + Bodies(i).force;
		end
	case 'Spring'
		for i = 1:2
			if Force.bodies(i).num > 0
				x(:,i) = Bodies(Force.bodies(i).num).x;
				v(:,i) = Bodies(Force.bodies(i).num).v;
				R(:,:,i) = Bodies(Force.bodies(i).num).R;
				omega(:,i) = Bodies(Force.bodies(i).num).omega;
				p(:,i) = Force.bodies(i).loc;
			else % fixed relative to world space
				x(:,i) = [0;0;0];
				v(:,i) = [0;0;0];
				R(:,:,i) = [1,0,0;0,1,0;0,0,1];
				omega(:,i) = [0;0;0];
				p(:,i) = Force.bodies(i).loc;
			end
		end
		Force.params{1} = R(:,:,1)*p(:,1) + x(:,1);
		Force.params{2} = R(:,:,2)*p(:,2) + x(:,2);
		Force.params{3} = cross(omega(:,1),R(:,:,1)*p(:,1)) + v(:,1);
		Force.params{4} = cross(omega(:,2),R(:,:,2)*p(:,2)) + v(:,2);
		F(:,1) = feval(@SpringForce,Force.params);
		F(:,2) = -F(:,1);
		for i = 1:2
			if Force.bodies(i).num > 0
				T(:,i) = cross(R(:,:,i)*p(:,i),F(:,i));
				Bodies(Force.bodies(i).num).force = F(:,i) + Bodies(Force.bodies(i).num).force;
				Bodies(Force.bodies(i).num).torque = T(:,i) + Bodies(Force.bodies(i).num).torque;
			end
		end
end


function F = SpringForce(args)
% Calculates force applied by the spring onto body at x1
% x1 = position of spring body connection		(m)
% x2 = position of other end of the spring		(m)
% v1 = velocity of spring body connection		(m/sec)
% v2 = velocity of other end of the spring		(m/sec)
% ks = linear spring constant					(N/m)
% kd = viscous damping constant					(N-sec/m)
% r = unstretched length of spring				(m)
x1 = args{1}; x2 = args{2}; v1 = args{3}; v2 = args{4};
ks = args{5}; kd = args{6}; r = args{7};
s = x1-x2;
sdot = v1-v2;
F = -(ks*(norm(s)-r) + kd*(dot(sdot,s)/norm(s)))*s/norm(s);


function F = GravityForce(m)
% Calculates force of gravity on the body's cg
% m = body's mass								(kg)
F = [0; -9.80665*m; 0];

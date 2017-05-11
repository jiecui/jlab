%PUMA560AKB	Load kinematic and dynamic data for a Puma 560 manipulator
%
%	Defines the matrix 'p560' which describes the kinematic and dynamic
%	characterstics of a Unimation Puma 560 manipulator using the data and
%	conventions of
%
%		Armstrong, Khatib and Burdick 1986.
%		"The Explicit Dynamic Model and Inertial Parameters of the Puma 560 Arm"
%
%	See also PUMA560, DH, DYN, TWOLINK, STANFORD.

%	Copright (C) Peter Corke 1990

p560akb = [
% alpha	A	theta	D	sigma	m	rx	ry	rz	Ixx	Iyy	Izz	Ixy	Iyz	Ixz	Jm	G
0	0	0	0	0	0	0	0	0	0	0	0.35	0	0	0	291e-6	-62.6111
-pi/2	0	0	0.2435	0	17.4	0.068	0.006	-0.016	.13	.524	.539	0	0	0	409e-6	107.815
0	0.4318	0	-0.0934	0	4.8	0	-0.070	0.014	.066	.0125	.066	0	0	0	299e-6	-53.7063
pi/2	-0.0203	0	.4331	0	0.82	0	0	-0.019	1.8e-3	1.8e-3	1.3e-3	0	0	0	35e-6	76.0364
-pi/2	0	0	0	0	0.34	0	0	0	.3e-3	.3e-3	.4e-3	0	0	0	35e-6	71.923
pi/2	0	0	0	0	.09	0	0	.032	.15e-3	.15e-3	.04e-3	0	0	0	35e-6	76.686
];

%
% some useful poses
%
qz = [0 0 0 0 0 0];	% zero angles, L shaped pose
qr = [0 pi/2 -pi/2 0 0 0];	% ready pose, arm up
qstretch = [0 0 -pi/2 0 0 0];

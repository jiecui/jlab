function[trans] = multseparate(t1, t2)
% t2 = t1 x t2: (R1 T1)*(R2 T2) -> (R1*R2 T1+T2)

% multiply rotation matrices
res = ones(4);
res = t1(1:3,1:3)*t2(1:3,1:3);

% assign rotation to t2
t2(1:3,1:3) = res(1:3,1:3);

% compute translation
t2(4,1:3) = t2(4,1:3) + t1(4,1:3);

% normalize transformation:
e1 = t2(1,1:3);
e2 = t2(2,1:3);
e3 = t2(3,1:3);

e1 = (1/sqrt(sum(e1.^2)))*e1;

e2 = (1/sqrt(sum(e2.^2)))*e2;
e2 = e2 - (e1.*e2).*e1;
e2 = (1.0/sqrt(sum(e2.^2)))*e2;

e3 = (1.0/sqrt(sum(e3.^2)))*e3;
e3 = e3 - (e1.*e3).*e1;
e3 = (1.0/sqrt(sum(e3.^2)))*e3;
e3 = e3 - (e2.*e3).*e2;
e3 = (1.0/sqrt(sum(e3.^2)))*e3;

% assign normalized transformation
t2(1,1:3) = e1;
t2(2,1:3) = e2;
t2(3,1:3) = e3;

trans = t2;

function r = glrotatef(ang,x,y,z)

v = [x;y;z];
u=v.*(1.0/(sqrt(sum(v.^2))));
s=[0 -u(3) -u(2);u(3) 0 -u(1);-u(2) u(1) 0];
m=(u*u')+cos(ang)*(eye(3)-(u*u'))+(sin(ang)*s);
r = eye(4);
r(1:3,1:3)=m;

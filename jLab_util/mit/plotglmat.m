function plotglmat(glmat)

quiver3(glmat(1,4),glmat(2,4),glmat(3,4),glmat(1,1)*5, glmat(2,1)*5, glmat(3,1)*5, 0, 'r'); hold on;
quiver3(glmat(1,4),glmat(2,4),glmat(3,4),glmat(1,2)*5, glmat(2,2)*5, glmat(3,2)*5, 0, 'y'); hold on;
quiver3(glmat(1,4),glmat(2,4),glmat(3,4),glmat(1,3)*5, glmat(2,3)*5, glmat(3,3)*5, 0, 'm'); hold on;

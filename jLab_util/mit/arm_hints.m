% hints on how to access the arm_data!
% remember, kinematix code is in C:\Users\src.zip
for i=1:15:100,plot_limbs(si,1,i,1,1);hold on; end;hold off;
plot(si.arm_data(1).wrst(:,1:3,3));hold on;legend('1','2','3');hold off;
load(name);

figure; title('3D paths');

plot3(-MI(:,2),-MI(:,1),-MI(:,3),'r.'); hold on;

for i=1:cnt
   point = squeeze(P{i}(1,:,:)) + 5*squeeze(X{i}(1,:,:));  
   plot3(-point(:,2),-point(:,1),-point(:,3),'b.'); 
end;

xlabel('Lateral');
ylabel('Forward');
zlabel('Vertical');
set(gca,'box','on');
hold on;
rotate3d on;

   
figure;

for i=1:3
   plot(V{i}(1,:)); hold on;
end;


% display targets and paths
figure; orient tall;

subplot(2,1,2);
plot3(-TP(:,2),-TP(:,3),TP(:,1),'ro'); hold on;

for i=1:cnt
   set(plot3(-HP{i}(:,2),-HP{i}(:,3),HP{i}(:,1),'.'),'markersize',.1);
%   set(plot3(-HP{i}(:,2),-HP{i}(:,3),HP{i}(:,1)),'linewidth',0.01);
%   plot3(HP{i}(N(i),1),HP{i}(N(i),2),HP{i}(N(i),3),'g*');
end;

axis image; 
xlabel('Right'); ylabel('Forward'); zlabel('Up');
set(gca,'box','on');
rotate3d on;


% display speed profiles
load wdla4;
for i=1:4
   subplot(4,2,i); plot(HV{40+i}); axis([0 130 0 8]);
end;

load wdra4;
for i=1:4
   subplot(4,2,i+4); plot(HV{40+i}); axis([0 130 0 8]);
end;
